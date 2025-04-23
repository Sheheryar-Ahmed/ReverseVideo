//
//  Coordinator.swift
//  ReverseVideo
//
//  Created by Sheheryar Ahmed on 19/04/2025.
//

import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    func start()
}
