//
//  EditorViewController.swift
//  ReverseVideo
//
//  Created by Sheheryar Ahmed on 12/02/2021.
//

import UIKit
import AVFoundation
import AVKit
import Photos
import GoogleMobileAds

class EditorViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var videoTimelineView: VideoTimelineView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var videoControllerViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var featuresCollectionView: UICollectionView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var premiumIconButton: UIButton!
    
    // MARK: - Properties
    var avplayer = AVPlayer()
    var playerController = AVPlayerViewController()
    var isPlaying: Bool = false
    var selectedIndex = 0
    let generator = UIImpactFeedbackGenerator(style: .light)
    var activityIndicator = ActivityIndicatorManager()
    var interstitial: GADInterstitialAd!
    var currentPlayTapCount = 0
    var isExportInterstitial = false
    var viewModel = EditorViewModel()
    var loadingVC: LoadingViewController?
    
    // MARK: Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionViews()
        setupBannerAd()
        setupVideoPlayer(videoUrl: viewModel.originalVideoUrl, to: videoView)
        premiumIconButton.isHidden = GlobalData.isPro
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setContainerViewHidden(with: nil, isHidden: true, withAnimation: false)
    }
    
    // MARK - IBActions
    @IBAction func premiumIconTapped(_ sender: UIButton) {
        self.presentInAppViewController()
    }
    
    @IBAction func exportButtonTapped() {
        showLoadingVC()
        
        viewModel.applyFeatures { [self] result in
            hideLoadingVC()
            
            switch result {
            case .success(let url):
                presentRVAlertOnMainThread(message: "Video saved sucessfully")
            case .failure(let error):
                presentRVAlertOnMainThread(message: error.localizedDescription)
            }
        }
//        if interstitial != nil {
//            isExportInterstitial = true
//            interstitial.present(fromRootViewController: self)
//        } else {
//            viewModel.exportVideo(withSpeed: -viewModel.currentSpeed, videoUrl: viewModel.videoUrl) { [self] (result) in
//                switch result {
//                case .failure(let error):
//                    showAlert(title: "Error", message: error.localizedDescription)
//                case .success(let message):
//                    showAlert(title: "Success", message: message)
//                }
//            }
//        }
    }
    
    @IBAction func backButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func playButtonPressed() {
        currentPlayTapCount += 1
        
        if currentPlayTapCount > 2, interstitial != nil {
            
            isExportInterstitial = false
            interstitial.present(fromRootViewController: self)
            currentPlayTapCount = 0
        } else {
            if avplayer.status == .readyToPlay {
                isPlaying ? videoTimelineView.stop() : videoTimelineView.play(atSpeed: viewModel.currentSpeed)
                
                if let filterKey = viewModel.currentFilter?.key, let currentItem = avplayer.currentItem {
                    avplayer.currentItem?.videoComposition = viewModel.applyFilterToComposition(filterKey: filterKey, asset: currentItem.asset)
                }
                
                playButton.setImage(isPlaying ? UIImage.playIcon : UIImage.pauseIcon, for: .normal)
                isPlaying.toggle()
            }
        }
    }
    
    // MARK: - handler
    
    // MARK: - Private Methods
    private func setContainerViewHidden(with viewController: UIViewController?, isHidden: Bool, withAnimation: Bool) {
        var bottomConstraint: CGFloat = 0
        
        if isHidden {
            bottomConstraint = -(180  + bannerView.frame.height +  self.view.safeAreaInsets.bottom)
            videoControllerViewBottomConstraint.constant  = 0
        } else {
            bottomConstraint = 0
            videoControllerViewBottomConstraint.constant = 180 - bannerView.frame.height - featuresCollectionView.frame.height + 20
            
            if let vc = viewController {
                addViewControllerToView(containerView, viewController: vc)
            }
        }
        
        containerViewBottomConstraint.constant = bottomConstraint
        
        if withAnimation {
            
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
                self.view.layoutIfNeeded()
                
            } completion: { (_) in
                self.view.layoutIfNeeded()
                if isHidden , let vc = viewController {
                    self.removeViewControllerFromView(viewController: vc)
                }
            }
        } else {
            self.view.layoutIfNeeded()
        }
    }
    
    private func addViewControllerToView(_ view: UIView, viewController: UIViewController) {
        addChild(viewController)
        view.addSubview(viewController.view)
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParent: self)
    }
    
    private func removeViewControllerFromView(viewController: UIViewController) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
    
    func setupCollectionViews() { 
        featuresCollectionView.delegate = self
        featuresCollectionView.dataSource = self
        featuresCollectionView.register(UINib(nibName: FeaturesCollectionViewCell.name, bundle: nil), forCellWithReuseIdentifier: FeaturesCollectionViewCell.identifier)
    }
    
    func setupBannerAd() {
        let viewWidth = view.frame.inset(by: view.safeAreaInsets).size.width
        bannerView.adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth)
        bannerView.adUnitID = RVConstants.adIDs.editorBanner
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
    func setupVideoPlayer(videoUrl: URL, to view: UIView) {
        let item = AVPlayerItem(url: videoUrl)
        self.avplayer = AVPlayer(playerItem: item)
        playerController.player = self.avplayer
        self.addChild(playerController)
        view.addSubview(playerController.view)
        playerController.view.frame = view.bounds
        
        playerController.showsPlaybackControls = false
        avplayer.isMuted = true
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
        
        videoTimelineView.new(asset:AVAsset(url: videoUrl))
        videoTimelineView.setTrimmerIsHidden(true)
        videoTimelineView.setTrimIsEnabled(false)
        videoTimelineView.playStatusReceiver = self
        videoTimelineView.player = avplayer
        videoTimelineView.repeatOn = false
        
        if isPlaying {
            videoTimelineView.play(atSpeed: viewModel.currentSpeed)
        }
        
        
        if let filter = viewModel.currentFilter, let currentItem = avplayer.currentItem {
            avplayer.currentItem?.videoComposition = viewModel.applyFilterToComposition(filterKey: filter.key, asset: currentItem.asset)
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
    
    func showLoading() {
        activityIndicator.startAnimating(in: self.videoView)
        self.view.isUserInteractionEnabled = false
        videoView.alpha = 0.6
    }
    
    func hideLoading() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.view.isUserInteractionEnabled = true
            self.videoView.alpha = 1
        }
    }
}

