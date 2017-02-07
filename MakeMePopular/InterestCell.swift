//
//  InterestCell.swift
//  MakeMePopular
//
//  Created by sachin shinde on 11/01/17.
//  Copyright © 2017 Realizer. All rights reserved.
//

import UIKit

class InterestCell: UICollectionViewCell {
    
    @IBOutlet weak var interestIcon: UIImageView!
    
    @IBOutlet weak var interestName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateCell(interest:String, isSelected:Bool)
    {
    
        var textColor = "00BCD4"
        if(isSelected){
            textColor = "ffffff"
        }
        
        let utils = Utils()
        
        
        interestName.text = interest
        interestName.textColor = utils.hexStringToUIColor(hex: textColor)
        
        utils.SetInterestIcon(interest: interest, txtColor: textColor, iconView: interestIcon)
        
    }
    
}
