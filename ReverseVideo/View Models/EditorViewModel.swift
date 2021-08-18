//
//  EditorViewModel.swift
//  ReverseVideo
//
//  Created by Sheheryar Ahmed on 09/05/2021.
//

import UIKit
import Photos

enum FeatureType {
    case reverse
    case speed
    case audio
    case filters
    case text
    
    var name: String {
        switch self {
        case .reverse:
            return "Reverse"
        case .speed:
            return "Speed"
        case .audio:
            return "Audio"
        case .filters:
            return "Filters"
        case .text:
            return "Text"
        }
    }
}

class Feature {
    var type: FeatureType
    var isApplied: Bool = false
    
    // MARK: - Initializers
    init(fType: FeatureType) {
        self.type = fType
    }
}

class EditorViewModel {
    
    // MARK: - Properties
    var originalVideoUrl: URL!
    var videoUrl: URL!
    let features: [Feature] = [Feature(fType: .reverse), Feature(fType: .speed), Feature(fType: .filters)/*, Feature(fType: .text), Feature(fType: .audio)*/]
    let featureImages: [UIImage?] = [.reverseIcon, .speedIcon, .filterIcon/*, .textIcon, .audioIcon*/]
    
    // MARK: - Methods
    func applyFeatures() {
        for feature in features {
            switch feature.type {
            case .reverse:
                if feature.isApplied {
                    VideoGenerator.current.reverseVideo(fromVideo: originalVideoUrl) { result in
                        switch result {
                        case .success(let url):
                            print("sucess")
                        case .failure(let error):
                            print("failure")
                        }
                    }
                }
            case .speed:
                print("speed")
                break
            case .audio:
                print("audio")
                break
            case .filters:
                print("filters")
                break
            case .text:
                break
            }
        }
    }
    
    func exportVideo(withSpeed: Float, videoUrl: URL, completion: @escaping (Result<String, Error>) -> Void) {
        
        VideoGenerator.current.reverseVideo(fromVideo: videoUrl) { (result) in
            
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let url) :
                self.SaveVideoToPhotos(url: url) { (result) in
                    switch result {
                    case .success(let message):
                        completion(.success(message))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    func SaveVideoToPhotos(url: URL, completion: @escaping (Result<String, Error>) -> Void) {
        let saveVideoToPhotos = {
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
            }) { saved, error in
                
                if let error = error, saved == false {
                    completion(.failure(error))
                } else {
                    completion(.success("Video saved"))
                }
            }
        }
        
        //  Ensure permission to access Photo Library
        if PHPhotoLibrary.authorizationStatus() != .authorized {
            PHPhotoLibrary.requestAuthorization { status in
                if status == .authorized {
                    saveVideoToPhotos()
                }
            }
        } else {
            saveVideoToPhotos()
        }
    }
}
