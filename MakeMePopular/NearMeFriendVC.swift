//
//  NearMeFriendVC.swift
//  MakeMePopular
//
//  Created by Mac on 20/01/17.
//  Copyright © 2017 Realizer. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire
import ObjectMapper

class NearMeFriendVC: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var filter: UIImageView!
    @IBOutlet weak var back: UIImageView!
    @IBOutlet weak var mapview: GMSMapView!
    
    @IBOutlet weak var filterView: UIView!
    
    @IBOutlet weak var close: UIImageView!
    @IBOutlet weak var radio1: UIImageView!
    var locationManager = CLLocationManager()
    @IBOutlet weak var radio2: UIImageView!
    var didFindMyLocation = false
    var isFavOpen:Bool = false
    
    @IBOutlet weak var pickerView: UIPickerView!
    var mapTasks = MapTask()
    var locationMarker: GMSMarker!
    var originMarker: GMSMarker!
    var destinationMarker: GMSMarker!
    var myLoc:CLLocation!
    var friendID:String = ""
    
    var isradio1Chk:Bool!
    var favOption = [InterestListModel]()
    var friendList = [FriendListModel]()
    var spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    var loadingView: UIView = UIView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        mapview.delegate = self
        self.mapview.isMyLocationEnabled = true
        
         setUpView()
        pickerView.delegate = self
        pickerView.dataSource = self
        filterView.isHidden = true
        
        let utils = Utils()
        back.image = UIImage.fontAwesomeIcon(name: .chevronLeft, textColor: utils.hexStringToUIColor(hex: "ffffff"), size: CGSize(width: 40, height: 45))
        
        
        
        
        myLoc = CLLocation(latitude: UserDefaults.standard.value(forKey: "latitude") as! Double, longitude: UserDefaults.standard.value(forKey: "longitude") as! Double)
        
        friendID = UserDefaults.standard.value(forKey: "FriendSID") as! String
        
        if(friendID == "" || friendID == "All"){
            
            mapview.camera = GMSCameraPosition.camera(withTarget: myLoc.coordinate, zoom: 10.0)
            mapview.settings.myLocationButton = false
            setupMylocationMarker(coordinate: myLoc.coordinate)
            didFindMyLocation = true
            
            let interests:String = UserDefaults.standard.value(forKey: "Interest") as! String
            if(interests == ""){
                if(Reachability.isConnectedToNetwork()){
                 getNearByFriends(completed: {}, interest: "")
                    
                }
                else {
                    
                    let credentialerror = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: .alert)
                    
                    let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler:nil)
                    
                    credentialerror.addAction(cancelAction)
                    self.present(credentialerror, animated: true, completion: {  })
                    
                }
            
                
            }
            else{
                if(Reachability.isConnectedToNetwork()){
                    getNearByFriends(completed: {}, interest: interests)
                    
                }
                else {
                    
                    let credentialerror = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: .alert)
                    
                    let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler:nil)
                    
                    credentialerror.addAction(cancelAction)
                    self.present(credentialerror, animated: true, completion: {  })
                    
                }
                
            }
        }
        else{
            
            mapview.camera = GMSCameraPosition.camera(withTarget: myLoc.coordinate, zoom: 10.0)
            mapview.settings.myLocationButton = false
            setupMylocationMarker(coordinate: myLoc.coordinate)
            didFindMyLocation = true
            
            if(Reachability.isConnectedToNetwork()){
                trackfriend(completed: {}, friendID: friendID)
                
            }
            else {
                
                let credentialerror = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler:nil)
                
                credentialerror.addAction(cancelAction)
                self.present(credentialerror, animated: true, completion: {  })
                
            }

            
           // var timer = Timer.scheduledTimer(timeInterval:2000, target: self, selector: #selector(self.update), userInfo: nil, repeats: true);
        }
        
       
        
    }
    
    func setUpView(){
        isradio1Chk = true
        let utils = Utils()
        
        changeCheck(isr1Check: isradio1Chk)
        
        let singleTap2 = UITapGestureRecognizer(target: self, action: #selector(NearMeFriendVC.didTapRadio1))
        singleTap2.numberOfTapsRequired = 1 // you can change this value
        radio1.isUserInteractionEnabled = true
        radio1.addGestureRecognizer(singleTap2)
        
        let singleTap3 = UITapGestureRecognizer(target: self, action: #selector(NearMeFriendVC.didTapRadio2))
        singleTap3.numberOfTapsRequired = 1 // you can change this value
        radio2.isUserInteractionEnabled = true
        radio2.addGestureRecognizer(singleTap3)
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(NearMeFriendVC.didBackTapDetected))
        singleTap.numberOfTapsRequired = 1 // you can change this value
        back.isUserInteractionEnabled = true
        back.addGestureRecognizer(singleTap)
        
        filter.image = UIImage.fontAwesomeIcon(name: .filter, textColor: utils.hexStringToUIColor(hex: "ffffff"), size: CGSize(width: 40, height: 40))
        let singleTap1 = UITapGestureRecognizer(target: self, action: #selector(NearMeFriendVC.didfilterTapDetected))
        singleTap1.numberOfTapsRequired = 1 // you can change this value
        filter.isUserInteractionEnabled = true
        filter.addGestureRecognizer(singleTap1)
        
        close.image = UIImage.fontAwesomeIcon(name: .close, textColor: utils.hexStringToUIColor(hex: "ffffff"), size: CGSize(width: 40, height: 40))
        let singleTap4 = UITapGestureRecognizer(target: self, action: #selector(NearMeFriendVC.didCloseTapDetected))
        singleTap4.numberOfTapsRequired = 1 // you can change this value
        close.isUserInteractionEnabled = true
        close.addGestureRecognizer(singleTap4)
        
        
        pickerView.layer.borderWidth = 1
        pickerView.layer.borderColor = utils.hexStringToUIColor(hex: "0097A7").cgColor
        
    }
    
    func changeCheck(isr1Check:Bool){
        let utils = Utils()
        
        if(isr1Check == true){
            radio1.image = UIImage.fontAwesomeIcon(name: .checkCircleO, textColor: utils.hexStringToUIColor(hex: "0097A7"), size: CGSize(width: 30, height: 30))
            radio2.image = UIImage.fontAwesomeIcon(name: .circleO, textColor: utils.hexStringToUIColor(hex: "0097A7"), size: CGSize(width: 30, height: 30))
            if(Reachability.isConnectedToNetwork()){
                if(favOption.count == 0){
                  getUserInterest {}
                }
                else{
                    self.pickerView.delegate = self
                    self.pickerView.dataSource = self
                    self.pickerView.reloadAllComponents()
                    self.pickerView.selectRow(0, inComponent: 0, animated: true)
                    
                    if(self.isFavOpen == true){
                        showOnMap(row: 0)
                    }
                   
                }
            }
            else {
                
                let credentialerror = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler:nil)
                
                credentialerror.addAction(cancelAction)
                self.present(credentialerror, animated: true, completion: {  })
                
            }

            
        }else{
            radio2.image = UIImage.fontAwesomeIcon(name: .checkCircleO, textColor: utils.hexStringToUIColor(hex: "0097A7"), size: CGSize(width: 30, height: 30))
            radio1.image = UIImage.fontAwesomeIcon(name: .circleO, textColor: utils.hexStringToUIColor(hex: "0097A7"), size: CGSize(width: 30, height: 30))
            if(Reachability.isConnectedToNetwork()){
                if(friendList.count == 0){
                     getFriendList {}
                }
                else{
                    self.pickerView.delegate = self
                    self.pickerView.dataSource = self
                    self.pickerView.reloadAllComponents()
                    self.pickerView.selectRow(0, inComponent: 0, animated: true)
                    
                    if(isFavOpen == true){
                        showOnMap(row: 0)
                    }
                }

           
            }
            else {
                
                let credentialerror = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler:nil)
                
                credentialerror.addAction(cancelAction)
                self.present(credentialerror, animated: true, completion: {  })
                
            }

        }
        
    }
    
    func didTapView(){
        self.view.endEditing(true)
    }
    
    func didTapRadio1() {
        
        if(isradio1Chk == false)
        {
            isradio1Chk = true
            changeCheck(isr1Check: isradio1Chk)
        }
        
    }
    
    func didTapRadio2() {
        
        if(isradio1Chk == true)
        {
            isradio1Chk = false
            changeCheck(isr1Check: isradio1Chk)
            
        }
    }

    
    func didBackTapDetected() {
        self.mapview.removeObserver(self, forKeyPath: "myLocation", context: nil)
        self.dismiss(animated: true, completion: {})
        
    }
    
    func didfilterTapDetected() {
        
       filterView.isHidden = false
        isFavOpen = true
        
    }
    func didCloseTapDetected() {
        
        filterView.isHidden = true
        isFavOpen = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.mapview.addObserver(self, forKeyPath: "myLocation", options: .new, context: nil)
        
        NotificationCenter.default.addObserver(self, selector:#selector(NearMeFriendVC.recievedNotification), name: NSNotification.Name(rawValue: "recievednotif"), object: nil)
    }
    
    private func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            mapview.isMyLocationEnabled = true
        }
        
    }
    
    @objc override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if !didFindMyLocation {
            let myLocation: CLLocation = change![NSKeyValueChangeKey.newKey] as! CLLocation
            mapview.camera = GMSCameraPosition.camera(withTarget: myLocation.coordinate, zoom: 10.0)
            mapview.settings.myLocationButton = false
            setupMylocationMarker(coordinate: myLocation.coordinate)
            didFindMyLocation = true
            
            myLoc = myLocation
            
        }
        
    }
    
    func setupMylocationMarker(coordinate: CLLocationCoordinate2D) {
        /*let utils = Utils()
        
        locationMarker = GMSMarker(position: coordinate)
        let view1:UIView = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 93))
        let uiImageView:UIImageView  = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        let info1:UITextView = UITextView(frame: CGRect(x: 10, y: 63, width: 40, height: 30))
        
        
        
        info1.backgroundColor = utils.hexStringToUIColor(hex: "00BCD4")
        info1.textColor = utils.hexStringToUIColor(hex: "ffffff")
        info1.layer.cornerRadius = 5
        info1.clipsToBounds = true
        info1.font = UIFont(name: "Avenir", size: 15)
        info1.text = "Me"
        
        uiImageView.layer.cornerRadius = 31
        uiImageView.clipsToBounds = true
        
        let fname:String = UserDefaults.standard.value(forKey: "UserFName") as! String
        let lname:String = UserDefaults.standard.value(forKey: "UserLName") as! String
        let thumbnailurl = UserDefaults.standard.value(forKey: "ProfilePic") as! String
        let v = fname + " " + lname
        let stArr = v.components(separatedBy: " ")
        var st=""
        for s in stArr{
            if let      str=s.characters.first{
                st+=String(str).capitalized
            }
        }
        
        
        
        let imgText = ImageToText()
        uiImageView.image = imgText.textToImage(drawText: st as NSString, inImage: #imageLiteral(resourceName: "greybg"), atPoint: CGPoint(x: 20.0, y: 20.0))
        
        if(thumbnailurl != ""){
            let downloadImg = DownloadImage()
            downloadImg.setImage(imageurlString: thumbnailurl, imageView: uiImageView)
        }
        
        
        
        view1.addSubview(uiImageView)
        view1.addSubview(info1)
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 150, height: 93), false, 0)
        
        view1.drawHierarchy(in: CGRect(x: 0, y: 0, width: view1.bounds.size.width, height: view1.bounds.size.height), afterScreenUpdates: true)
        let markerimg:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        locationMarker.icon = markerimg
        locationMarker.map = mapview*/
        

        
    }
    
    func setuplocationMarker(coordinate: CLLocationCoordinate2D, info: String, userName:String,thumbnailUrl:String) {
        let utils = Utils()
        
        locationMarker = GMSMarker(position: coordinate)
        let view1:UIView = UIView(frame: CGRect(x: 0, y: 0, width: 215, height: 100))
        let uiImageView:UIImageView  = UIImageView(frame: CGRect(x: 2, y: 3, width: 60, height: 60))
        let info1:UITextView = UITextView(frame: CGRect(x: 65, y: 0, width: 150, height: 60))
        let add:UIButton = UIButton(frame: CGRect(x: 65, y: 65, width: 80, height: 25))
       
        info1.contentOffset = CGPoint(x: 0, y: 0)
        
        view1.backgroundColor = utils.hexStringToUIColor(hex: "00BCD4")
        view1.layer.cornerRadius = 5
        view1.clipsToBounds = true
        
        info1.backgroundColor = UIColor.clear
        info1.textColor = utils.hexStringToUIColor(hex: "ffffff")
        info1.font = UIFont(name: "Avenir", size: 15)
        info1.text = info
        
        uiImageView.layer.cornerRadius = 31
        uiImageView.clipsToBounds = true
        
        let v = userName
        let stArr = v.components(separatedBy: " ")
        var st=""
        for s in stArr{
            if let      str=s.characters.first{
                st+=String(str).capitalized
            }
        }
        
        
        
        let imgText = ImageToText()
        uiImageView.image = imgText.textToImage(drawText: st as NSString, inImage: #imageLiteral(resourceName: "greybg"), atPoint: CGPoint(x: 20.0, y: 20.0))
        
        
            if(thumbnailUrl != ""){
                let downloadImg = DownloadImage()
                downloadImg.setImage(imageurlString: thumbnailUrl, imageView: uiImageView)
            }

        
        add.backgroundColor = utils.hexStringToUIColor(hex: "008080")
        add.layer.cornerRadius = 2
        add.layer.shadowOpacity = 0.5
        add.layer.shadowOffset = CGSize(width: 3.0, height: 2.0)
        add.layer.shadowRadius = 5.0
        add.layer.shadowColor = UIColor.black.cgColor
        add.setTitleColor(UIColor.white, for: .normal)
        add.setTitle("Add", for: .normal)
        
    
        
        view1.addSubview(uiImageView)
        view1.addSubview(info1)
        view1.addSubview(add)
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 215, height: 100), false, 0)
        
        view1.drawHierarchy(in: CGRect(x: 0, y: 0, width: view1.bounds.size.width, height: view1.bounds.size.height), afterScreenUpdates: true)
        let markerimg:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        locationMarker.icon = markerimg
        locationMarker.map = mapview
        
    }
    
    func setuplocationMarkerFriend(coordinate: CLLocationCoordinate2D, info: String, userName:String,thumbnailUrl:String) {
        let utils = Utils()
        
        locationMarker = GMSMarker(position: coordinate)
        let view1:UIView = UIView(frame: CGRect(x: 0, y: 0, width: 213, height: 75))
        let uiImageView:UIImageView  = UIImageView(frame: CGRect(x: 3, y: 8, width: 60, height: 60))
        let info1:UITextView = UITextView(frame: CGRect(x: 66, y: 0, width: 150, height: 75))
        
        
        info1.contentOffset = CGPoint(x: 0, y: 0)
        
        view1.backgroundColor = utils.hexStringToUIColor(hex: "00BCD4")
        view1.layer.cornerRadius = 5
        view1.clipsToBounds = true
        
        info1.backgroundColor = UIColor.clear
        info1.textColor = utils.hexStringToUIColor(hex: "ffffff")
        info1.font = UIFont(name: "Avenir", size: 12)
        info1.text = info
        
        uiImageView.layer.cornerRadius = 31
        uiImageView.clipsToBounds = true
        
        let v = userName
        let stArr = v.components(separatedBy: " ")
        var st=""
        for s in stArr{
            if let      str=s.characters.first{
                st+=String(str).capitalized
            }
        }
        
        
        
        let imgText = ImageToText()
        uiImageView.image = imgText.textToImage(drawText: st as NSString, inImage: #imageLiteral(resourceName: "greybg"), atPoint: CGPoint(x: 20.0, y: 20.0))
        
        if(thumbnailUrl != ""){
            let downloadImg = DownloadImage()
            downloadImg.setImage(imageurlString: thumbnailUrl, imageView: uiImageView)
        }

        
        
        view1.addSubview(uiImageView)
        view1.addSubview(info1)
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 213, height: 75), false, 0)
        
        view1.drawHierarchy(in: CGRect(x: 0, y: 0, width: view1.bounds.size.width, height: view1.bounds.size.height), afterScreenUpdates: true)
        let markerimg:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        locationMarker.icon = markerimg
        locationMarker.map = mapview
        
    }

    
    
    func getNearByFriends(completed: DownloadComplete,interest:String){
        
        self.view.isUserInteractionEnabled = false
        self.showActivityIndicator()
        URLCache.shared.removeAllCachedResponses()
        let methodName = "GetNearByfriend"
        Current_Url = "\(TRACK_URL)\(methodName)"
        print(Current_Url)
        
        let current_url = URL(string: Current_Url)!
        
        let userId = UserDefaults.standard.value(forKey: "UserID") as! String
        let latitude:Double = myLoc.coordinate.latitude as Double
        let longitude:Double = myLoc.coordinate.longitude as Double
        
        let ipbody = ["userId":userId, "latitude":latitude, "longitude":
            longitude, "intrest":interest, "distanceBetween":10000] as [String : Any]
        
       
        
        let headers1:HTTPHeaders = ["Content-Type": "application/json",
                                    "Accept": "application/json"]
        
        print(current_url)
        print("\(latitude)")
        print("\(longitude)")
        
        Alamofire.request(current_url, method: .post, parameters: ipbody, encoding: JSONEncoding.default, headers: headers1).responseJSON{ response in
            
            let resStatus = response.response?.statusCode
            let apiResult = response.result
             print("\(resStatus)")
            if(resStatus == 200)
            {
                
               let mapRes = Mapper<NearByFriendResponseModel>().mapArray(JSONObject: apiResult.value)
                print("\(apiResult.value)")
                
                self.mapview.clear()
                
                
                if((mapRes?.count)! > 0){
                    for i in 0 ... ((mapRes?.count)! - 1){
                        
                        let lat:Double = mapRes![i].latitude!
                        let longi:Double = mapRes![i].longitude!
                        
                        let friendLoc = CLLocation(latitude: lat,longitude: longi)
                        let name:String = (mapRes?[i].friendName!)!
                        let gender:String = (mapRes?[i].gender!)!
                        let ageIn:Int = (mapRes?[i].age!)! as Int
                        let age:String = String(describing: ageIn)
                        let thumburl:String = (mapRes?[i].thumbnailUrl!)!
                        
                        
                        var information:String = name + "\n" + gender + ", " + age
                        if(interest == ""){
                            let lastupdate:String = self.getLocalDate(utcDate: (mapRes?[i].lastUpdatedOn)!)
                            
                             information = name + "\n" + gender + " , " + age + "\n" + lastupdate
                            
                            self.setuplocationMarkerFriend(coordinate: friendLoc.coordinate, info: information, userName: name, thumbnailUrl: thumburl)
                        }
                        else{
                        
                        self.setuplocationMarker(coordinate: friendLoc.coordinate,info: information,userName: name,thumbnailUrl: thumburl)
                        }
                        print("\(mapRes?[i].friendName) \(lat) \(longi)")
                        
                    }
                }
                self.setupMylocationMarker(coordinate: self.myLoc.coordinate)
                self.view.isUserInteractionEnabled = true
                self.hideActivityIndicator()
            }
            else{
                self.view.isUserInteractionEnabled = true
                self.hideActivityIndicator()
                let credentialerror = UIAlertController(title: "Near Me Friend", message: "Failed to Track Friend, please try after some time.", preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler:nil)
                
                credentialerror.addAction(cancelAction)
                self.present(credentialerror, animated: true, completion: {  })
            }
            
        }
        
        completed()
    }
    
    func trackfriend(completed: DownloadComplete,friendID:String){
        
        self.view.isUserInteractionEnabled = false
        //self.showActivityIndicator()
        
        let methodName = "TrackFriend"
        Current_Url = "\(TRACK_URL)\(methodName)"
        print(Current_Url)
        
        let current_url = URL(string: Current_Url)!
        
        let userId = UserDefaults.standard.value(forKey: "UserID") as! String
        
        let parameters1 = ["userId":userId,"friendId":friendID, "isNotify":true] as [String : Any]
        
        let headers1:HTTPHeaders = ["Content-Type": "application/json","Accept": "application/json"]
        
        print(current_url)
        
        Alamofire.request(current_url, method: .post, parameters: parameters1, encoding: JSONEncoding.default, headers: headers1).responseJSON{ response in
            
            
            let respo = response.response?.statusCode
            let result = response.result
            print("\(respo)")
            if(respo == 200)
            {
                print("\(result.value)")
                
                if let dict = result.value as? [String: AnyObject]
                {
                    let res = Mapper<TrackFriendModel>().map(JSONObject: dict)
                    
                    let lat:Double = (res?.latitude)!
                    let longi:Double = (res?.longitude)!
                    
                    let friendLoc = CLLocation(latitude: lat,longitude: longi)
                    
                    
                    self.hideActivityIndicator()
                    self.mapview.clear()
                    self.setupMylocationMarker(coordinate: self.myLoc.coordinate)
                    
                    let name:String = (res?.friendName!)!
                    let gender:String = (res?.gender!)!
                    let thumburl:String = (res?.thumbnailUrl!)!
                    let ageIn:Int = (res?.age)! as Int
                    let age:String = String(describing: ageIn)
                    
                    let lastupdate:String = self.getLocalDate(utcDate: (res?.lastUpdatedOn)!)
                    
                    let information:String = name + "\n" + gender + " , " + age + "\n" + lastupdate
                    
                    self.setuplocationMarkerFriend(coordinate: friendLoc.coordinate,info: information,userName: name,thumbnailUrl: thumburl)
                }

                self.view.isUserInteractionEnabled = true
                
            }
            else{
                self.view.isUserInteractionEnabled = true
                 self.hideActivityIndicator()
                let credentialerror = UIAlertController(title: "Near Me Friend", message: "Failed to Track Friend, please try after some time.", preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler:nil)
                
                credentialerror.addAction(cancelAction)
                self.present(credentialerror, animated: true, completion: {  })
            }
            
        }
        
        completed()
    }
    
    
    func getUserInterest(completed: DownloadComplete){
        
        self.view.isUserInteractionEnabled = false
        self.showActivityIndicator()
        
        let methodName = "GetGeneralInterestList/"
        let userID = UserDefaults.standard.value(forKey: "UserID") as! String
        Current_Url = "\(BASE_URL)\(methodName)\(userID)"
        print(Current_Url)
        
        let current_url = URL(string: Current_Url)!
        
        print(current_url)
        
        Alamofire.request(current_url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON{ response in
            
            
            
            let respo = response.response?.statusCode
            let result = response.result
            
            if(respo == 200)
            {
                
                let res = Mapper<InterestListModel>().mapArray(JSONObject: result.value)
                
                
                if((res?.count)! > 0){
                    self.favOption = res!
                    self.pickerView.delegate = self
                    self.pickerView.dataSource = self
                    self.pickerView.reloadAllComponents()
                    if(self.isFavOpen == true){
                    self.showOnMap(row: 0)
                    }
                }
                self.hideActivityIndicator()
                self.view.isUserInteractionEnabled = true
                
            }
            else{
                self.view.isUserInteractionEnabled = true
                self.hideActivityIndicator()
                let credentialerror = UIAlertController(title: "Near Me Friend", message: "Failed to fetch user interest, please try after some time.", preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler:nil)
                
                credentialerror.addAction(cancelAction)
                self.present(credentialerror, animated: true, completion: {  })
            }
            
        }
        
        completed()
    }
    
    
    func getFriendList(completed: DownloadComplete){
        
        self.view.isUserInteractionEnabled = false
        self.showActivityIndicator()
        
        let methodName = "getFriendList"
        Current_Url = "\(BASE_URL)\(methodName)"
        print(Current_Url)
        
        let current_url = URL(string: Current_Url)!
        
        let userId = UserDefaults.standard.value(forKey: "UserID") as! String
        let parameters1 = ["userId":userId,"searchText":""] as [String : Any]
        
        let headers1:HTTPHeaders = ["Content-Type": "application/json",
                                    "Accept": "application/json"]
        
        print(current_url)
        
        Alamofire.request(current_url, method: .post, parameters: parameters1, encoding: JSONEncoding.default, headers: headers1).responseJSON{ response in
            
            let respo = response.response?.statusCode
            let result = response.result
            print("\(result.value)")
            if(respo == 200)
            {
                
                let res = Mapper<FriendListModel>().mapArray(JSONObject: result.value)
                
                if((res?.count)! > 0){
                   
                    
                    for i in 0...((res?.count)! - 1)
                    {
                        if(res?[i].status == "Accepted")
                        {
                            self.friendList.append((res?[i])!)
                        }
                    }
                    
                    if(self.friendList.count > 0){
                        let frnd = FriendListModel()
                        frnd.setupValue(friendName1: "All")
                        self.friendList.append(frnd)
                        
                    }
                    
                    self.pickerView.delegate = self
                    self.pickerView.dataSource = self
                    self.pickerView.reloadAllComponents()
                    
                    if(self.isFavOpen == true){
                         if(self.friendList.count > 0){
                        self.showOnMap(row: 0)
                        }
                    }
                    
                }
                
                self.view.isUserInteractionEnabled = true
                self.hideActivityIndicator()
                
            }else{
                self.hideActivityIndicator()
                let credentialerror = UIAlertController(title: "Near Me Friend", message: "Failed to fetch Friends, please try after some time.", preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler:nil)
                
                credentialerror.addAction(cancelAction)
                self.present(credentialerror, animated: true, completion: {  })
            }
            
        }
        
        completed()
    }
    
    func getLocalDate(utcDate:String) -> String{
        let tempDate:String = utcDate.components(separatedBy: ".")[0]
        var localDate:String = ""
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let date = dateFormatter.date(from: tempDate)// create   date from string
        
        // change to a readable time format and change to local time zone
        dateFormatter.dateFormat = "dd/MM/yyyy h:mm a"
        dateFormatter.timeZone = TimeZone.current
        localDate = dateFormatter.string(from: date!)
        return localDate
    }
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(isradio1Chk == true)
        {
        return favOption.count
        }
        else{
            return friendList.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel = view as? UILabel;
        let utils = Utils()
        
        if (pickerLabel == nil)
        {
            pickerLabel = UILabel()
            
            pickerLabel?.font = UIFont(name: "Avenir", size: 13)
            pickerLabel?.textAlignment = NSTextAlignment.center
            pickerLabel?.textColor = utils.hexStringToUIColor(hex: "000000")
            
            if(isradio1Chk == true){
                pickerLabel?.text = favOption[row].interestName
            }
            else{
                pickerLabel?.text = friendList[row].friendName
            }
        }
        
        return pickerLabel!;
    }

    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(isradio1Chk == true)
        {
        return favOption[row].interestName
        }
        else{
            return friendList[row].friendName
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    
        
        showOnMap(row: row)
        
    }
    
    func showOnMap(row:Int){
        if(isradio1Chk == true){
            if(Reachability.isConnectedToNetwork()){
                getNearByFriends(completed: {}, interest: favOption[row].interestName!)
            }
            else {
                
                let credentialerror = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler:nil)
                
                credentialerror.addAction(cancelAction)
                self.present(credentialerror, animated: true, completion: {  })
                
            }
        }
        else{
            if(Reachability.isConnectedToNetwork()){
                trackfriend(completed: {}, friendID: friendList[row].friendsUserId!)
            }
            else {
                
                let credentialerror = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler:nil)
                
                credentialerror.addAction(cancelAction)
                self.present(credentialerror, animated: true, completion: {  })
                
            }
        }
    }
    
    
    func showActivityIndicator() {
        
        // UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        DispatchQueue.main.async {
            let utils = Utils()
            
            self.loadingView = UIView()
            self.loadingView.frame = CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0)
            self.loadingView.center = self.view.center
            self.loadingView.backgroundColor = utils.hexStringToUIColor(hex: "ffffff")
            self.loadingView.alpha = 0.7
            self.loadingView.clipsToBounds = true
            self.loadingView.layer.cornerRadius = 10
            
            
            let actInd = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
            actInd.color = utils.hexStringToUIColor(hex: "32A7B6")
            self.spinner = actInd
            self.spinner.frame = CGRect(x: 0.0, y: 0.0, width: 80.0, height: 80.0)
            self.spinner.center = CGPoint(x:self.loadingView.bounds.size.width / 2, y:self.loadingView.bounds.size.height / 2)
            
            self.loadingView.addSubview(self.spinner)
            self.view.addSubview(self.loadingView)
            self.spinner.startAnimating()
            
        }
        
    }
    
    
    func hideActivityIndicator() {
        
        DispatchQueue.main.async {
            self.spinner.stopAnimating()
            self.loadingView.removeFromSuperview()
        }
    }
       
    func recievedNotification(){
        
        let pref = UserDefaults.standard
        
        let type:String = pref.string(forKey: "Type")!
        let msg:String = pref.string(forKey: "MessageText")!
        
        if(type == "FriendRequest")
        {
            let storyboardName = "Main"
            let viewControllerID = "FriendRequest"
            let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
            
            let controller:UIViewController = storyboard.instantiateViewController(withIdentifier: viewControllerID)
            self.present(controller, animated: true, completion: nil)
            
        }
        else if(type == "Emergency")
        {
            let storyboardName = "Main"
            let viewControllerID = "EmergencyNotif"
            let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
            
            let controller:UIViewController = storyboard.instantiateViewController(withIdentifier: viewControllerID)
            self.present(controller, animated: true, completion: nil)
        }
        if(type == "FriendRequestAccepted")
        {
            let msgSend = UIAlertController(title: "Friend Request", message: msg, preferredStyle: .alert )
            
            let cancleAction = UIAlertAction(title: "Ok", style: .cancel, handler:nil)
            msgSend.addAction(cancleAction)
            self.present(msgSend, animated: true, completion: {  })
        }
        else if(type == "FriendRequestRejected")
        {
            let msgSend = UIAlertController(title: "Friend Request", message: msg, preferredStyle: .alert )
            
            let cancleAction = UIAlertAction(title: "Ok", style: .cancel, handler:nil)
            msgSend.addAction(cancleAction)
            self.present(msgSend, animated: true, completion: {  })
        }
        if(type == "EmergencyRecipt")
        {
            let msgSend = UIAlertController(title: "Emergency", message: msg, preferredStyle: .alert )
            
            let cancleAction = UIAlertAction(title: "Ok", style: .cancel, handler:nil)
            msgSend.addAction(cancleAction)
            self.present(msgSend, animated: true, completion: {  })
        }
        else if(type == "TrackingRequest")
        {
            let msgSend = UIAlertController(title: "Track Request", message: msg, preferredStyle: .alert )
            
            let cancleAction = UIAlertAction(title: "Ok", style: .cancel, handler:nil)
            msgSend.addAction(cancleAction)
            self.present(msgSend, animated: true, completion: {  })
        }
        if(type == "ApproveTracking")
        {
            let msgSend = UIAlertController(title: "Track Request", message: msg, preferredStyle: .alert )
            
            let cancleAction = UIAlertAction(title: "Ok", style: .cancel, handler:nil)
            msgSend.addAction(cancleAction)
            self.present(msgSend, animated: true, completion: {  })
        }
        else if(type == "TrackingStarted")
        {
            let msgSend = UIAlertController(title: "Tracking", message: msg, preferredStyle: .alert )
            
            let cancleAction = UIAlertAction(title: "Ok", style: .cancel, handler:nil)
            msgSend.addAction(cancleAction)
            self.present(msgSend, animated: true, completion: {  })
        }
        
        
    }

    
}


