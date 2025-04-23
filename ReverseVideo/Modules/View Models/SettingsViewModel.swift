//
//  SettingsViewModel.swift
//  ReverseVideo
//
//  Created by Sheheryar Ahmed on 14/10/2021.
//

enum CellNumber {
    case isFirst
    case isLast
    case isFirstAndLast
    case none
}

class SettingsViewModel {
    
    // MARK: - Properties
    let dataSource = [
        [
            "section": "Premium",
            "items": [
                [
                    "cellNo" : CellNumber.isFirstAndLast,
                    "image": "restore_purchases",
                    "title": "Restore Purchases",
                ]
            ]
        ],
        [
            "section": "Get Inspired",
            "items": [
                [
                    "cellNo" : CellNumber.isFirstAndLast,
                    "image": "instagram",
                    "title": "Instagram",
                    "link": "https://www.instagram.com/touchup_editor/",
                ]
            ]
        ],
        [
            "section": "Help And Support",
            "items": [
                [
                    "cellNo" : CellNumber.isFirst,
                    "image": "rate_app",
                    "title": "Rate app",
                    "link": "https://apps.apple.com/kn/app/background-eraser-touchup/id1544763342",
                ],
                [
                    "cellNo" : CellNumber.isLast,
                    "image": "feedback",
                    "title": "Feedback",
                    "link": "mailto:vyroaiphoto@gmail.com",
                ]
            ]
        ]
    ]
    
    let termsAndServicesURL = "https://drive.google.com/file/d/1CBKNX0dbkkr9wYG5gIG6BRLPlko0U9CN/view"
}
