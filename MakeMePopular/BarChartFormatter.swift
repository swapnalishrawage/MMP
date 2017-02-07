//
//  BarChartFormatter.swift
//  MakeMePopular
//
//  Created by sachin shinde on 13/01/17.
//  Copyright © 2017 Realizer. All rights reserved.
//

import UIKit
import Foundation
import Charts

@objc(BarChartFormatter)
public class BarChartFormatter: NSObject, IAxisValueFormatter
{
    var days: [String]! = ["Last Month", "Last Week", "Today"]
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String
    {
        if(value == 0){
            return days[0]
        }
        else if(value == 10 || value == 1){
        return days[1]
        }
        else if(value == 20 || value == 2){
            return days[2]
        }
        else{
            return days[1]
        }
    }
}
