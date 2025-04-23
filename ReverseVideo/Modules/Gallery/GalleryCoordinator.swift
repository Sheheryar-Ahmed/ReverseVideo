//
//  GalleryCoordinator.swift
//  ReverseVideo
//
//  Created by Sheheryar Ahmed on 23/04/2025.
//

import UIKit

final class GalleryCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    let galleryDIContainer: GalleryDIContainer
    
    init(
        navigationController: UINavigationController,
        galleryDIContainer: GalleryDIContainer
    ) {
        self.navigationController = navigationController
        self.galleryDIContainer = galleryDIContainer
    }
    
    func start() {
        let galleryVC = galleryDIContainer.makeGalleryViewController()
        navigationController.pushViewController(galleryVC, animated: false)
    }
}
