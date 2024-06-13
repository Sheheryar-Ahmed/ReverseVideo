//
//  GalleryViewModel.swift
//  ReverseVideo
//
//  Created by Sheheryar Ahmed on 10/10/2021.
//

import UIKit
import Photos

protocol GalleryViewModelDelegate: AnyObject {
    func didFetchAlbums()
    func handleLimitedAccess()
    func didFailToFetchAlbums()
    func noAlbumsFound()
}

class GalleryViewModel {
    
    // MARK: - Properties
    var albums = [Album]()
    var currentAlbum: Album?
    var currentAsset: AVURLAsset?
    weak var delegate: GalleryViewModelDelegate?
    var currentPhotoAuthStatus: PHAuthorizationStatus?
    
    // MARK: - Helper Methods
    func loadAlbums() {
        // Ask user to allow access of Photos if he doesn't have already
        if #available(iOS 14, *) {
            let accessLevel: PHAccessLevel = .readWrite
            let status = PHPhotoLibrary.authorizationStatus(for: accessLevel)
            
            if status == .notDetermined {
                
                PHPhotoLibrary.requestAuthorization(for: accessLevel) { status in
                    
                    DispatchQueue.main.async { [self] in
                        if status == .limited {
                            currentPhotoAuthStatus = .limited
                            self.delegate?.handleLimitedAccess()
                            self.fetchAlbums()
                        } else if status == .authorized {
                            currentPhotoAuthStatus = .authorized
                            self.fetchAlbums()
                        } else {
                            self.delegate?.didFailToFetchAlbums()
                        }
                    }
                }
            } else if status == .limited {
                currentPhotoAuthStatus = .limited
                self.delegate?.handleLimitedAccess()
                fetchAlbums()
            } else if status == .authorized {
                currentPhotoAuthStatus = .authorized
                fetchAlbums()
            } else if status == .denied {
                currentPhotoAuthStatus = .denied
                self.delegate?.didFailToFetchAlbums()
            }
        } else {
            let status = PHPhotoLibrary.authorizationStatus()
            
            if status == .notDetermined {
                
                PHPhotoLibrary.requestAuthorization { status in
                    
                    DispatchQueue.main.async {
                        if status == .authorized {
                            self.currentPhotoAuthStatus = .authorized
                            self.fetchAlbums()
                        } else {
                            self.delegate?.didFailToFetchAlbums()
                        }
                    }
                }
            } else if status == .authorized {
                currentPhotoAuthStatus = .authorized
                fetchAlbums()
            } else if status == .denied {
                currentPhotoAuthStatus = .denied
                self.delegate?.didFailToFetchAlbums()
            }
        }
        let status = PHPhotoLibrary.authorizationStatus()
        
        if status == .notDetermined {
            
            PHPhotoLibrary.requestAuthorization { status in
                
                DispatchQueue.main.async {
                    if status == .authorized {
                        self.currentPhotoAuthStatus = .authorized
                        self.fetchAlbums()
                    } else {
                        self.delegate?.didFailToFetchAlbums()
                    }
                }
            }
        }
//        }  if status == .authorized {
//            fetchAlbums()
//            print("zain8")
//        } else if status == .denied {
//            selseelf.delegate?.didFailToFetchAlbums()
//        }
    }
    
    func fetchAlbums() {
        var collections = [PHAssetCollection]()
        
        let smartAlbumFavorites = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumFavorites, options: nil)
        if let recentsCollection = smartAlbumFavorites.firstObject {
            collections.insert(recentsCollection, at: 0)
        }
        
        let smartAlbumCollections = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .any, options: nil)
        if let recentsCollection = smartAlbumCollections.firstObject {
            collections.insert(recentsCollection, at: 0)
        }
        
        let albumCollections = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: nil)
        
        if albumCollections.count > 0 {
            albumCollections.enumerateObjects { (collection, index, _) in
                collections.append(collection)
                
                if index == albumCollections.count - 1 {
                    self.getAssetsFromCollections(collections: collections)
                }
            }
        } else {
            self.getAssetsFromCollections(collections: collections)
        }
    }
    
    func getAssetsFromCollections(collections: [PHAssetCollection]) {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.video.rawValue)
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: RVConstants.keys.creationDate, ascending: true)]
        var count = 0
        albums = [Album]()
        
        for collection in collections {
            let fetchResult = PHAsset.fetchAssets(in: collection, options: fetchOptions)
            
            if let asset = fetchResult.lastObject {
                count += 1

                let _ = UIImage.fetchFromPhotos(asset: asset, contentMode: .aspectFill, targetSize: CGSize(width: 200, height: 200)) { (image) in

                    let newAlbum = Album(image: image, name: collection.localizedTitle, assets: fetchResult)
                    self.albums.append(newAlbum)

                    if count == self.albums.count {
                        if let index = self.albums.firstIndex(where: { $0.name == "Favorites" }) {
                            let favoritesAlbum = self.albums.remove(at: index)
                            self.albums.insert(favoritesAlbum, at: 0)
                        }

                        if let index = self.albums.firstIndex(where: { $0.name == "Recents" }) {
                            let recentsAlbum = self.albums.remove(at: index)
                            self.albums.insert(recentsAlbum, at: 0)
                        }

                        self.delegate?.didFetchAlbums()
                    }
                }
            }
        }
        
        if count == 0 {
            self.delegate?.noAlbumsFound()
        }
    }
    
    func requestAsset(asset: PHAsset, completion: @escaping (AVURLAsset?) -> Void) {
        
        PHCachingImageManager().requestAVAsset(forVideo: asset, options: nil) { (assets, audioMix, info) in
                    let outputAsset = assets as? AVURLAsset
                   completion(outputAsset)
                }
    }
}
