//
//  FilterViewModel.swift
//  ReverseVideo
//
//  Created by Sheheryar Ahmed on 28/06/2021.
//

import Foundation
import UIKit

class FilterViewModel {
    let filterTypes: [FilterType] = [.PhotoEffectChrome, .PhotoEffectFade, .PhotoEffectInstant, .PhotoEffectMono,.PhotoEffectNoir, .PhotoEffectTonal, .PhotoEffectProcess, .PhotoEffectTransfer, .SepiaTone, .ColorMonochrome]
    
    func cgImage(from ciImage: CIImage) -> CGImage? {
        let context = CIContext(options: nil)
        return context.createCGImage(ciImage, from: ciImage.extent)
    }
    
    // old way of getting filtered image by applying filter to each image
//    func getFilterImages() {
//        guard let filterThumbnail = UIImage.filterGirl, let ciThumbnailImage = CIImage(image: filterThumbnail) else { return }
//
//        // 1st
////        if let image = CIFilter.colorCrossPolynomial(inputImage: ciThumbnailImage)?.outputImage {
////            filterImages[0] = image
//        //// // saving image locally
//////            guard let cgImage = cgImage(from: image) else { return } // the above function
//////
//////            let newImage = UIImage(cgImage: cgImage)
//////            UIImageWriteToSavedPhotosAlbum(newImage, nil, nil, nil)
////
////
////        }
//
//        // 2nd
//        if let image = CIFilter.colorMonochrome(inputImage: ciThumbnailImage, inputColor: CIColor.red)?.outputImage {
//            filterImages[1] = image
//        }
//
//        // 3rd
//        if let image = CIFilter.photoEffectChrome(inputImage: ciThumbnailImage)?.outputImage {
//            filterImages[2] = image
//        }
//
//        // 4th
//        if let image = CIFilter.photoEffectFade(inputImage: ciThumbnailImage)?.outputImage {
//            filterImages[3] = image
//        }
//
//        // 5th
//        if let image = CIFilter.photoEffectInstant(inputImage: ciThumbnailImage)?.outputImage {
//            filterImages[4] = image
//        }
//
//        // 6th
//        if let image = CIFilter.photoEffectMono(inputImage: ciThumbnailImage)?.outputImage {
//            filterImages[5] = image
//        }
//
//        // 7th
//        if let image = CIFilter.photoEffectNoir(inputImage: ciThumbnailImage)?.outputImage {
//            filterImages[6] = image
//        }
//
//        // 8th
//        if let image = CIFilter.photoEffectProcess(inputImage: ciThumbnailImage)?.outputImage {
//            filterImages[7] = image
//        }
//
//        // 9th
//        if let image = CIFilter.photoEffectTonal(inputImage: ciThumbnailImage)?.outputImage {
//            filterImages[8] = image
//        }
//
//        // 10th
//        if let image = CIFilter.photoEffectTransfer(inputImage: ciThumbnailImage)?.outputImage {
//            filterImages[9] = image
//        }
//
//        // 11th
//        if let image = CIFilter.sepiaTone(inputImage: ciThumbnailImage)?.outputImage {
//            filterImages[10] = image
//        }
//    }
}
