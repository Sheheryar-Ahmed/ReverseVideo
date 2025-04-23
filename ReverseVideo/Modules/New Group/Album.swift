//
//  Album.swift
//  ReverseVideo
//
//  Created by Sheheryar Ahmed on 10/10/2021.
//

import UIKit
import Photos

class Album: NSObject {
    let icon: UIImage?
    let name: String?
    let count: Int
    let assets: PHFetchResult<PHAsset>
    
    init(image: UIImage?, name: String?, assets: PHFetchResult<PHAsset>) {
        self.icon = image
        self.name = name
        self.count = assets.count
        self.assets = assets
    }
}
