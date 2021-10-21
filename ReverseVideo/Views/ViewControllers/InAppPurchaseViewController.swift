//
//  InAppPurchaseViewController.swift
//  ReverseVideo
//
//  Created by Sheheryar Ahmed on 08/09/2021.
//

import UIKit
import AVFoundation
import Purchases

class InAppPurchaseViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var crossButton: UIButton!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet var tickIcons: [UIImageView]!
    
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
    
    @IBOutlet weak var monthlyContainerView: UIView!
    @IBOutlet weak var monthlySubContainerView: UIView!
    @IBOutlet weak var monthlyLabel: UILabel!
    @IBOutlet weak var monthlyPriceLabel: UILabel!
    
    @IBOutlet weak var continueButton: UIButton!
    
    // MARK: - Properties
    var viewModel = InAppPurchaseViewModel()
    
    // for repeating video
    var playerLooper: AVPlayerLooper!
    var queuePlayer: AVQueuePlayer!
    var playerLayer: AVPlayerLayer!
    
    var loadingVC: LoadingViewController?
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
        addShadow()
        configureVideoPlayer()
        
        viewModel.fetchProducts { result in
            
            switch result {
            case .success(_):
                self.updatePriceLabels()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - IBActions
    @IBAction func crossButtonTapped(_ sender: UIButton) {
        dismissVC()
    }
    
    @IBAction func weeklyPackageSelected(_ sender: UIButton) {
        viewModel.selectedPackageID = RVConstants.InAppPurchase.weeklyPackageID
        setSelectedBorderColor(for: viewModel.selectedPackageID)
    }
    
    @IBAction func monthlyPackageSelected(_ sender: UIButton) {
        viewModel.selectedPackageID = RVConstants.InAppPurchase.monthlyPackageID
        setSelectedBorderColor(for: viewModel.selectedPackageID)
    }
    
    @IBAction func yearlyPackageSelected(_ sender: UIButton) {
        viewModel.selectedPackageID = RVConstants.InAppPurchase.yearlyPackageID
        setSelectedBorderColor(for: viewModel.selectedPackageID)
    }
    
    @IBAction func continueButtonTapped(_ sender: UIButton) {
        
        if let package = viewModel.offering?.availablePackages.first(where: { $0.identifier == viewModel.selectedPackageID }) {
            
            showLoadingVC()
            Purchases.shared.purchasePackage(package) { transcation, purchaserInfo, error, userCancelled in
                
                self.hideLoadingVC()
                if purchaserInfo?.entitlements.all["pro"]?.isActive == true {
                    // Unlock that great "pro" content
                    GlobalData.isPro = true
                    self.presentRVAlertOnMainThread(message: "Thank you! Your purchase is successful.")
                    self.dismissVC()
                } else if let error = error {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        } else {
            // show no package currently avaiable
        }
    }
    
    @IBAction func privacyPolicyTapped(_ sender: UIButton) {
        guard let url = URL(string: RVConstants.URLs.privacyPolicy) else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction func alreadyPaidTapped(_ sender: UIButton) {
        
        showLoadingVC()
        Purchases.shared.restoreTransactions { purchaserInfo, error in
            self.hideLoadingVC()
            
            if purchaserInfo?.entitlements.all["pro"]?.isActive == true {
                // Unlock that great "pro" content
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        
    }
    
    @IBAction func termsOfUseTapped(_ sender: UIButton) {
        guard let url = URL(string:RVConstants.URLs.termsOfUse) else { return }
        UIApplication.shared.open(url)
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
        
        monthlyContainerView.layer.borderWidth = 2
        monthlyContainerView.layer.cornerRadius = 12
        monthlySubContainerView.layer.cornerRadius = 9
        monthlyContainerView.layer.borderColor = UIColor.rvGray.cgColor
        
        continueButton.layer.cornerRadius = 10
        
        setSelectedBorderColor(for: viewModel.selectedPackageID)
        
        crossButton.tintColor = .rvThemeAlpha
        continueButton.backgroundColor = .rvThemeAlpha
        
        tickIcons.forEach { tickIcon in
            tickIcon.tintColor = .rvThemeAlpha
        }
    }
    
    private func addShadow() {
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.frame = shadowView.bounds
        
        gradientLayer.colors = [UIColor.rvBlack.cgColor, UIColor.clear.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 1)
        gradientLayer.endPoint = CGPoint(x: 0, y: 0)
        
        shadowView.layer.addSublayer(gradientLayer)
    }
    
    private func configureVideoPlayer() {
        let url = viewModel.videoPath
        let asset: AVAsset = AVAsset(url: url)
        let playerItem = AVPlayerItem(asset: asset)
        self.queuePlayer = AVQueuePlayer(playerItem: playerItem)
        
        playerLayer = AVPlayerLayer(player: queuePlayer)
        guard let playerLayer = playerLayer else { fatalError("Error creating player layer") }
        playerLayer.frame = self.videoView.bounds
        playerLayer.videoGravity = .resizeAspectFill
        self.videoView.layer.insertSublayer(playerLayer, at: 0)
        
        // Create a new player looper with the queue player and template item
        self.playerLooper = AVPlayerLooper(player: queuePlayer, templateItem: playerItem)
        queuePlayer.play()
        queuePlayer.seek(to: .zero)
    }
    
    private func updatePriceLabels() {
        
        guard let packages = viewModel.offering?.availablePackages else {
            return
        }
        
        for package in packages {
            
            if package.identifier == RVConstants.InAppPurchase.weeklyPackageID {
                weeklyPriceLabel.text = package.localizedPriceString
            } else if package.identifier == RVConstants.InAppPurchase.monthlyPackageID {
                monthlyPriceLabel.text = package.localizedPriceString
            } else if package.identifier == RVConstants.InAppPurchase.yearlyPackageID {
                yearlyPricelabel.text = package.localizedPriceString
                yearlyPerMonthPriceLabel.text =  package.product.localizedPrice12thSection + "/month"
            }
        }
    }
    
    private func setSelectedBorderColor(for packageID: String) {
        if packageID == RVConstants.InAppPurchase.weeklyPackageID {
            weeklyContainerView.layer.borderColor = UIColor.rvThemeAlpha.cgColor
            yearlyContainerView.layer.borderColor = UIColor.rvGray.cgColor
            monthlyContainerView.layer.borderColor = UIColor.rvGray.cgColor
            freeTrialYearlyLabel.backgroundColor = .rvGray
            yearlySavelabel.backgroundColor = .rvGray
            
        } else if packageID == RVConstants.InAppPurchase.yearlyPackageID {
            yearlyContainerView.layer.borderColor = UIColor.rvThemeAlpha.cgColor
            weeklyContainerView.layer.borderColor = UIColor.rvGray.cgColor
            monthlyContainerView.layer.borderColor = UIColor.rvGray.cgColor
            freeTrialYearlyLabel.backgroundColor = .rvThemeAlpha
            yearlySavelabel.backgroundColor = .rvThemeAlpha
            
        } else if packageID == RVConstants.InAppPurchase.monthlyPackageID  {
            monthlyContainerView.layer.borderColor = UIColor.rvThemeAlpha.cgColor
            weeklyContainerView.layer.borderColor = UIColor.rvGray.cgColor
            yearlyContainerView.layer.borderColor = UIColor.rvGray.cgColor
            freeTrialYearlyLabel.backgroundColor = .rvGray
            yearlySavelabel.backgroundColor = .rvGray
        }
    }
    
    func showLoadingVC() {
        loadingVC = LoadingViewController()
        loadingVC?.modalPresentationStyle = .overFullScreen
        if let loadingVC = loadingVC {
            self.present(loadingVC, animated: false, completion: nil)
        }
    }
    
    func hideLoadingVC() {
        DispatchQueue.main.async {
            self.loadingVC?.dismiss(animated: true, completion: nil)
        }
    }
    
    func dismissVC() {
        queuePlayer.removeAllItems()
        playerLooper?.disableLooping()
        self.dismiss(animated: true, completion: nil)
    }
}
