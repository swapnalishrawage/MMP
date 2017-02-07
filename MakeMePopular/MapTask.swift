
//
//  MapTask.swift
//  GMapsDemo
//
//  Created by sachin shinde on 09/01/17.
//  Copyright © 2017 Appcoda. All rights reserved.
//

import Foundation
import GoogleMaps

class MapTask: NSObject{
    
    
    /*let baseURLGeocode = "https://maps.googleapis.com/maps/api/geocode/json?"
    
    var lookupAddressResults: Dictionary<String, AnyObject>!
    
    var fetchedFormattedAddress: String!
    
    var fetchedAddressLongitude: Double!
    
    var fetchedAddressLatitude: Double!
    
    let baseURLDirections = "https://maps.googleapis.com/maps/api/directions/json?"
    
    var selectedRoute: Dictionary<String, AnyObject>!
    
    var overviewPolyline: Dictionary<String, AnyObject>!
    
    var originCoordinate: CLLocationCoordinate2D!
    
    var destinationCoordinate: CLLocationCoordinate2D!
    
    var originAddress: String!
    
    var destinationAddress: String!
    
    var totalDistanceInMeters: UInt = 0
    
    var totalDistance: String!
    
    var totalDurationInSeconds: UInt = 0
    
    var totalDuration: String!*/
    
    let nearbyPlaces = "https://maps.googleapis.com/maps/api/place/search/json?"
    var originCoordinate: CLLocationCoordinate2D!
    var totalDistanceInMeters: UInt = 0
    var searchType:String = ""
    var lookupAddressResults: Dictionary<String, AnyObject>!
    var SearchList = [NearByPlacesModel]()
    
    override init() {
        super.init()
    }
    
    func geocodeAddress(address: String!,ty:String!,rad:String, withCompletionHandler completionHandler: @escaping ((_ status: String, _ success: Bool) -> Void)) {
        
        if (address) != nil {
            
            self.SearchList.removeAll()
            
            let loc = address
            
            let rad = "&radius=" + rad
            let typ = "&types=" + ty
            
            var geocodeURLString = nearbyPlaces + "location=" + loc! + rad + typ + "&key=AIzaSyBUThKY77ySu0loIItwOPRWjwNk6pU4L_I"
            
            geocodeURLString = geocodeURLString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
            let geocodeURL = NSURL(string: geocodeURLString)
            
            DispatchQueue.main.async(execute: { () -> Void in
                let geocodingResultsData = NSData(contentsOf: geocodeURL! as URL)
                
                
                do{
                    let dictionary:Dictionary<String, AnyObject>
                        = try JSONSerialization.jsonObject(with: geocodingResultsData! as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, AnyObject>
                    
                    // Get the response status.
                    let status1:String = dictionary["status"] as! String
                    
                    if status1 == "OK" {
                        let allResults = dictionary["results"] as! Array<Dictionary<String, AnyObject>>
                        print("\(allResults)")
                        
                        var count = 10
                        
                        if(allResults.count < 10){
                          count = allResults.count
                        }
                       
                        for i in 0...(count){
                            
                            self.lookupAddressResults = allResults[i] as Dictionary<String, AnyObject>!
                            let geometry = self.lookupAddressResults["geometry"] as! Dictionary<String, AnyObject>
                            
                            let lat = ((geometry["location"] as! Dictionary<String, AnyObject>)["lat"] as! NSNumber).doubleValue
                            
                            let lang = ((geometry["location"] as! Dictionary<String, AnyObject>)["lng"] as! NSNumber).doubleValue
                            
                            let name = self.lookupAddressResults["name"] as! String
                            
                           // let openingHrs = self.lookupAddressResults["opening_hours"] as! Dictionary<String, AnyObject>
                            
                           // let isOpen = openingHrs["open_now"] as! Bool
                            
                            let addrs = self.lookupAddressResults["vicinity"] as! String
                            
                            let obj = NearByPlacesModel(Name: name, IsOpen: false, Lat: lat, Lang: lang, Address: addrs)
                            
                            self.SearchList.append(obj)
                            
                        }
                        
                        
                        completionHandler(status1, true)
                    }
                    else {
                        completionHandler(status1, false)
                    }
                    
                }catch let error as NSError{
                    
                    print("\(error)")
                    completionHandler("", false)
                }
                
            })
        }
        else {
            completionHandler("No valid address.", false)
        }
    }

    
    }
