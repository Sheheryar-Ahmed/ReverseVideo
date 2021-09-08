//
//  InAppPurchaseViewController.swift
//  ReverseVideo
//
//  Created by Sheheryar Ahmed on 08/09/2021.
//

import UIKit

class InAppPurchaseViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var shadowView: UIView!
    
    @IBOutlet weak var allDealsContainerView: UIView!
    @IBOutlet weak var weeklyContainerView: UIView!
    @IBOutlet weak var weeklySubcontainerView: UIView!
    @IBOutlet weak var weeklyTextLabel: UILabel!
    @IBOutlet weak var weeklyPriceLabel: UILabel!
    
    @IBOutlet weak var yearlyContainerView: UIView!
    @IBOutlet weak var yearlySubContainerView: UIView!
    @IBOutlet weak var freeTrialYearlyLabel: UILabel!
    @IBOutlet weak var yearlyTextlabel: UILabel!
    @IBOutlet weak var twelveMonthsLabel: UILabel!
    @IBOutlet weak var yearlyPricelabel: UILabel!
    @IBOutlet weak var yearlyPerMonthPriceLabel: UILabel!
    @IBOutlet weak var yearlySavelabel: UILabel!
    
    @IBOutlet weak var lifeTimeContainerView: UIView!
    @IBOutlet weak var lifeTimeSubContainerView: UIView!
    @IBOutlet weak var lifeTimeLabel: UILabel!
    @IBOutlet weak var lifetimePriceLabel: UILabel!
    
    @IBOutlet weak var continueButton: UIButton!
    
    // MARK: - Properties
    
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
        
    }

    // MARK: - Private Methods
    private func setupUI() {
        weeklyContainerView.layer.borderWidth = 2
        weeklyContainerView.layer.cornerRadius = 12
        weeklySubcontainerView.layer.cornerRadius = 9
        weeklyContainerView.layer.borderColor = UIColor.rvGray.cgColor
        
        yearlyContainerView.layer.borderWidth = 2
        yearlyContainerView.layer.cornerRadius = 12
        yearlySubContainerView.layer.cornerRadius = 9
        freeTrialYearlyLabel.layer.cornerRadius = 2
        yearlyContainerView.layer.borderColor = UIColor.rvGray.cgColor
        
        lifeTimeContainerView.layer.borderWidth = 2
        lifeTimeContainerView.layer.cornerRadius = 12
        lifeTimeSubContainerView.layer.cornerRadius = 9
        lifeTimeContainerView.layer.borderColor = UIColor.rvGray.cgColor
        
//        continueButton.addGradientBackground(with: [UIColor.fromHex("4187C7").cgColor, UIColor.fromHex("2565AF").cgColor], startPoint: CGPoint(x: 0.5, y: 0), endPoint: CGPoint(x: 0.5, y: 1))
        
        continueButton.layer.cornerRadius = 10
        
//        setSelectedBorderColor(for: selectedProductID)
    }
}
