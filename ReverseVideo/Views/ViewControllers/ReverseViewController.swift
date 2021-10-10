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
    var isReversed: Bool = false {
        didSet {
            reverseButton.setTitle(isReversed ? "Undo Reverse" : "Reverse Video" , for: .normal)
        }
    }
    
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
        delegate?.reverseButtonToggled(isReversed: isReversed)
    }
    
    // MARK: - Private Methods
    private func configureButton() {
        reverseButton.layer.cornerRadius = 15
        reverseButton.setTitle(isReversed ? "Undo Reverse" : "Reverse Video" , for: .normal)
    }
}
