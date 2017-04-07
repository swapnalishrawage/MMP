//
//  friendlistcellcoll.swift
//  MakeMePopular
//
//  Created by Rz on 30/03/17.
//  Copyright © 2017 Realizer. All rights reserved.
//

import UIKit

class friendlistcellcoll: UICollectionViewCell {
    
    @IBOutlet weak var lbldate: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    
    
    func updatecell(Image:String, Name:String,ID:String)
    {
        
        //img.image=Image as
        name.text=Name
        lbldate.text=ID
        let v=Name
       
        let stArr = v.components(separatedBy: " ")
        var st=""
        for s in stArr{
            if let      str=s.characters.first{
                st+=String(str).capitalized
            }
        }
        let img1 = ImageToText()
        let tempimg = img1.textToImage(drawText: st as NSString, inImage:#imageLiteral(resourceName: "gray"), atPoint: CGPoint(x: 20.0, y: 20.0))
        self.image.layer.borderColor = UIColor.gray.cgColor
        self.image.layer.cornerRadius = 40.7
        self.image.layer.masksToBounds = true
        
        image.image = tempimg
        
        
        if(Image != ""){
            let imagedownload = DownloadImage()
            imagedownload.setImage(imageurlString: Image, imageView: image)
        }
        
        
    }
    
}


