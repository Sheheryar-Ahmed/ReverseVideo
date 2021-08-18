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
    
    // MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    var delegate: FiltersViewControllerDelegate?
    var viewModel = FilterViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupCollectionView()
    }
    
    
    // MARK: - IBActions
    @IBAction func tickButtonPressed() {
        delegate?.filtersTickButtonTapped(viewController: self)
    }
    
    // MARK: - Private Methods
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: ImageWithTextCollectionViewCell.name, bundle: nil), forCellWithReuseIdentifier: ImageWithTextCollectionViewCell.identifier)
    }
}

extension FiltersViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    // Data Source Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("bravo1" , viewModel.filterTypes.count)
        return viewModel.filterTypes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageWithTextCollectionViewCell.identifier, for: indexPath) as! ImageWithTextCollectionViewCell
        
        let filterName = viewModel.filterTypes[indexPath.row].name
        cell.imageView.image = UIImage(named: "filters/" +  filterName)?.resizeImage(newHeight: 200) ?? UIImage.filterIcon
        cell.label.text = filterName
        cell.backgroundColor = .white
        return cell
    }
    
    // FlowLayout methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 70)
    }
}
