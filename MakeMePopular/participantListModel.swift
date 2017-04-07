//
//  participantListModel.swift
//  MakeMePopular
//
//  Created by Rz on 28/03/17.
//  Copyright © 2017 Realizer. All rights reserved.
//

import UIKit
import ObjectMapper
class participantListModel: Mappable {
    var participantId: String?
    var participantName: String?
    var thumbnailUrl: String?
    
    required init?(map: Map){
    }
    func mapping(map: Map) {
        
        participantId <- map["participantId"]
        participantName <- map["participantName"]
        thumbnailUrl <- map["thumbnailUrl"]
        
        
    }
    init()
    {
        
    }
    
}
