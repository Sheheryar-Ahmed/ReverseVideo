//
//  RVAlertViewController.swift
//  ReverseVideo
//
//  Created by Sheheryar Ahmed on 12/03/2021.
//

import UIKit

class RVAlertViewController: UIViewController {
    
    // MARK: - Properties
    let containerView = UIView()
    let imageView = UIImageView()
    let messageLabel = UILabel()
    
    var alertTitle:String?
    var message:String?
    
    let padding:CGFloat = 20
    
    // MARK: -  Initializers
    init(message : String) {
        super.init(nibName: nil, bundle: nil)
        self.alertTitle = title
        self.message = message
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
        configureContainerView()
        configureImageView()
        configureMessageLabel()
        dismissSelfAfter(delay: .now() + 1)
    }
    
    // MARK: - Private Methods
    func dismissSelfAfter(delay: DispatchTime) {
        DispatchQueue.main.asyncAfter(deadline: delay) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    private func configureContainerView() {
        view.addSubview(containerView)
        containerView.backgroundColor = UIColor.rvGray
        containerView.layer.cornerRadius = 10
        containerView.layer.borderWidth = 2
        containerView.layer.borderColor = UIColor.white.cgColor
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 150),
            containerView.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    private func configureImageView() {
        containerView.addSubview(imageView)
        imageView.image = UIImage.doneIcon
        imageView.tintColor = .rvThemeAlpha
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding),
            imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 50),
            imageView.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func configureMessageLabel() {
        containerView.addSubview(messageLabel)
        messageLabel.text = message ?? "Image Saved!"
        messageLabel.numberOfLines = 4
//        messageLabel.font = UIFont.lato?.withSize(17)
        messageLabel.textAlignment = .center
        messageLabel.textColor = UIColor.rvThemeAlpha
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            messageLabel.trailingAnchor
                .constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            messageLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12)
        ])
    }
    
    @objc func dismissVC() {
        dismiss(animated: true, completion: nil)
    }
    
}

