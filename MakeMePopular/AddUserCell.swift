//
//  AddUserCell.swift
//  MakeMePopular
//
//  Created by Rz on 30/03/17.
//  Copyright © 2017 Realizer. All rights reserved.
//

import UIKit

class AddUserCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var img: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updatecell(Image:String, Name:String,ID:String)
    {
        
        //img.image=Image as
        name.text=Name
        
        let v=name.text
        
        let stArr = v?.components(separatedBy: " ")
        var st=""
        for s in stArr!{
            if let      str=s.characters.first{
                st+=String(str).capitalized
            }
        }
        let img1 = ImageToText()
        let tempimg = img1.textToImage(drawText: st as NSString, inImage:#imageLiteral(resourceName: "gray"), atPoint: CGPoint(x: 20.0, y: 20.0))
        self.img.layer.borderColor = UIColor.gray.cgColor
        self.img.layer.cornerRadius = 17.7
        self.img.layer.masksToBounds = true
        
        img.image = tempimg
        
        
        if(Image != ""){
            let imagedownload = DownloadImage()
            imagedownload.setImage(imageurlString: Image, imageView: img)
        }
        
        
    }
}
