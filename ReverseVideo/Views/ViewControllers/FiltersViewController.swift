//
//  FiltersViewController.swift
//  ReverseVideo
//
//  Created by Sheheryar Ahmed on 29/05/2021.
//

import UIKit

protocol FiltersViewControllerDelegate {
    func filtersTickButtonTapped(viewController: UIViewController)
}

class FiltersViewController: UIViewController {
    
    // MARK: - Properties
    var delegate: FiltersViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    // MARK: - IBActions
    @IBAction func tickButtonPressed() {
        delegate?.filtersTickButtonTapped(viewController: self)
    }
}
