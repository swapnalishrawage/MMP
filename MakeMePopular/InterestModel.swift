//
//  InterestModel.swift
//  MakeMePopular
//
//  Created by sachin shinde on 11/01/17.
//  Copyright © 2017 Realizer. All rights reserved.
//

import Foundation

class InterestModel{
    var _interestName:String!
    var _isSelected:Bool!
    
    var interestName : String{
        get {
            return _interestName
            
        }
        set
        {
            _interestName = interestName
        }
    }

    
    var isSelected : Bool{
        get {
            return _isSelected
            
        }
        set
        {
            _isSelected = isSelected
        }
    }
    
    init(interest:String, isselected:Bool) {
        _interestName = interest
        _isSelected = isselected
    }

}
