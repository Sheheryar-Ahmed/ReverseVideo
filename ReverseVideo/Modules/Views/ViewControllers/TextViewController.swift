//
//  TextViewController.swift
//  ReverseVideo
//
//  Created by Sheheryar Ahmed on 29/05/2021.
//

import UIKit

protocol TextViewControllerDelegate {
    func textTickButtonTapped(viewController: UIViewController)
}

class TextViewController: UIViewController {
    
    // MARK: - Properties
    var delegate: TextViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - IBActions
    @IBAction func tickButtonPressed() {
        delegate?.textTickButtonTapped(viewController: self)
    }
}
