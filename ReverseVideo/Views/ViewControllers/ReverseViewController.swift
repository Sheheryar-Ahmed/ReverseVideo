//
//  ReverseViewController.swift
//  ReverseVideo
//
//  Created by Sheheryar Ahmed on 26/05/2021.
//

import UIKit

protocol ReverseViewControllerDelegate {
    func reverseTickButtonTapped(viewController: UIViewController)
    func reverseButtonToggled(isReversed: Bool)
}

class ReverseViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var reverseButton: UIButton!
    
    // MARK: - Properties
    var delegate: ReverseViewControllerDelegate?
    var isReversed: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        configureButton()
    }
    
    // MARK: - IBActions
    @IBAction func tickButtonPressed() {
        delegate?.reverseTickButtonTapped(viewController: self)
    }
    
    @IBAction func reverseButtonPressed() {
        isReversed.toggle()
        reverseButton.setTitle(isReversed ? "Undo Reverse" : "Reverse Video" , for: .normal)
        delegate?.reverseButtonToggled(isReversed: isReversed)
    }
    
    // MARK: - Private Methods
    func configureButton() {
        reverseButton.layer.cornerRadius = 15
    }
}
