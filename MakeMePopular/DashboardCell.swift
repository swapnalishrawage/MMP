//
//  DashboardCell.swift
//  MakeMePopular
//
//  Created by sachin shinde on 12/01/17.
//  Copyright © 2017 Realizer. All rights reserved.
//

import UIKit
class DashboardCell: UICollectionViewCell {
    
    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateCell(itemName:String){
        let utils = Utils()
        utils.SetdashboardIcon(interest: itemName, txtColor: "ffffff", iconView: icon)
        name.text = itemName
        
    }
}
