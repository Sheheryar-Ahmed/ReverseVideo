//
//  FilterType.swift
//  ReverseVideo
//
//  Created by Sheheryar Ahmed on 25/08/2021.
//

import Foundation

enum FilterType {
    case ColorCrossPolynomial
    case ColorCube
    case ColorCubeWithColorSpace
    case ColorMonochrome
    case PhotoEffectChrome
    case PhotoEffectFade
    case PhotoEffectInstant
    case PhotoEffectMono
    case PhotoEffectNoir
    case PhotoEffectProcess
    case PhotoEffectTonal
    case PhotoEffectTransfer
    case SepiaTone
    
    var isPro: Bool {
        switch self {
        case .ColorCrossPolynomial:
            return false
        case .ColorCube:
            return true
        case .ColorCubeWithColorSpace:
            return true
        case .ColorMonochrome:
            return true
        case .PhotoEffectChrome:
            return true
        case .PhotoEffectFade:
            return true
        case .PhotoEffectInstant:
            return true
        case .PhotoEffectMono:
            return true
        case .PhotoEffectNoir:
            return true
        case .PhotoEffectProcess:
            return true
        case .PhotoEffectTonal:
            return true
        case .PhotoEffectTransfer:
            return true
        case .SepiaTone:
            return true
        }
    }
    
    var key: String {
        switch self {
        case .ColorCrossPolynomial:
            return "CIColorCrossPolynomial"
        case .ColorCube:
            return "CIColorCube"
        case .ColorCubeWithColorSpace:
            return "CIColorCubeWithColorSpace"
        case .ColorMonochrome:
            return "CIColorMonochrome"
        case .PhotoEffectChrome:
            return "CIPhotoEffectChrome"
        case .PhotoEffectFade:
            return "CIPhotoEffectFade"
        case .PhotoEffectInstant:
            return "CIPhotoEffectInstant"
        case .PhotoEffectMono:
            return "CIPhotoEffectMono"
        case .PhotoEffectNoir:
            return "CIPhotoEffectNoir"
        case .PhotoEffectProcess:
            return "CIPhotoEffectProcess"
        case .PhotoEffectTonal:
            return "CIPhotoEffectTonal"
        case .PhotoEffectTransfer:
            return "CIPhotoEffectTransfer"
        case .SepiaTone:
            return "CISepiaTone"
        }
    }
    
    
    var name: String {
        switch self {
        case .ColorCrossPolynomial:
            return "Polynomial"
        case .ColorCube:
            return "ColorCube"
        case .ColorCubeWithColorSpace:
            return "ColorSpace"
        case .ColorMonochrome:
            return "Monochrome"
        case .PhotoEffectChrome:
            return "Chrome"
        case .PhotoEffectFade:
            return "Fade"
        case .PhotoEffectInstant:
            return "Instant"
        case .PhotoEffectMono:
            return "Mono"
        case .PhotoEffectNoir:
            return "Noir"
        case .PhotoEffectProcess:
            return "Process"
        case .PhotoEffectTonal:
            return "Tonal"
        case .PhotoEffectTransfer:
            return "Transfer"
        case .SepiaTone:
            return "Sepia"
        }
    }
}
