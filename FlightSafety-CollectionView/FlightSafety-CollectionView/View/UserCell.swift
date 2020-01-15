//
//  UserCell.swift
//  FlightSafety-CollectionView
//
//  Created by Michael Alexander on 1/15/20.
//  Copyright © 2020 Michael Alexander. All rights reserved.
//

import UIKit

class UserCell: UICollectionViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    var user: User! {
        didSet {
            nameLabel.text = user.name
            nameLabel.adjustsFontSizeToFitWidth = true
        }
    }
    
//    MVVM approach
 
//    var userViewModel: UserViewModel! {
//        didSet {
//            nameLabel.text = userViewModel.name
//            nameLabel.adjustsFontSizeToFitWidth = true
//        }
//    }
}
