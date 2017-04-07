//
//  ThreadDetailModel.swift
//  MakeMePopular
//
//  Created by Rz on 28/03/17.
//  Copyright © 2017 Realizer. All rights reserved.
//

import UIKit
import ObjectMapper
class ThreadDetailModel: Mappable {
    
    var initiateId:String?
    var initiateName:String?
    var threadCustomName:String?
    var threadId:String?
        var threadName:String?
    var  thumbnailUrl:String?
   
    var timeStamp:String?
   // var isDeliver:Bool?
       var participant:[participantListModel]?
    //var participant = Mapper<participantListModel>().mapArray(JSONString: p)
    required init?(map: Map) {
        
    }
    
    
    func mapping(map: Map) {
        
        initiateId<-map["initiateId"]
        initiateName <- map["initiateName"]
        threadCustomName <- map["threadCustomName"]
       threadId <- map["threadId"]
        threadName <- map["threadName"]

        thumbnailUrl <- map["thumbnailUrl"]
        timeStamp <- map["timeStamp"]
        
    participant <- map["participantListModel"]
        
    }
    init()
    {
        
    }
    


}
// class participantListModel: Mappable {
//    var participantId: String?
//    var participantName: String?
//    var thumbnailUrl: String?
//    
//    required init?(map: Map){
//    }
//    func mapping(map: Map) {
//        
//        participantId <- map["participantId"]
//        participantName <- map["participantName"]
//        thumbnailUrl <- map["thumbnailUrl"]
//       
//        
//    }
//    init()
//    {
//        
//    }
//    
//}
