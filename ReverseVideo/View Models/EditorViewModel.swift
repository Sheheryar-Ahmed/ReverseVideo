//
//  EditorViewModel.swift
//  ReverseVideo
//
//  Created by Sheheryar Ahmed on 09/05/2021.
//

import UIKit
import Photos

class EditorViewModel {
    
    // MARK: - Properties
   
    let features = ["Reverse", "Speed", "Audio", "Filters", "Text"]
    let featureImages: [UIImage?] = [.reverseIcon, .speedIcon, .audioIcon, .filterIcon, .textIcon]
    
    // MARK: - Methods
    func exportVideo(withSpeed: Float, videoUrl: URL, completion: @escaping (Result<String, Error>) -> Void) {
        
        VideoGenerator.current.reverseVideo(fromVideo: videoUrl, withSpeed: withSpeed) { (result) in
            
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
