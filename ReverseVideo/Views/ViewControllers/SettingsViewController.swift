//
//  SettingsViewController.swift
//  ReverseVideo
//
//  Created by Sheheryar Ahmed on 14/10/2021.
//


import UIKit
import Purchases

class SettingsViewController: UIViewController {
    
    // MARK: - Properties
    let viewModel = SettingsViewModel()
//    let inappManager = IAPManager()
    var loadingVC: LoadingViewController?
    
    // MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var settingsTableView: UITableView!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Registration
        settingsTableView.register(UINib(nibName: SettingsTableViewCell.name, bundle: nil), forCellReuseIdentifier: SettingsTableViewCell.identifier)
        
        settingsTableView.backgroundView?.backgroundColor = .rvBlack
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Add header view if not pro
        if !GlobalData.isPro {
            let tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: settingsTableView.frame.width, height: 240))
            settingsTableView.tableHeaderView = tableHeaderView
            
            let settingTableHeaderView: SettingTableViewHeader = .fromNib()
            settingTableHeaderView.frame = CGRect(x: 0, y: 0, width: settingsTableView.frame.width, height: 240)
            settingTableHeaderView.delegate = self
            tableHeaderView.addSubview(settingTableHeaderView)
        } else {
            settingsTableView.tableHeaderView = UIView()
        }
        
        // Add footer view
        let tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: settingsTableView.frame.width, height: 50))
        settingsTableView.tableFooterView = tableFooterView
        
        let settingTableFooterView: SettingsTableViewFooter = .fromNib()
        settingTableFooterView.frame = CGRect(x: 0, y: 0, width: settingsTableView.frame.width, height: 50)
        settingTableFooterView.delegate = self
        tableFooterView.addSubview(settingTableFooterView)
        
        // tap gesture to tabel headerView
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showPremiumVC))
        settingsTableView.tableHeaderView?.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - IBActions
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Handlers
    @objc func showPremiumVC () {
        self.presentInAppViewController()
        }
    
    func setupUI() {
        titleLabel.text = "Settings"
        doneButton.setTitle("Done", for: .normal)
        doneButton.setTitleColor(.rvThemeAlpha, for: .normal)
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
}

extension SettingsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (viewModel.dataSource[section]["items"] as? [[String:Any]])?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.identifier) as? SettingsTableViewCell else {
            return UITableViewCell()
        }
        
        let dict = (viewModel.dataSource[indexPath.section]["items"] as? [[String:Any]])?[indexPath.row]
        cell.configure(image: dict?["image"] as? String, title: dict?["title"] as? String, cellNo: dict?["cellNo"] as? CellNumber)
        return cell
    }
}

extension SettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let linkStr = (viewModel.dataSource[indexPath.section]["items"] as? [[String:Any]])?[indexPath.row]["link"] as? String, let url = URL(string: linkStr ) {
            UIApplication.shared.open(url)
        } else {
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
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: SettingTableViewSectionHeader = .fromNib()
        headerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 60)
        headerView.titleLabel.text = (viewModel.dataSource[section]["section"] as? String)?.uppercased()
//        headerView.titleLabel.textColor = .rvGray
        headerView.backgroundColor = .rvBlack
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
}

extension SettingsViewController: SettingTableViewHeaderDelegate {
    
    func continueButtonTapped(_ sender: UIButton) {
        showPremiumVC()
    }
}

extension SettingsViewController: SettingsTableViewFooterDelegate {
    func didTapOnTermsAndServices() {
        if let url = URL(string: viewModel.termsAndServicesURL) {
            UIApplication.shared.open(url)
        }
    }
}
