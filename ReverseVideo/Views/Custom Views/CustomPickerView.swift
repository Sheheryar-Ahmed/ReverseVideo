//
//  customcollectionView.swift
//  TextToImage
//
//  Created by Sheheryar Ahmed on 09/10/2020.
//

import UIKit

protocol CustomPickerViewDelegate {
    func didSelectedFont(font: UIFont)
    func didSelectedColor(color: UIColor)
    func didSelectGradient(colorsArray: [Any])
}

enum collectionViewType {
    case fonts
    case colors
}

class CustomPickerView: UIView {
    
    //MARK:- Properties
    let generator = UIImpactFeedbackGenerator(style: .light)
    var selectedIndex = 0
    var collectionView:UICollectionView!
    var delegate : CustomPickerViewDelegate!
    var fonts = Constants.fonts
    var colors = Constants.plainColorsArray
    var gradients = Constants.colorsForGradients
    var type:collectionViewType = .fonts
    
    //MARK:- Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    //MARK:- Private Methods
    private func configure() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: self.frame, collectionViewLayout: layout)
        self.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FontsCustomPickerCVCell.self, forCellWithReuseIdentifier: Constants.fontsPickerViewCell)
        collectionView.register(ColorCustomPickerCVCell.self, forCellWithReuseIdentifier: Constants.colorsPickerViewCell)
        
        collectionView.allowsMultipleSelection = false
        collectionView.backgroundColor = UIColor(white: 0.3, alpha: 0)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo:self.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo:self.bottomAnchor)
        ])
    }
}

//MARK:- Extentions
extension CustomPickerView:UICollectionViewDelegate,UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch self.type {
        case .fonts:
            return fonts.count
        case .colors:
            return colors.count + gradients.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch self.type {
        case .fonts:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.fontsPickerViewCell, for: indexPath) as! FontsCustomPickerCVCell
            cell.isUserInteractionEnabled = true
            cell.textLabelView.label.text = "Aa"
            cell.textLabelView.label.font = fonts[indexPath.row]
            return cell
            
        case .colors:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.colorsPickerViewCell, for: indexPath) as! ColorCustomPickerCVCell
            cell.isUserInteractionEnabled = true
            cell.layer.cornerRadius = 5
            if indexPath.row < gradients.count {
                cell.backgroundColor = Utilities.getGradientColor(bounds: cell.bounds, colorsArray: gradients[indexPath.row ])
                
            } else {
                cell.backgroundColor = colors[indexPath.row - gradients.count]
            }
            
            return cell
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 34, height: 34)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        UIView.animate(withDuration: 0.6) {
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
        }
        
        switch self.type {
        case .fonts:
            let cell = collectionView.cellForItem(at: indexPath) as? FontsCustomPickerCVCell
            if let cell = cell{
                cell.textLabelView.label.backgroundColor = .white
                cell.textLabelView.label.textColor = .red
                
                if let font = fonts[indexPath.row]{
                    delegate.didSelectedFont(font:font)
                }
            }
        case .colors :
            let cell = collectionView.cellForItem(at: indexPath)
            cell?.layer.borderColor = UIColor.black.cgColor
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        switch self.type {
        case .fonts:
            let cell = collectionView.cellForItem(at: indexPath) as? FontsCustomPickerCVCell
            if let cell = cell{
                cell.textLabelView.label.backgroundColor = .black
                cell.textLabelView.label.textColor = .white
            }
            
        case .colors :
            let cell = collectionView.cellForItem(at: indexPath)
            cell?.layer.borderColor = UIColor.white.cgColor
            
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let center = self.frame.width / 2
        return UIEdgeInsets(top: 0, left: center, bottom: 0, right: center)
    }
    
    
    func selectedElement(at indexPath:IndexPath){
        
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        
        switch self.type {
        case .fonts:
            if let font = fonts[indexPath.row]{
                delegate.didSelectedFont(font: font)
            }
            let cell = collectionView.cellForItem(at: indexPath) as? FontsCustomPickerCVCell
            if let cell = cell{
                cell.textLabelView.label.backgroundColor = .white
                cell.textLabelView.label.textColor = .red
            }
        case .colors:
            let cell = collectionView.cellForItem(at: indexPath)
            cell?.layer.borderColor = UIColor.black.cgColor
            
            if indexPath.row < gradients.count {
                delegate.didSelectGradient(colorsArray: gradients[indexPath.row])
                
            } else {
                delegate.didSelectedColor(color: colors[indexPath.row - gradients.count])
            }
        }
        
        generator.impactOccurred()
    }
}

extension CustomPickerView:UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Find centre point of collection view
        let visiblePoint = CGPoint(x: collectionView.center.x + collectionView.contentOffset.x, y: collectionView.center.y + collectionView.contentOffset.y)
        // Find index path using centre point
        guard let newIndexPath = collectionView.indexPathForItem(at: visiblePoint) else { return }
        // check if the cell is not already selected
        if selectedIndex != newIndexPath.row{
            // select New Item
            selectedElement(at: newIndexPath)
            selectedIndex = newIndexPath.row
            // deselect all other items
            for i in 0...colors.count-1{
                if i != newIndexPath.row{
                    let indexPath = IndexPath(row: i, section: 0)
                    collectionView(collectionView, didDeselectItemAt: indexPath)
                }
            }
            
        }
    }
    
}

