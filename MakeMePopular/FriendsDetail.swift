//
//  FriendsDetail.swift
//  MakeMePopular
//
//  Created by sachin shinde on 11/01/17.
//  Copyright © 2017 Realizer. All rights reserved.
//

import Foundation
import ObjectMapper

class FriendsDetail:Mappable{
    
    
    var friendsDetailsId:String?
    var userId:String?
    var isTrackingAllowed:Bool?
    var isMessagingAllowed:Bool?
    var allowTrackingTillDate:String?
    var createTS:String?
    var trackingStatusChangeDate:String?
    var isEmergencyAlert:Bool?
    var friendThumbnailUrl:String?
    //var UserDetail:UserDetail?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        friendsDetailsId <- map["friendsDetailsId"]
        userId <- map["userId"]
        isTrackingAllowed <- map["isTrackingAllowed"]
        isMessagingAllowed <- map["isMessagingAllowed"]
        allowTrackingTillDate <- map["allowTrackingTillDate"]
        createTS <- map["createTS"]
        trackingStatusChangeDate <- map["trackingStatusChangeDate"]
        isEmergencyAlert <- map["isEmergencyAlert"]
       // UserDetail <- map["UserDetail"]
    }
    
}
