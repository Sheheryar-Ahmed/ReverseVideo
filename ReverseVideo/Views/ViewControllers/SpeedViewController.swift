//
//  SpeedViewController.swift
//  ReverseVideo
//
//  Created by Sheheryar Ahmed on 29/05/2021.
//

import UIKit

protocol SpeedViewControllerDelegate {
    func speedTickButtonTapped(viewController: UIViewController)
    func didSelectSpeed(value: Float)
}

class SpeedViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var speedCollectionView: UICollectionView!
    
    // MARK: - Properties
    var delegate: SpeedViewControllerDelegate?
    var currentSpeed: Float = 1.0
    let speedArray: [Float] = [0.25, 0.50, 0.75, 1.0, 1.5, 2.0, 3.0, 4.0]
    
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupCollectionView()
        
        speedCollectionView.selectItem(at: IndexPath(row: speedArray.firstIndex(of: currentSpeed) ?? 3, section: 0), animated: false, scrollPosition: .centeredHorizontally)
    }
    
    // MARK: - IBActions
    @IBAction func tickButtonPressed() {
        delegate?.speedTickButtonTapped(viewController: self)
    }
    
    // MARK: - Private Methods
    func setupCollectionView() {
        speedCollectionView.delegate = self
        speedCollectionView.dataSource = self
        speedCollectionView.register(UINib(nibName: SpeedCollectionViewCell.name, bundle: nil), forCellWithReuseIdentifier: SpeedCollectionViewCell.identifier)
        
        speedCollectionView.allowsMultipleSelection = false
    }
}

extension SpeedViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // DataSource Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return speedArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SpeedCollectionViewCell.identifier, for: indexPath) as! SpeedCollectionViewCell
        cell.label.text = "\(speedArray[indexPath.row])"
        return cell
    }
    
    // Delegate Methods
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        UIView.animate(withDuration: 0.6) {
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        }
        
        currentSpeed = speedArray[indexPath.row]
        delegate?.didSelectSpeed(value: currentSpeed)        
    }
    
    // FlowLayout Methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let center = collectionView.frame.width / 2
        return UIEdgeInsets(top: 0, left: center, bottom: 0, right: center)
    }
}

extension SpeedViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: speedCollectionView.contentOffset, size: speedCollectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        guard let visibleIndexPath = speedCollectionView.indexPathForItem(at: visiblePoint) else { return }

        speedCollectionView.selectItem(at: visibleIndexPath, animated: false, scrollPosition: .centeredVertically)
        currentSpeed = speedArray[visibleIndexPath.row]
        delegate?.didSelectSpeed(value: currentSpeed)
    }
}
