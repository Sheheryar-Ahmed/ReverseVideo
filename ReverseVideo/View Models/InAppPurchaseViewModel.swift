//
//  InAppPurchaseViewModel.swift
//  ReverseVideo
//
//  Created by Sheheryar Ahmed on 18/09/2021.
//

import Foundation
import Purchases

class InAppPurchaseViewModel {
    
    // MARK: Properties
    let videoPath = NSURL.fileURL(withPath: Bundle.main.path(forResource: "premium2", ofType: "mp4")!)
    
    var offering: Purchases.Offering?
    var selectedPackageID: String = RVConstants.InAppPurchase.yearlyPackageID
    
    // MARK: - Methods
    func fetchProducts(completion:@escaping (Result<Purchases.Offering? , Error>) -> Void) {
        Purchases.shared.offerings { (offerings, error) in
            
            if let error = error {
                completion(.failure(error))
            }
            
            self.offering = offerings?.current
            completion(.success(offerings?.current))
        }
    }
}
