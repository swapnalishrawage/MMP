//
//  LastMessageTableCell.swift
//  MakeMePopular
//
//  Created by sachin shinde on 08/02/17.
//  Copyright © 2017 Realizer. All rights reserved.
//



import UIKit

class LastMessageTableCell: UITableViewCell {
    
    @IBOutlet weak var lblLastMsgTime: UILabel!
    @IBOutlet weak var lblLastMsg: UILabel!
    @IBOutlet weak var lblinitialname: UILabel!
    @IBOutlet weak var senderimage: UIImageView!
    @IBOutlet weak var lblLastMsgSender: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    
    func updateCell(threadname:String,lastMsgtext:String,lastMsgSenderImg:String,LastMsgTime:String)
    {
        
        lblLastMsgSender.text = threadname;
        lblLastMsg.text = lastMsgtext;
        lblLastMsgTime.text=LastMsgTime;
        
        let v=lblLastMsgSender.text
        let stArr = v?.components(separatedBy: " ")
        var st=""
        for s in stArr!{
            if let      str=s.characters.first{
                st+=String(str).capitalized
            }
        }
        
        let img = ImageToText()
        let tempimg = img.textToImage(drawText: st as NSString, inImage: #imageLiteral(resourceName: "greybg"), atPoint: CGPoint(x: 20.0, y: 20.0))
        senderimage.layer.borderColor = UIColor.gray.cgColor
        senderimage.layer.cornerRadius = 25.7
        senderimage.layer.masksToBounds = true
        senderimage.image = tempimg
        
        
        if(lastMsgSenderImg != ""){
            let imagedownload = DownloadImage()
            imagedownload.setImage(imageurlString: lastMsgSenderImg, imageView: senderimage)
        }
             
    }
    
    
}