// MARK: - Extentions
extension EditorViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // DataSource Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.features.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturesCollectionViewCell.identifier, for: indexPath) as! FeaturesCollectionViewCell
        
        cell.label.text = viewModel.features[indexPath.row].type.name
        cell.imageView.image = viewModel.featureImages[indexPath.row]
        if indexPath.row == 0 {
            cell.imageView.tintColor = .red
        }
        
        return cell
    }
    
    // Delegate Methods
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            let reverseVC = storyboard?.instantiateViewController(identifier: ReverseViewController.identifier) as! ReverseViewController
            let reverseFeature = viewModel.features.first(where: {$0.type == .reverse})
            reverseVC.isReversed =  reverseFeature?.isApplied ?? false
            reverseVC.delegate = self
            setContainerViewHidden(with: reverseVC, isHidden: false, withAnimation: true)
        case 1:
            let speedVC = storyboard?.instantiateViewController(identifier: SpeedViewController.identifier) as! SpeedViewController
            speedVC.currentSpeed = viewModel.currentSpeed
            speedVC.delegate = self
            setContainerViewHidden(with: speedVC, isHidden: false, withAnimation: true)
//        case 2:
//            let featureVC = storyboard?.instantiateViewController(identifier: AudioViewController.identifier) as! AudioViewController
//            featureVC.delegate = self
//            setContainerViewHidden(with: featureVC, isHidden: false, withAnimation: true)
        case 2:
            let filtersVC = storyboard?.instantiateViewController(identifier: FiltersViewController.identifier) as! FiltersViewController
            filtersVC.currentFilter = viewModel.currentFilter
            filtersVC.delegate = self
            setContainerViewHidden(with: filtersVC, isHidden: false, withAnimation: true)
