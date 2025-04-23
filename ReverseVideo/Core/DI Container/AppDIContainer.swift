//
//  Untitled.swift
//  ReverseVideo
//
//  Created by Sheheryar Ahmed on 19/04/2025.
//


import Foundation

final class AppDIContainer {
    
    // MARK: - Shared Dependencies
    lazy var userDefaults: UserDefaults = {
        .standard
    }()
    
    // MARK: - Feature DI Containers
    func makeGalleryDIContainer() -> GalleryDIContainer {
        return GalleryDIContainer(
            dependencies: GalleryDIContainer.Dependencies()
        )
    }
}
