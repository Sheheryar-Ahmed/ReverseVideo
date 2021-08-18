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
    @IBOutlet weak var videoSlider: UISlider!
    @IBOutlet weak var speedCollectionView: UICollectionView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var playButton: UIButton!
    
    // MARK: - Properties
    var videoUrl: URL!
    var avplayer = AVPlayer()
    var playerController = AVPlayerViewController()
    var speedArray: [Float] = [0.25, 0.50, 0.75, 1.0, 1.5, 2.0, 3.0, 4.0]
    var currentSpeed: Float = 1.0
    var isPlaying: Bool = false
    var selectedIndex = 0
    let generator = UIImpactFeedbackGenerator(style: .light)
    var activityIndicator = ActivityIndicatorManager()
    var interstitial: GADInterstitialAd!
    var currentPlayTapCount = 0
    var isExportInterstitial = false
    
    // MARK: Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupCollectionView()
        createAndLoadInterstitial()
        setupBannerAd()
        addVideoPlayer(videoUrl: videoUrl, to: videoView)
        addTimeObserver(to: avplayer, bySlider: videoSlider)
        videoSlider.addTarget(self, action: #selector(handleSliderChange), for: .valueChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if currentSpeed == 1.0 {
        speedCollectionView.selectItem(at: IndexPath(row: 3, section: 0), animated: false, scrollPosition: .centeredHorizontally)
        }
    }
    
    // MARK - IBActions
    @IBAction func exportButtonTapped() {
        
        if interstitial != nil {
            isExportInterstitial = true
          interstitial.present(fromRootViewController: self)
        } else {
          exportVideo()
        }
    }
    
    @IBAction func backButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func playButtonPressed() {
        currentPlayTapCount += 1
        
        if currentPlayTapCount > 2 {
            if interstitial != nil {
                isExportInterstitial = false
              interstitial.present(fromRootViewController: self)
            }  else {
                if avplayer.status == .readyToPlay {
                    isPlaying ? avplayer.pause() : avplayer.playImmediately(atRate: -currentSpeed)
                    playButton.setImage(isPlaying ? UIImage.playIcon : UIImage.pauseIcon, for: .normal)
                    isPlaying.toggle()
                }
            }
            
            currentPlayTapCount = 0
        } else {
            if avplayer.status == .readyToPlay {
                isPlaying ? avplayer.pause() : avplayer.playImmediately(atRate: -currentSpeed)
                playButton.setImage(isPlaying ? UIImage.playIcon : UIImage.pauseIcon, for: .normal)
                isPlaying.toggle()
            }
        }
    }
    
    @IBAction func stopButtonPressed() {
        let duratTime: CMTime = (avplayer.currentItem?.asset.duration)!
        
        if CMTIME_IS_VALID(duratTime) {
            avplayer.pause()
            playButton.setImage(UIImage.playIcon, for: .normal)
            isPlaying = false
            avplayer.seek(to: duratTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
        }
    }
    
    // MARK: - handler
    @objc func handleSliderChange() {
        
        if  let duration = avplayer.currentItem?.duration {
            let totalSeconds = CMTimeGetSeconds(duration)
            let value  = Float(totalSeconds) - videoSlider.value
            let seekTime = CMTime(value: Int64(value), timescale: 1)
            
            avplayer.seek(to: seekTime,toleranceBefore: CMTime.zero,toleranceAfter: CMTime.zero, completionHandler: { (completedSeek) in
                //perhaps do something later here
            })
        }
    }
    
    // MARK: - Private Methods    
    func createAndLoadInterstitial() {
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID:RVConstants.adIDs.exportInterstitial,
                                       request: request,
                             completionHandler: { [self] ad, error in
                               if let error = error {
                                 print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                                 return
                               }
                               interstitial = ad
                                interstitial?.fullScreenContentDelegate = self
                             }
           )
    }
    
    func setupCollectionView() {
        speedCollectionView.delegate = self
        speedCollectionView.dataSource = self
        speedCollectionView.register(UINib(nibName: speedCollectionViewCell.name, bundle: nil), forCellWithReuseIdentifier: speedCollectionViewCell.identifier)
        
        speedCollectionView.allowsMultipleSelection = false
    }
    
    func setupBannerAd() {
        let viewWidth = view.frame.inset(by: view.safeAreaInsets).size.width
        bannerView.adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth)
        bannerView.adUnitID = RVConstants.adIDs.editorBanner
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
    func addTimeObserver(to avPlayer: AVPlayer, bySlider videoSlider: UISlider) {
        let interval = CMTime(value: 1, timescale: 2)
        avPlayer.addPeriodicTimeObserver(forInterval: interval, queue: .main) { (ProgressTime) in
            let seconds = CMTimeGetSeconds(ProgressTime)

            if let duration = (self.avplayer.currentItem?.asset.duration) {
                
                let durationSeconds = CMTimeGetSeconds(duration)
                videoSlider.maximumValue = Float(durationSeconds)
                videoSlider.minimumValue = 0
                
                DispatchQueue.main.async {
                    videoSlider.value = Float(durationSeconds - seconds)
                }
            }
        }
    }
    
    func addVideoPlayer(videoUrl: URL, to view: UIView) {
        let item = AVPlayerItem(url: videoUrl)
        self.avplayer = AVPlayer(playerItem: item)
        playerController.player = self.avplayer
        self.addChild(playerController)
        view.addSubview(playerController.view)
        playerController.view.frame = view.bounds
        
        playerController.showsPlaybackControls = false
        avplayer.isMuted = false
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
        
        let duratTime: CMTime = (avplayer.currentItem?.asset.duration)!
        if CMTIME_IS_VALID(duratTime) {
            avplayer.seek(to: duratTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
        }
        else {
            print("In valid time")
        }
    }
    
    func exportVideo() {
        activityIndicator.startAnimating(in: self.videoView)
        self.view.isUserInteractionEnabled = false
        videoView.alpha = 0.6
        
        VideoGenerator.current.reverseVideo(fromVideo: videoUrl, withSpeed: currentSpeed) { (result) in
            
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.view.isUserInteractionEnabled = true
                self.videoView.alpha = 1
            }
         
            switch result {
            case .failure(let error):
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }
            case .success(let url) :
                            let saveVideoToPhotos = {
                                PHPhotoLibrary.shared().performChanges({
                                    PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
                                }) { saved, error in
                                    let success = saved && (error == nil)
                                    let title = success ? "Success" : "Error"
                                    let message = success ? "Video saved" : "Failed to save video"
                    
                                    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
                                    DispatchQueue.main.async {
                                        self.present(alert, animated: true, completion: nil)
                                    }
                                }
                            }
                    
                            //  Ensure permission to access Photo Library
                            if PHPhotoLibrary.authorizationStatus() != .authorized {
                                PHPhotoLibrary.requestAuthorization { status in
                                    if status == .authorized {
                                        saveVideoToPhotos()
                                    }
                                }
                            } else {
                                saveVideoToPhotos()
                            }
            }
        }
    }
}

