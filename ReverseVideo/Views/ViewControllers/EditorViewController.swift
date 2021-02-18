//
//  EditorViewController.swift
//  ReverseVideo
//
//  Created by Sheheryar Ahmed on 12/02/2021.
//

import UIKit
import AVFoundation
import AVKit

class EditorViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var videoSlider: UISlider!
    @IBOutlet weak var speedCollectionView: UICollectionView!
    
    // MARK: - Properties
    var videoUrl: URL!
    var avplayer = AVPlayer()
    var playerController = AVPlayerViewController()
    var speedArray: [Float] = [0.25, 0.50, 0.75, 1.0 , 1.25, 1.50, 1.75, 2.0]
    var currentSpeed: Float = 1.0
    var isPlaying: Bool = false
    var selectedIndex = 0
    let generator = UIImpactFeedbackGenerator(style: .light)
    
    // MARK: Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        addVideoPlayer(videoUrl: videoUrl, to: videoView)
        addTimeObserver(to: avplayer, bySlider: videoSlider)
        videoSlider.addTarget(self, action: #selector(handleSliderChange), for: .valueChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        speedCollectionView.selectItem(at: IndexPath(row: 3, section: 0), animated: false, scrollPosition: .centeredHorizontally)
    }
    
    // MARK - IBActions
    @IBAction func playButtonPressed() {
        if avplayer.status == .readyToPlay {
        isPlaying ? avplayer.pause() : avplayer.playImmediately(atRate: -currentSpeed)
        isPlaying.toggle()
        }
    }
    
    @IBAction func stopButtonPressed() {
        let duratTime: CMTime = (avplayer.currentItem?.asset.duration)!
        
        if CMTIME_IS_VALID(duratTime) {
            avplayer.pause()
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
    func setupCollectionView() {
        speedCollectionView.delegate = self
        speedCollectionView.dataSource = self
        speedCollectionView.register(UINib(nibName: speedCollectionViewCell.name, bundle: nil), forCellWithReuseIdentifier: speedCollectionViewCell.identifier)
        
        speedCollectionView.allowsMultipleSelection = false
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
        VideoGenerator.current.reverseVideo(fromVideo: videoUrl!) { (result) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let url):
                self.addVideoPlayer(videoUrl: url, to: self.videoView)
            }
        }
    }
    
    func selectedElement(at indexPath: IndexPath) {
        currentSpeed = speedArray[indexPath.row]
        speedCollectionView.reloadData()
        generator.impactOccurred()
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
        avplayer.rate = -currentSpeed
        isPlaying ? avplayer.playImmediately(atRate: -currentSpeed) : avplayer.pause()
    }
    
    // FlowLayout methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let center = collectionView.frame.width / 2
        return UIEdgeInsets(top: 0, left: center, bottom: 0, right: center)
    }
}


extension EditorViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let visiblePoint = CGPoint(x: speedCollectionView.center.x , y: speedCollectionView.center.y )
        
        guard let newIndexPath = speedCollectionView.indexPathForItem(at: visiblePoint) else { return }

        speedCollectionView.selectItem(at: newIndexPath, animated: true, scrollPosition: .centeredVertically)
        
        print(newIndexPath)
//        if selectedIndex != newIndexPath.row {
//            selectedElement(at: newIndexPath)
//            selectedIndex = newIndexPath.row
//
//            for i in 0...speedArray.count {
//
//                if i != newIndexPath.row {
//                    let indexPath = IndexPath(row: i, section: 0)
//                    speedCollectionView.deselectItem(at: indexPath, animated: false)
//                }
//            }
//        }
    }
}
