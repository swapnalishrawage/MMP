//
//  Utils.swift
//  MakeMePopular
//
//  Created by sachin shinde on 10/01/17.
//  Copyright © 2017 Realizer. All rights reserved.
//

import UIKit

class Utils{
    
    var gradientLayer: CAGradientLayer!
    
    init() {
        
    }
    
    func createGradientLayer(view:UIView) {
        gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [hexStringToUIColor(hex: "00838F").cgColor, hexStringToUIColor(hex: "#4DD0E1").cgColor,hexStringToUIColor(hex: "00838F").cgColor]
        
        
        
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    
    func getNotificationType(tag:Int) -> String{
        
        var searchType:String = ""
        
        switch tag {
        case 1:
            searchType = "FriendRequest"
            break
            
        case 2:
            searchType = "Emergency"
            break
            
        case 3:
            searchType = "FriendRequestAccepted"
            break
            
        case 4:
            searchType = "FriendRequestRejected"
            break
            
        case 5:
            searchType = "EmergencyRecipt"
            break
            
        case 6:
            searchType = "TrackingStarted"
       
        default:
            searchType = "Emergency"
            break
        }
      
        return searchType
    }
    
    func getSearchTYpeString(tag:Int) -> String{
        var type:String = ""
        
        switch tag {
        case 1:
            type = "restaurant"
            break
            
        case 2:
            type = "cafe"
            break
            
        case 3:
            type = "shopping_mall"
            break
            
        case 4:
            type = "movie_theater"
            break
            
        case 5:
            type = "atm"
            break
            
        case 6:
            type = "school"
            break
            
        case 7:
            type = "hospital"
            break
            
        case 8:
            type = "park"
            break
        default:
            type = "atm"
            break
        }
        
        return type
        
    }
    
    func setMarkerImage(type:String,imageView:UILabel){
        
        let utils = Utils()
        
        switch type {
            
        case "restaurant":
            imageView.backgroundColor = utils.hexStringToUIColor(hex: "80FF00")
            imageView.textColor = utils.hexStringToUIColor(hex: "ffffff")
            imageView.font = UIFont.fontAwesome(ofSize: 20)
            imageView.text = String.fontAwesomeIcon(name: .cutlery)
            break
            
        case "cafe":
            imageView.backgroundColor = utils.hexStringToUIColor(hex: "FF8000")
            imageView.textColor = utils.hexStringToUIColor(hex: "ffffff")
            imageView.font = UIFont.fontAwesome(ofSize: 20)
            imageView.text = String.fontAwesomeIcon(name: .coffee)
            break
            
        case "shopping_mall":
            imageView.backgroundColor = utils.hexStringToUIColor(hex: "800040")
            imageView.textColor = utils.hexStringToUIColor(hex: "ffffff")
            imageView.font = UIFont.fontAwesome(ofSize: 20)
            imageView.text = String.fontAwesomeIcon(name: .shoppingBag)
            break
            
        case "movie_theater":
            imageView.backgroundColor = utils.hexStringToUIColor(hex: "008040")
            imageView.textColor = utils.hexStringToUIColor(hex: "ffffff")
            imageView.font = UIFont.fontAwesome(ofSize: 20)
            imageView.text = String.fontAwesomeIcon(name: .videoCamera)
            break
            
        case "atm":
            imageView.backgroundColor = utils.hexStringToUIColor(hex: "FF0080")
            imageView.textColor = utils.hexStringToUIColor(hex: "ffffff")
            imageView.font = UIFont.fontAwesome(ofSize: 20)
            imageView.text = String.fontAwesomeIcon(name: .money)
            break
            
        case "school":
            imageView.backgroundColor = utils.hexStringToUIColor(hex: "0080FF")
            imageView.textColor = utils.hexStringToUIColor(hex: "ffffff")
            imageView.font = UIFont.fontAwesome(ofSize: 20)
            imageView.text = String.fontAwesomeIcon(name: .bank)
            break
            
        case "hospital":
            imageView.backgroundColor = utils.hexStringToUIColor(hex: "CC66FF")
            imageView.textColor = utils.hexStringToUIColor(hex: "ffffff")
            imageView.font = UIFont.fontAwesome(ofSize: 20)
            imageView.text = String.fontAwesomeIcon(name: .heartbeat)
            break
            
        case "park":
            imageView.backgroundColor = utils.hexStringToUIColor(hex: "66CCFF")
            imageView.textColor = utils.hexStringToUIColor(hex: "ffffff")
            imageView.font = UIFont.fontAwesome(ofSize: 20)
            imageView.text = String.fontAwesomeIcon(name: .bitbucket)
            break
        default:
            
            break
        }
        
    }
    

    
 
    
    func getEmergency() ->[InterestModel]{
        var emergency = [InterestModel]()
        
        let e1 = InterestModel(interest: "Medical", isselected: true)
        emergency.append(e1)
        
        let e2 = InterestModel(interest: "Trouble", isselected: false)
        emergency.append(e2)
        
        let e3 = InterestModel(interest: "Accident", isselected: false)
        emergency.append(e3)
        
        return emergency
    }
    
    func setEmergecy(emergency:String, txtColor:String, iconView:UIImageView){
        if(emergency == "Medical"){
            iconView.image = UIImage.fontAwesomeIcon(name: .ambulance, textColor: hexStringToUIColor(hex: txtColor), size: CGSize(width: 60, height: 60))
        }
        else if(emergency == "Trouble"){
            iconView.image = UIImage.fontAwesomeIcon(name: .bellSlash, textColor: hexStringToUIColor(hex: txtColor), size: CGSize(width: 60, height: 60))
        }
        else if(emergency == "Accident"){
            iconView.image = UIImage.fontAwesomeIcon(name: .automobile, textColor: hexStringToUIColor(hex: txtColor), size: CGSize(width: 60, height: 60))
        }

    }
   
    func getInterests() -> [InterestModel] {
        
        var interests = [InterestModel]()
      
        
        let i1 = InterestModel(interest: "Trekking/Outing", isselected: false)
        interests.append(i1)
        let i2 = InterestModel(interest: "Dating", isselected: false)
        interests.append(i2)
        let i3 = InterestModel(interest: "Sports", isselected: false)
        interests.append(i3)
        let i4 = InterestModel(interest: "Technical/IT", isselected: false)
        interests.append(i4)
        let i5 = InterestModel(interest: "Music", isselected: false)
        interests.append(i5)
        let i6 = InterestModel(interest: "Dancing", isselected: false)
        interests.append(i6)
        let i7 = InterestModel(interest: "Bikers", isselected: false)
        interests.append(i7)
        let i8 = InterestModel(interest: "Social Work", isselected: false)
        interests.append(i8)
        let i9 = InterestModel(interest: "Gossip", isselected: false)
        interests.append(i9)
        
        
        return interests
        
    }
    
    
    func SetInterestIcon(interest:String, txtColor:String, iconView:UIImageView){
        
        
    
        if(interest == "Trekking/Outing"){
            iconView.image = UIImage.fontAwesomeIcon(name: .blind, textColor: hexStringToUIColor(hex: txtColor), size: CGSize(width: 60, height: 60))
        }
        else if(interest == "Dating"){
            iconView.image = UIImage.fontAwesomeIcon(name: .slideshare, textColor: hexStringToUIColor(hex: txtColor), size: CGSize(width: 60, height: 60))
        }
        else if(interest == "Sports"){
            iconView.image = UIImage.fontAwesomeIcon(name: .soccerBallO, textColor: hexStringToUIColor(hex: txtColor), size: CGSize(width: 60, height: 60))
        }
        else if(interest == "Technical/IT"){
            iconView.image = UIImage.fontAwesomeIcon(name: .laptop, textColor: hexStringToUIColor(hex: txtColor), size: CGSize(width: 60, height: 60))
        }
        else if(interest == "Music"){
            iconView.image = UIImage.fontAwesomeIcon(name: .music, textColor: hexStringToUIColor(hex: txtColor), size: CGSize(width: 60, height: 60))
        }
        else if(interest == "Dancing"){
            iconView.image = UIImage.fontAwesomeIcon(name: .child, textColor: hexStringToUIColor(hex: txtColor), size: CGSize(width: 60, height: 60))
        }
        else if(interest == "Bikers"){
            iconView.image = UIImage.fontAwesomeIcon(name: .motorcycle, textColor: hexStringToUIColor(hex: txtColor), size: CGSize(width: 60, height: 60))
        }
        else if(interest == "Social Work"){
            iconView.image = UIImage.fontAwesomeIcon(name: .group, textColor: hexStringToUIColor(hex: txtColor), size: CGSize(width: 60, height: 60))
        }
        else if(interest == "Gossip"){
            iconView.image = UIImage.fontAwesomeIcon(name: .assistiveListeningSystems, textColor: hexStringToUIColor(hex: txtColor), size: CGSize(width: 60, height: 60))
        }
        
    }
    
    func SetdashboardIcon(interest:String, txtColor:String, iconView:UIImageView){
        
        if(interest == "Emergency"){
            iconView.image = UIImage.fontAwesomeIcon(name: .infoCircle, textColor: hexStringToUIColor(hex: txtColor), size: CGSize(width: 60, height: 60))
        }
        else if(interest == "Friend Near"){
            iconView.image = UIImage.fontAwesomeIcon(name: .streetView, textColor: hexStringToUIColor(hex: txtColor), size: CGSize(width: 60, height: 60))
        }
        else if(interest == "Add Friend"){
            iconView.image = UIImage.fontAwesomeIcon(name: .userPlus, textColor: hexStringToUIColor(hex: txtColor), size: CGSize(width: 60, height: 60))
        }
        else if(interest == "Invite Friend"){
            iconView.image = UIImage.fontAwesomeIcon(name: .envelope, textColor: hexStringToUIColor(hex: txtColor), size: CGSize(width: 60, height: 60))
        }
        else if(interest == "Places Near"){
            iconView.image = UIImage.fontAwesomeIcon(name: .mapMarker, textColor: hexStringToUIColor(hex: txtColor), size: CGSize(width: 60, height: 60))
        }
        else if(interest == "Friend List"){
            iconView.image = UIImage.fontAwesomeIcon(name: .users, textColor: hexStringToUIColor(hex: txtColor), size: CGSize(width: 60, height: 60))
        }
        else if(interest == "Notification"){
            iconView.image = UIImage.fontAwesomeIcon(name: .bell, textColor: hexStringToUIColor(hex: txtColor), size: CGSize(width: 60, height: 60))
        }
        else if(interest == "Chat"){
            iconView.image = UIImage.fontAwesomeIcon(name: .wechat, textColor: hexStringToUIColor(hex: txtColor), size: CGSize(width: 60, height: 60))
        }
        else if(interest == "Album"){
            iconView.image = UIImage.fontAwesomeIcon(name: .filePhotoO, textColor: hexStringToUIColor(hex: txtColor), size: CGSize(width: 60, height: 60))
        }

    }


func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.characters.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
   }
    
    
    func sendMail(text:String){
        let smtpSession = MCOSMTPSession()
        smtpSession.hostname = "smtp.gmail.com"
        smtpSession.username = "sachinshinderzt@gmail.com"
        smtpSession.password = "realizer"
        smtpSession.port = 465
        smtpSession.authType = MCOAuthType.saslPlain
        smtpSession.connectionType = MCOConnectionType.TLS
        smtpSession.connectionLogger = {(connectionID, type, data) in
            if data != nil {
                if let string = NSString(data: data!, encoding: String.Encoding.utf8.rawValue){
                    NSLog("Connectionlogger: \(string)")
                }
            }
        }
        
        let builder = MCOMessageBuilder()
        builder.header.to = [MCOAddress(displayName: "Sachin Shinde", mailbox: "sachinshinderzt1@gmail.com ")]
        builder.header.from = MCOAddress(displayName: "Sachin Shinde", mailbox: "sachinshinderzt@gmail.com")
        builder.header.subject = "IOS: Find Me Friend"
        builder.htmlBody = text
        
        let rfc822Data = builder.data()
        let sendOperation = smtpSession.sendOperation(with: rfc822Data)
        sendOperation?.start { (error) -> Void in
            if (error != nil) {
                NSLog("Error sending email: \(error)")
            } else {
                NSLog("Successfully sent email!")
            }
        }
    }
    
    func getCurrentDate() -> String{
        var localDate:String = ""
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy h:mm a"
        dateFormatter.timeZone = TimeZone.current
        localDate = dateFormatter.string(from: date)
        return localDate
    }
    
}


