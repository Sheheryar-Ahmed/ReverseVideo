//
//  GalleryViewController.swift
//  ReverseVideo
//
//  Created by Sheheryar Ahmed on 10/10/2021.
//

import UIKit
import AVFoundation
import AVKit
import MobileCoreServices

class GalleryViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var proButton: UIButton!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var albumsCollectionView: UICollectionView!
    @IBOutlet weak var videosCollectionView: UICollectionView!
    
    // MARK: - Properties
    var isFirstTime: Bool = true
    let viewModel = GalleryViewModel()
    var avPlayer = AVPlayer()
    var playerController = AVPlayerViewController()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        viewModel.delegate = self
        viewModel.fetchAlbums()
        setupUI()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isFirstTime {
            isFirstTime = false
            setupCollectionViews()
            
            albumsCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .centeredVertically)
            videosCollectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .centeredHorizontally)
            
            if let asset = viewModel.currentAlbum?.assets.firstObject {
                
                viewModel.requestAsset(asset: asset) { [self] avAsset in
                    
                    if let avAsset = avAsset {
                        viewModel.currentAsset = avAsset
                        addVideoPlayer(asset: avAsset, to: videoView)
                    }
                }
            }
        }
    }
    
    // MARK: - IBActions
    @IBAction func settingsButtonPresses(_ sender: UIButton) {
        
    }
    
    @IBAction func premiumButtonTapped(_ sender: UIButton) {
        self.presentInAppViewController()
    }
    
    @IBAction func cameraButtonTapped(_ sender: UIButton) {
        presentImagePicker(editingEnabled: false, sourceType: .camera)
    }
    
    @IBAction func selectButtonTapped(_ sender: UIButton) {
        if let asset = viewModel.currentAsset {
            presentEditorVC(with: asset.url)
        }
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        self.view.backgroundColor = .rvGray
        topView.backgroundColor = .black.withAlphaComponent(0.1)
        proButton.backgroundColor = .rvThemeAlpha
        videoView.layer.cornerRadius = 10
        videoView.clipsToBounds = true
    }
    
    private func setupCollectionViews() {
        // Albums collectionView
        albumsCollectionView.layer.cornerRadius = 5
        albumsCollectionView.backgroundColor = .black.withAlphaComponent(0.1)
        
        albumsCollectionView.delegate = self
        albumsCollectionView.dataSource = self
        
        albumsCollectionView.register(UINib(nibName: AlbumCollectionViewCell.name, bundle: nil), forCellWithReuseIdentifier: AlbumCollectionViewCell.identifier)
        
        // videos CollectionView
        videosCollectionView.backgroundColor = .clear
        videosCollectionView.delegate = self
        videosCollectionView.dataSource = self
        
        let flowLayout = UICollectionViewFlowLayout()
        
        let numberofItem: CGFloat = 3
        let collectionViewWidth = self.videosCollectionView.bounds.width
        let extraSpace = (numberofItem - 1) * flowLayout.minimumInteritemSpacing
        let inset = flowLayout.sectionInset.right + flowLayout.sectionInset.left
        let width = Int((collectionViewWidth - extraSpace - inset) / numberofItem)
        
        flowLayout.itemSize = CGSize(width: width, height: Int(videosCollectionView.frame.height/2.5))
        videosCollectionView.collectionViewLayout = flowLayout
        videosCollectionView.register(UINib(nibName: VideosCollectionViewCell.name, bundle: nil), forCellWithReuseIdentifier: VideosCollectionViewCell.identifier)
    }
    
    private func addVideoPlayer(asset: AVURLAsset, to view: UIView) {
        DispatchQueue.main.async { [self] in
            
            avPlayer = AVPlayer(playerItem: AVPlayerItem(asset: asset))
            
            playerController.player = self.avPlayer
            self.addChild(playerController)
            view.addSubview(playerController.view)
            playerController.view.frame = view.bounds
            playerController.showsPlaybackControls = true
            avPlayer.isMuted = false
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            }
            catch {
                print(error)
            }
            self.avPlayer.play()
        }
    }
    
    private func presentImagePicker(editingEnabled: Bool, sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.mediaTypes = [kUTTypeMovie as String]
        imagePicker.allowsEditing = true
        imagePicker.sourceType = sourceType
        imagePicker.videoQuality = .typeHigh
        imagePicker.view.backgroundColor = .black
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    private func presentEditorVC(with videoURL: URL) {
        guard let editorVC = storyboard?.instantiateViewController(withIdentifier: EditorViewController.identifier) as? EditorViewController else {
            return
        }
        
        editorVC.viewModel.originalVideoUrl = videoURL
        editorVC.viewModel.videoUrl = videoURL
        editorVC.modalPresentationStyle = .overFullScreen
        present(editorVC, animated: true)
    }
}

// MARK: - Extentions
extension GalleryViewController: GalleryViewModelDelegate {
    func didFetchAlbums() {
        
        if viewModel.albums.count > 0 {
            viewModel.currentAlbum = viewModel.albums.first
        }
    }
    
    func handleLimitedAccess() {
        
    }
    
    func didFailToFetchAlbums() {
        
    }
    
    func noAlbumsFound() {
        
    }
    
    
}

extension GalleryViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // DataSource Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == albumsCollectionView {
            return viewModel.albums.count
        } else {
            return viewModel.currentAlbum?.assets.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == albumsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumCollectionViewCell.identifier, for: indexPath) as! AlbumCollectionViewCell
            cell.label.text = viewModel.albums[indexPath.row].name
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideosCollectionViewCell.identifier, for: indexPath) as! VideosCollectionViewCell
            
            if let asset =
                viewModel.currentAlbum?.assets[indexPath.row] {
                UIImage.fetchFromPhotos(asset:  asset, contentMode: .aspectFill, targetSize: CGSize(width: 200, height: 200), completion: { image in
                    cell.imageView?.image = image
                })
                
            }
            
            return cell
        }
    }
    
    // Delegate Methods
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == albumsCollectionView {
            viewModel.currentAlbum = viewModel.albums[indexPath.row]
            videosCollectionView.reloadData()
        } else {
            
            if let asset = viewModel.currentAlbum?.assets[indexPath.row] {
                viewModel.requestAsset(asset: asset) { [self] avAsset in
                    
                    if let avAsset = avAsset {
                        viewModel.currentAsset = avAsset
                        addVideoPlayer(asset: avAsset, to: videoView)
                    }
                }
            }
        }
    }
}

extension GalleryViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let  url = info[.mediaURL] as? URL else {
            return
        }
        
        picker.dismiss(animated: true) {
            self.presentEditorVC(with: url)
        }
    }
}

extension GalleryViewController: UINavigationControllerDelegate {
}

