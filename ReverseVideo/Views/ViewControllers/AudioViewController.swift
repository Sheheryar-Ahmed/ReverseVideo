//
//  AudioViewController.swift
//  ReverseVideo
//
//  Created by Sheheryar Ahmed on 29/05/2021.
//

import UIKit

protocol AudioViewControllerDelegate {
    func audioTickButtonTapped(viewController: UIViewController)
}

class AudioViewController: UIViewController {
    
    // MARK: - Properties
    var delegate: AudioViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - IBActions
    @IBAction func tickButtonPressed() {
        delegate?.audioTickButtonTapped(viewController: self)
    }
}
