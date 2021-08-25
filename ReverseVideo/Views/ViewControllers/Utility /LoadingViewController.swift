//
//  LoadingViewController.swift
//  ReverseVideo
//
//  Created by Sheheryar Ahmed on 19/08/2021.
//

import UIKit

class LoadingViewController: UIViewController {
    
    // MARK: - Initializers
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Properties
    var text: String?
    let activityIndicator = ActivityIndicatorManager()
    let textLabel = UILabel()
    
    // MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.rvBlack?.withAlphaComponent(0.94)
        activityIndicator.startAnimating(in: self.view, style: .ballRotateChase)
        
        view.addSubview(textLabel)
        textLabel.text = text ?? "Processing..."
        textLabel.textColor = .white
        
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            textLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 70)
        ])
    }
}

