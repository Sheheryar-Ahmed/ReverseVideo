//
//  CircularButton.swift
//  ReverseVideo
//
//  Created by Sheheryar Ahmed on 10/03/2021.
//

import UIKit

class CircularButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    func configure() {
        self.layer.cornerRadius = 15
    }
}
