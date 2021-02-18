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
    
    // MARK: - Properties
    var videoUrl: URL!
    var avplayer = AVPlayer()
    var playerController = AVPlayerViewController()
    
    // MARK: Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addVideoPlayer(videoUrl: videoUrl, to: videoView)
    }
    
    // MARK - IBActions
    
    
    
    // MARK: - Private Methods
    func addVideoPlayer(videoUrl: URL, to view: UIView) {
        let item = AVPlayerItem(url: videoUrl)
        for track in item.tracks {
            if track.assetTrack?.mediaType == AVMediaType.audio {
                track.isEnabled = false
            }
        }
        
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
            avplayer.rate = -1
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
}
