//
//  ActivityIndicatorManager.swift
//  ReverseVideo
//
//  Created by Sheheryar Ahmed on 13/03/2021.
//

import UIKit
import NVActivityIndicatorView

class ActivityIndicatorManager {
    
    private var activityIndicatorView: NVActivityIndicatorView?
    
    func startAnimating(in view: UIView) {
        
        if isAnimating() {
            return
        }
        
        activityIndicatorView = NVActivityIndicatorView(frame: view.bounds, type: .ballPulse, color: .rvOrange, padding: view.frame.width / 2.5)
        
        guard let aiv = activityIndicatorView else {
            return
        }
        
        view.addSubview(aiv)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            aiv.topAnchor.constraint(equalTo: view.topAnchor),
            aiv.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            aiv.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            aiv.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        aiv.startAnimating()
    }
    
    func stopAnimating() {
        
        self.activityIndicatorView?.stopAnimating()
        self.activityIndicatorView?.removeFromSuperview()
    }
    
    func isAnimating() -> Bool {
        return activityIndicatorView?.isAnimating ?? false
    }
}
