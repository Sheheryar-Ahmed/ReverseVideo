//
//  FiltersViewController.swift
//  ReverseVideo
//
//  Created by Sheheryar Ahmed on 29/05/2021.
//

import UIKit

protocol FiltersViewControllerDelegate {
    func filtersTickButtonTapped(viewController: UIViewController)
    func didSelectFilter(filter: FilterType)
}

class FiltersViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    var delegate: FiltersViewControllerDelegate?
    var viewModel = FilterViewModel()
    var currentFilter: FilterType?
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupCollectionView()
        
        if let currentFilter = currentFilter, let index = viewModel.filterTypes.firstIndex(of: currentFilter) {
            collectionView.selectItem(at: IndexPath(row: index, section: 0), animated: false, scrollPosition: .centeredHorizontally)
        }
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
        return viewModel.filterTypes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageWithTextCollectionViewCell.identifier, for: indexPath) as! ImageWithTextCollectionViewCell
        
        let filterName = viewModel.filterTypes[indexPath.row].name
        cell.imageView.image = UIImage(named: "filters/" +  filterName)?.resizeImage(newHeight: 200) ?? UIImage.filterIcon
        cell.label.text = filterName
        cell.isPro = viewModel.filterTypes[indexPath.row].isPro && !GlobalData.isPro
        return cell
    }
    
    // Delegate Methods
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let filter = viewModel.filterTypes[indexPath.row]
        
        if filter.isPro && !GlobalData.isPro {
            self.presentInAppViewController()
            collectionView.deselectItem(at: indexPath, animated: false)
        } else {
            delegate?.didSelectFilter(filter: viewModel.filterTypes[indexPath.row])
        }
    }
    
    // FlowLayout methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70, height: 100)
    }
}