// MARK: - Extentions
extension EditorViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // DataSource Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return speedArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: speedCollectionViewCell.identifier, for: indexPath) as! speedCollectionViewCell
        cell.label.text = "\(speedArray[indexPath.row])"
        return cell
    }
    
    // Delegate Methods
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.6) {
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        }
        
        currentSpeed = speedArray[indexPath.row]
        isPlaying ? avplayer.playImmediately(atRate: -currentSpeed) : avplayer.pause()
    }
    
    // FlowLayout methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let center = collectionView.frame.width / 2
        return UIEdgeInsets(top: 0, left: center, bottom: 0, right: center)
    }
}

extension EditorViewController: GADFullScreenContentDelegate {
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        if isExportInterstitial {
            exportVideo()
        }
        
        createAndLoadInterstitial()
    }
}

extension EditorViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: speedCollectionView.contentOffset, size: speedCollectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        guard let visibleIndexPath = speedCollectionView.indexPathForItem(at: visiblePoint) else { return }
        
        speedCollectionView.selectItem(at: visibleIndexPath, animated: false, scrollPosition: .centeredVertically)
        currentSpeed = speedArray[visibleIndexPath.row]
        isPlaying ? avplayer.playImmediately(atRate: -currentSpeed) : avplayer.pause()
    }
}
