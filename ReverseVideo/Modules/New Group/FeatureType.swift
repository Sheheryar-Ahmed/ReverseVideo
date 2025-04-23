//
//  FeatureType.swift
//  ReverseVideo
//
//  Created by Sheheryar Ahmed on 25/08/2021.
//

import Foundation

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
