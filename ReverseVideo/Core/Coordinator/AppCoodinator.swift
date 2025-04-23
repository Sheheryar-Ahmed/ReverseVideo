//
//  AppCoodinator.swift
//  ReverseVideo
//
//  Created by Sheheryar Ahmed on 19/04/2025.
//

import UIKit

final class AppCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    
    var navigationController: UINavigationController

    private let appDIContainer: AppDIContainer


    init(navigationController: UINavigationController, appDIContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }

    func start() {
        showGallery()
    }

    private func showGallery() {
        let galleryDIContainer = appDIContainer.makeGalleryDIContainer()
        let homeCoordinator = galleryDIContainer.makeGalleryCoordinator(navigationController: navigationController)
        childCoordinators.append(homeCoordinator)
        homeCoordinator.start()
    }
}
