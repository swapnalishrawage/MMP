//
//  EmergencyCell.swift
//  MakeMePopular
//
//  Created by sachin shinde on 13/01/17.
//  Copyright © 2017 Realizer. All rights reserved.
//


import UIKit

class EmergencyCell: UICollectionViewCell {
    
   
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var emerIcon: UIImageView!
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
        
        
        name.text = interest
        name.textColor = utils.hexStringToUIColor(hex: textColor)
        
        utils.setEmergecy(emergency: interest, txtColor: textColor, iconView: emerIcon)
        
    }
    
}
