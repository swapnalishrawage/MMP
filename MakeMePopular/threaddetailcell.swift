//
//  threaddetailcellTableViewCell.swift
//  MakeMePopular
//
//  Created by Rz on 28/03/17.
//  Copyright © 2017 Realizer. All rights reserved.
//

import UIKit

class threaddetailcell: UITableViewCell {

    @IBOutlet weak var lblname: UILabel!
   
    @IBOutlet weak var imglogo: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updatecell(image:String ,name1:String)
{
    lblname.text=name1
    
    let v=lblname.text
    
    let stArr = v?.components(separatedBy: " ")
    var st=""
    for s in stArr!{
        if let      str=s.characters.first{
            st+=String(str).capitalized
        }
    }
    let img = ImageToText()
    let tempimg = img.textToImage(drawText: st as NSString, inImage:#imageLiteral(resourceName: "gray"), atPoint: CGPoint(x: 20.0, y: 20.0))
    self.imglogo.layer.borderColor = UIColor.gray.cgColor
    self.imglogo.layer.cornerRadius = 17.7
    self.imglogo.layer.masksToBounds = true
    imglogo.image = tempimg
    
    
    if(image != ""){
        let imagedownload = DownloadImage()
        imagedownload.setImage(imageurlString: image, imageView: imglogo)
    }
    
    
    }
}
