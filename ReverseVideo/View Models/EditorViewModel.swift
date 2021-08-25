//
//  EditorViewModel.swift
//  ReverseVideo
//
//  Created by Sheheryar Ahmed on 09/05/2021.
//

import UIKit
import Photos

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
    var currentSpeed: Float = 1.0
    var currentFilterKey: String?
    let features: [Feature] = [Feature(fType: .reverse), Feature(fType: .speed), Feature(fType: .filters)/*, Feature(fType: .text), Feature(fType: .audio)*/]
    let featureImages: [UIImage?] = [.reverseIcon, .speedIcon, .filterIcon/*, .textIcon, .audioIcon*/]
    
    
    // MARK: - Private Methods
    func reverseVideo(from url: URL, completion: @escaping (Result<URL, Error>) -> Void)  {
        VideoGenerator.current.reverseVideo(fromVideo: originalVideoUrl) { result in
            switch result {
            case .success(let url):
                completion(.success(url))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func applyReverse() {
        if let reverseFeature = self.features.first(where: {$0.type == .reverse}),  reverseFeature.isApplied {
            
            VideoGenerator.current.reverseVideo(fromVideo: originalVideoUrl) { result in
                switch result {
                case .success(let url):
                    self.applySlowMo(to: url)
                case .failure(let error):
                    print("failure")
                }
            }
        } else {
            applySlowMo(to: originalVideoUrl)
        }
    }
    
    private func applySlowMo(to url: URL) {
        if let slowMofeature = self.features.first(where: {$0.type == .speed}), slowMofeature.isApplied {
            
            VideoGenerator.current.videoScaleAssetSpeed(fromURL: url, by: Float64(currentSpeed)) { result in
                switch result {
                case .success(let url):
                    self.applyFilter(to: url)
                case .failure(let error):
                    break
                }
            }
        } else {
            applyFilter(to: url)
        }
    }
    
    private func applyFilter(to url: URL) {
        if let filtersFeature = self.features.first(where: {$0.type == .filters}), filtersFeature.isApplied {
            
        } else {
            // Done Processing
        }
    }
    
    // MARK: - Public Methods
    func applyFilterToComposition(filterKey: String, asset: AVAsset) -> AVVideoComposition? {
        guard let filter = CIFilter(name: filterKey) else { return nil}
        
        let composition = AVVideoComposition(asset: asset, applyingCIFiltersWithHandler: { request in

            // Clamp to avoid blurring transparent pixels at the image edges
            let source = request.sourceImage.clampedToExtent()
            filter.setValue(source, forKey: kCIInputImageKey)
            
            // Crop the blurred output to the bounds of the original image
            let output = filter.outputImage!.cropped(to: request.sourceImage.extent)

            // Provide the filter output to the composition
            request.finish(with: output, context: nil)
        })

        return composition
    }
    
    func applyFeatures() {
      applyReverse()
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
