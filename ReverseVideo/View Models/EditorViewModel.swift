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
    var currentFilter: FilterType?
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
    
    
    private func applySlowMo(to url: URL, completion: @escaping (Result<URL, Error>) -> Void) {
        if let slowMofeature = self.features.first(where: {$0.type == .speed}), slowMofeature.isApplied {
            
            VideoGenerator.current.videoScaleAssetSpeed(fromURL: url, by: Float64(currentSpeed)) { result in
                switch result {
                case .success(let modifiedUrl):
                    self.applyFilter(to: modifiedUrl) { result in
                        switch result {
                        case .success(let filterAppliedUrl):
                            completion(.success(filterAppliedUrl))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } else {
            applyFilter(to: url) { result in
                switch result {
                case .success(let filterAppliedUrl):
                    completion(.success(filterAppliedUrl))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    private func applyFilter(to url: URL, completion:@escaping (Result<URL, Error>) -> Void) {
        if let filtersFeature = self.features.first(where: {$0.type == .filters}), filtersFeature.isApplied, let key = currentFilter?.key {
            var asset = AVAsset(url: url)
            let composition = applyFilterToComposition(filterKey: key, asset: asset)
            
            guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                return
            }
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .long
            dateFormatter.timeStyle = .short
            let date = dateFormatter.string(from: Date())
            let exportUrl = documentDirectory.appendingPathComponent("reverseVideo-\(date).mov")
            do { // delete old video
                try FileManager.default.removeItem(at: exportUrl)
            } catch { print(error.localizedDescription) }
            
            guard let export = AVAssetExportSession(asset: asset, presetName: AVAssetExportPreset1920x1080) else { return }
            export.outputFileType = AVFileType.mov
            export.outputURL = exportUrl
            export.videoComposition = composition
            
            export.exportAsynchronously(completionHandler: {
                switch export.status {
                case .completed:
                    completion(.success(exportUrl))
                case .failed, .cancelled:
                    completion(.failure(export.error as! Error))
                    break
                default:
                    break
                }
            })
        } else {
            completion(.success(url))
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
    
    func applyFeatures(completion: @escaping (Result<String ,Error>) -> Void) {
        applySlowMo(to: videoUrl) { [self] result in
            switch result {
            case .success(let url):
                SaveVideoToPhotos(url: url) { result in
                    switch result {
                    case .success(let message):
                        completion(.success(message))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
                
            case .failure(let error):
                completion(.failure(error))
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
