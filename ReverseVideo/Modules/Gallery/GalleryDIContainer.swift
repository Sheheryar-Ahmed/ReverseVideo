//
//  GalleryDIContainer.swift
//  ReverseVideo
//
//  Created by Sheheryar Ahmed on 23/04/2025.
//

import UIKit

final class GalleryDIContainer {

    struct Dependencies {}

    private let dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    func makeGalleryViewController() -> GalleryViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "GalleryViewController") as? GalleryViewController else {
            fatalError("GalleryViewController not found in Main.storyboard")
        }

        return vc
    }

    func makeGalleryViewModel() -> GalleryViewModel {
        return GalleryViewModel()
    }

    func makeGalleryCoordinator(navigationController: UINavigationController) -> GalleryCoordinator {
        return GalleryCoordinator(
            navigationController: navigationController,
            galleryDIContainer: self
        )
    }
}

