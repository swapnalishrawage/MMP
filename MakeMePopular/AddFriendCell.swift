//
//  AddFriendCell.swift
//  MakeMePopular
//
//  Created by sachin shinde on 13/01/17.
//  Copyright © 2017 Realizer. All rights reserved.
//

import UIKit
import Charts

class AddFriendCell: UITableViewCell {
    
    @IBOutlet weak var profilePic: UIImageView!
   
    @IBOutlet weak var genderAge: UILabel!
    @IBOutlet weak var addfriend: UIImageView!
    @IBOutlet weak var username: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateCell(user:SearchFriendModel){
       let utils = Utils()
        username.text = user.fName! + " " + user.lName!
        genderAge.text = user.gender! + "," + "\(user.age!)"
        
        if(user.requestStatus == "Pending"){
            addfriend.image = UIImage.fontAwesomeIcon(name: .hourglass1, textColor: utils.hexStringToUIColor(hex: "7D898B"), size: CGSize(width: 35, height: 35))
        }
        else  if(user.requestStatus == "Accepted"){
            addfriend.image = UIImage.fontAwesomeIcon(name: .checkSquareO, textColor: utils.hexStringToUIColor(hex: "5CDD67"), size: CGSize(width: 35, height: 35))
        }
        else{
            addfriend.image = UIImage.fontAwesomeIcon(name: .userPlus, textColor: utils.hexStringToUIColor(hex: "D67D2B"), size: CGSize(width: 35, height: 35))
        }
        profilePic.layer.cornerRadius = 22
        profilePic.clipsToBounds = true
        
        let v = username.text
        let stArr = v?.components(separatedBy: " ")
        var st=""
        for s in stArr!{
            if let      str=s.characters.first{
                st+=String(str).capitalized
            }
        }
        
    
        
        let imgText = ImageToText()
        profilePic.image = imgText.textToImage(drawText: st as NSString, inImage: #imageLiteral(resourceName: "greybg"), atPoint: CGPoint(x: 20.0, y: 20.0))
        if(user.thumbnailUrl != nil){
            if(user.thumbnailUrl != ""){
                let downloadImg = DownloadImage()
                downloadImg.setImage(imageurlString: user.thumbnailUrl!, imageView: profilePic)
            }
        }

    }
}