//        case 4:
//            let featureVC = storyboard?.instantiateViewController(identifier: TextViewController.identifier) as! TextViewController
//            featureVC.delegate = self
//            setContainerViewHidden(with: featureVC, isHidden: false, withAnimation: true)
        default:
            break
        }
    }
    
    // FlowLayout methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let cellWidth = 60
        let cellCount = viewModel.features.count
        let cellSpacing = 30
        let totalCellWidth = cellWidth * cellCount
        let totalSpacingWidth = cellSpacing * (cellCount - 1)
        
        let leftInset = (collectionView.frame.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
          let rightInset = leftInset
        
          return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
    }
}

extension EditorViewController: ReverseViewControllerDelegate  {
    
    func reverseTickButtonTapped(viewController: UIViewController) {
        setContainerViewHidden(with: viewController, isHidden: true, withAnimation: true)
    }
    
    func reverseButtonToggled(isReversed: Bool) {
        let reverseFeature = viewModel.features.first(where: {$0.type == .reverse})
        reverseFeature?.isApplied = isReversed
        
        if isReversed {
            showLoadingVC()
            viewModel.reverseVideo(from: viewModel.originalVideoUrl) { [self] result in
                
                switch result {
                case .success(let url):
                    viewModel.videoUrl = url
                    setupVideoPlayer(videoUrl: viewModel.videoUrl, to: videoView)
                    presentRVAlertOnMainThread(message: "Successful")
                case .failure(let error):
                    presentRVAlertOnMainThread(message: "Failed")
                }
                
                hideLoadingVC()
            }
        } else {
            viewModel.videoUrl = viewModel.originalVideoUrl
            setupVideoPlayer(videoUrl: viewModel.videoUrl, to: videoView)
            presentRVAlertOnMainThread(message: "Successful")
        }
    }
}

extension EditorViewController: SpeedViewControllerDelegate  {
    func speedTickButtonTapped(viewController: UIViewController) {
        setContainerViewHidden(with: viewController, isHidden: true, withAnimation: true)
    }
    
    func didSelectSpeed(value: Float) {
        let speedFeature = viewModel.features.first(where: {$0.type == .speed})
        speedFeature?.isApplied = (value == 1) ? false : true
        
        viewModel.currentSpeed = value
        isPlaying ? avplayer.playImmediately(atRate: viewModel.currentSpeed) : avplayer.pause()
    }
}

extension EditorViewController: AudioViewControllerDelegate  {
    func audioTickButtonTapped(viewController: UIViewController) {
        setContainerViewHidden(with: viewController, isHidden: true, withAnimation: true)
    }
}

extension EditorViewController: FiltersViewControllerDelegate  {
    func filtersTickButtonTapped(viewController: UIViewController) {
        setContainerViewHidden(with: viewController, isHidden: true, withAnimation: true)
    }
    
    func didSelectFilter(filter: FilterType) {
        let filtersFeature = viewModel.features.first(where: {$0.type == .filters})
        filtersFeature?.isApplied = true
        
        viewModel.currentFilter = filter
        
        if let currentItem = avplayer.currentItem {
            avplayer.currentItem?.videoComposition = viewModel.applyFilterToComposition(filterKey: filter.key, asset: currentItem.asset)
        }
    }
}

extension EditorViewController: TextViewControllerDelegate  {
    func textTickButtonTapped(viewController: UIViewController) {
        setContainerViewHidden(with: viewController, isHidden: true, withAnimation: true)
    }
}

extension EditorViewController: TimelinePlayStatusReceiver {
    func videoTimelineStopped() {
//        avplayer.pause()
//        isPlaying = false
//        playButton.setImage(UIImage.playIcon, for: .normal)
    }
    
    func videoTimelineMoved() {
//        let currentTime = CMTime(seconds: videoTimelineView.currentTime, preferredTimescale: avplayer.currentItem?.currentTime().timescale ?? .zero)
//        avplayer.seek(to: currentTime)
    }
    
    func videoTimelineTrimChanged() {
    }
    
}
