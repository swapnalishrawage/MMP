//
//  EmergencyVC.swift
//  MakeMePopular
//
//  Created by sachin shinde on 13/01/17.
//  Copyright © 2017 Realizer. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

class EmergencyVC: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var help: UIImageView!
   
    @IBOutlet weak var noData: UITextView!
    @IBOutlet weak var messagetext: UITextView!
    var emergency=[InterestModel]()
    var emergencyContactList=[FriendListModel]()
    @IBOutlet weak var emergencyCV: UICollectionView!
    
    @IBOutlet weak var emergencyContactTable: UITableView!
    @IBOutlet weak var back: UIImageView!
    var msg:String = ""
    
    var spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    var loadingView: UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        assignbackground()
        
        let utils = Utils()
        emergency = utils.getEmergency()
        
        emergencyCV.delegate = self
        emergencyCV.dataSource = self
        
        self.noData.isHidden = true
        self.emergencyContactTable.isHidden = false
        
        setMessage()
        setUpView()
        
        if(Reachability.isConnectedToNetwork())
        {
            self.showActivityIndicator()
            getEmergencyContactList {}
            
        }else {
            
                        
            let credentialerror = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler:nil)
            
            credentialerror.addAction(cancelAction)
            self.present(credentialerror, animated: true, completion: {  })
            
        }
        
       
       
        
    }
    
    func assignbackground(){
        
        let utils = Utils()
        utils.createGradientLayer(view: self.view)
        
    }
    
    func setMessage(){
        if(UserDefaults.standard.value(forKey: "UserAdrs") != nil && UserDefaults.standard.value(forKey: "UserCity") != nil){
        let adrs = UserDefaults.standard.value(forKey: "UserAdrs") as! String
        let city = UserDefaults.standard.value(forKey: "UserCity") as! String
            msg = "Medical Emergency, I need help at: "+adrs+" , "+city
        }
        else{
            msg = "Medical Emergency, I need help"
        }
        
      
        messagetext.text = msg
    }
    
    func setUpView(){
        let utils = Utils()
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(EmergencyVC.didTapDetected))
        singleTap.numberOfTapsRequired = 1 // you can change this value
        help.isUserInteractionEnabled = true
        help.addGestureRecognizer(singleTap)
        
        back.image = UIImage.fontAwesomeIcon(name: .chevronLeft, textColor: utils.hexStringToUIColor(hex: "ffffff"), size: CGSize(width: 40, height: 45))
        
        let singleTap1 = UITapGestureRecognizer(target: self, action: #selector(EmergencyVC.didBackTapDetected))
        singleTap1.numberOfTapsRequired = 1 // you can change this value
        back.isUserInteractionEnabled = true
        back.addGestureRecognizer(singleTap1)
        
        emergencyContactTable.layer.cornerRadius = 7
        emergencyContactTable.clipsToBounds = true
        emergencyContactTable.layer.borderWidth = 1
        emergencyContactTable.layer.borderColor = utils.hexStringToUIColor(hex: "ffffff").cgColor
        
            messagetext.layer.borderColor = utils.hexStringToUIColor(hex: "ffffff").cgColor
        messagetext.layer.borderWidth = 1

    }
    
    func didTapDetected() {
        
        if(emergencyContactList.count > 0){
        var helptxt:String = msg
        if(messagetext.text != nil){
            helptxt = messagetext.text!
        
            if(Reachability.isConnectedToNetwork())
            {
                self.showActivityIndicator()
            sendEmergencyAlert(completed: {}, mesg: helptxt)
            }else {
                
                let credentialerror = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler:nil)
                
                credentialerror.addAction(cancelAction)
                self.present(credentialerror, animated: true, completion: {  })
                
            }

        }
        else{
            
        }
    }
        else {
            
            let credentialerror = UIAlertController(title: "Emergency", message: "No Emergency friends are added.", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler:nil)
            
            credentialerror.addAction(cancelAction)
            self.present(credentialerror, animated: true, completion: {  })
            
        }

    
    }
    
    func sendEmergencyAlert(completed: DownloadComplete, mesg:String){
        self.view.isUserInteractionEnabled = false
        let methodName = "EmergencyAlert"
        Current_Url = "\(BASE_URL)\(methodName)"
        print(Current_Url)
        
        let current_url = URL(string: Current_Url)!
        
        let userId = UserDefaults.standard.value(forKey: "UserID") as! String
        let lat = UserDefaults.standard.value(forKey: "latitude") as! Double
        let longi = UserDefaults.standard.value(forKey: "longitude") as! Double
        
        let parameters1 = ["userId":userId,"message":mesg,"latitude":lat,"longitude":longi] as [String : Any]
        
        let headers1:HTTPHeaders = ["Content-Type": "application/json",
                                    "Accept": "application/json"]
        
        print(current_url)
        
        Alamofire.request(current_url, method: .post, parameters: parameters1, encoding: JSONEncoding.default, headers: headers1).responseString{ response in
            
            let respo = response.response?.statusCode
            self.view.isUserInteractionEnabled = true
            
            if(respo == 200)
            {
                self.hideActivityIndicator()
                let msgSend = UIAlertController(title: "Emergency Alert", message: "Message sent Successfully", preferredStyle: .alert )
                
                let cancleAction = UIAlertAction(title: "Ok", style: .cancel) {
                    UIAlertAction in
                    //self.setMessage()
                    
                }
                
                msgSend.addAction(cancleAction)
                self.present(msgSend, animated: true, completion: {  })
                
            }
            else{
                self.hideActivityIndicator()
                let credentialerror = UIAlertController(title: "Emergency", message: "Emergency message not sent", preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler:nil)
                
                credentialerror.addAction(cancelAction)
                self.present(credentialerror, animated: true, completion: {  })
            }

            
        }
        
        completed()
    }
    
    
    func getEmergencyContactList(completed: DownloadComplete){
        
        self.view.isUserInteractionEnabled = false
        
        let methodName = "GetEmergencyContactList"
        Current_Url = "\(BASE_URL)\(methodName)"
        print(Current_Url)
        
        let current_url = URL(string: Current_Url)!
        
        let userId = UserDefaults.standard.value(forKey: "UserID") as! String
        let parameters1 = ["userId":userId] as [String : Any]
        
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
                    self.noData.isHidden = true
                    self.emergencyContactTable.isHidden = false
                    self.emergencyContactList = res!
                    self.emergencyContactTable.delegate = self
                    self.emergencyContactTable.dataSource = self
                    self.emergencyContactTable.reloadData()
                    self.emergencyContactTable.isHidden = false
                }
                else{
                    self.noData.isHidden = false
                    self.emergencyContactTable.isHidden = true
                }
                self.view.isUserInteractionEnabled = true
                self.hideActivityIndicator()
            }
            else{
                self.noData.isHidden = true
                self.emergencyContactTable.isHidden = false
                
                self.view.isUserInteractionEnabled = true
                self.hideActivityIndicator()
                let credentialerror = UIAlertController(title: "Emergency", message: "Faliled to fetch Emergency contact, please try after some time.", preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler:nil)
                
                credentialerror.addAction(cancelAction)
                self.present(credentialerror, animated: true, completion: {  })
            }
            
        }
        
        completed()
    }
    
    func didBackTapDetected() {
        
        self.dismiss(animated: true, completion: {})
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emergency.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var bgcolor = "FF6347"
        if(!emergency[indexPath.row].isSelected){
            bgcolor = "ffffff"
        }
        
        if let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "EmergencyCell", for: indexPath as IndexPath) as? EmergencyCell {
            
            let name = emergency[indexPath.row].interestName
            let utils = Utils()
            
            cell.updateCell(interest: name, isSelected: emergency[indexPath.row].isSelected)
            
            cell.backgroundColor = utils.hexStringToUIColor(hex: bgcolor)
            
            cell.layer.cornerRadius = 10
            cell.layer.shadowOpacity = 0.5
            cell.layer.shadowOffset = CGSize(width: 3.0, height: 2.0)
            cell.layer.shadowRadius = 5.0
            cell.layer.shadowColor = UIColor.black.cgColor
            
            cell.layer.borderColor = utils.hexStringToUIColor(hex: "ffffff").cgColor
            cell.layer.borderWidth = 2

            
            
            return cell
        }
        else{
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.setMessage()
        
        let isselected = emergency[indexPath.row].isSelected
        var selected = false
        var bgcolor = "ffffff"
        
        if(isselected){
            selected = false
            bgcolor = "00BCD4"
        }else{
            var adrs = ""
            if( UserDefaults.standard.value(forKey: "UserAdrs") != nil){
                adrs = UserDefaults.standard.value(forKey: "UserAdrs") as! String
            }
            var city = ""
            if(UserDefaults.standard.value(forKey: "UserCity") != nil){
                city = UserDefaults.standard.value(forKey: "UserCity") as! String
            }

            
            selected = true
            if(emergency[indexPath.row]._interestName == "Medical"){
              msg = "Medical Emergency, I need help at: " + adrs + ", " + city
            }
            else if(emergency[indexPath.row]._interestName == "Trouble"){
                msg = "I am in Trouble, need help at " + adrs + ", " + city
            }
            else if(emergency[indexPath.row]._interestName == "Accident"){
                msg = "I have met an accident at " + adrs + ", " + city
            }
            
           
            messagetext.text = msg
            
            for i in 0...2{
                if(i == indexPath.row){
                    
                }
                else{
                    let e1 = emergency[i]
                    let e2 = InterestModel(interest: e1._interestName, isselected: false)
                    emergency[i] = e2
                }
            }
        }
        
        let name = emergency[indexPath.row].interestName
        let utils = Utils()
        
        if let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "EmergencyCell", for: indexPath as IndexPath) as? EmergencyCell {
            
            let i1 = InterestModel(interest: name, isselected: selected)
            emergency[indexPath.row] = i1
            
            cell.updateCell(interest: emergency[indexPath.row].interestName, isSelected: emergency[indexPath.row].isSelected)
            cell.selectedBackgroundView?.backgroundColor = utils.hexStringToUIColor(hex: bgcolor)
            emergencyCV.reloadData()
            
        }
        
    }
    
    
    //Table Delegate Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return emergencyContactList.count
    }
    
    
    //CELL
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell=tableView.dequeueReusableCell(withIdentifier: "EmergencyContactCell", for:indexPath) as? EmergencyContactCell
            
        {
            let friend:FriendListModel = emergencyContactList[indexPath.row]
            cell.updateCell(user: friend)
            
            cell.selectionStyle = .none
            
            cell.isHighlighted = false
            return cell
            
        }
        else{
            
            
            return UITableViewCell()
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
    
    override func viewWillAppear(_ animated: Bool) {
     NotificationCenter.default.addObserver(self, selector:#selector(EmergencyVC.recievedNotification), name: NSNotification.Name(rawValue: "recievednotif"), object: nil)
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

