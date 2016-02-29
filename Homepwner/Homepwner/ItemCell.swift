//
//  ItemCell.swift
//  Homepwner
//
//  Created by Akshay Iyer on 2/28/16.
//  Copyright © 2016 akshaytiyer. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var valueLabel: UILabel!
    @IBOutlet var serialNumberLabel: UILabel!
    
    func updateLables() {
        let bodyFont = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        nameLabel.font = bodyFont
        valueLabel.font = bodyFont
        
        let caption1Font = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1)
        serialNumberLabel.font = caption1Font
        
    }
    
}
  