//
//  ThreadDetailVC.swift
//  MakeMePopular
//
//  Created by Rz on 28/03/17.
//  Copyright © 2017 Realizer. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
class ThreadDetailVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var back: UIImageView!
    @IBOutlet weak var btndetail: UIButton!
    @IBOutlet weak var btngrp: UIButton!
    @IBOutlet weak var tbgrpmember: UITableView!
    @IBOutlet weak var txtgrpname: UITextField!
    @IBOutlet weak var backimg: UIImageView!
       private var   _threaddetail:ThreadDetailModel!
    @IBOutlet weak var btnback: UIButton!
    var  ThreadDetail : ThreadDetailModel{
        get {
            return _threaddetail
            
        }
        set
        {
           _threaddetail = newValue
        }
    }

    var member=[participantListModel]()
    var detail=[ThreadDetailModel]()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        //        UserDefaults.standard.value(forKey: "Test") as! String=="2")
        UserDefaults.standard.set("0", forKey: "TEST")
  UserDefaults.standard.set("a", forKey: "Test")
        
        
//        if(UserDefaults.standard.value(forKey: "Test") as! String=="0")
//        {
//            let presentingViewController = self.presentingViewController
//            let presentingViewController1 = self.presentingViewController
//            self.dismiss(animated: false, completion: {
//                presentingViewController!.dismiss(animated: true, completion: {})
//            })
//                
//
//            self.dismiss(animated: true, completion: {})
//        }        else{
//            
//        }

        
//        if(UserDefaults.standard.value(forKey: "Test") as! String=="3"){
//            self.dismiss(animated: true, completion: nil)
//        }
        
        
        
        txtgrpname.text=ThreadDetail.threadName
        tbgrpmember.delegate=self
        tbgrpmember.dataSource=self
        tbgrpmember.reloadData()
        tbgrpmember.isScrollEnabled=false
       // detail.removeAll()
//       let singleTap = UITapGestureRecognizer(target: self, action: #selector(ThreadDetailVC.didBackTapDetected));
//        back.addGestureRecognizer(singleTap)
//        
//        back.image = UIImage.fontAwesomeIcon(name: .chevronLeft, textColor: UIColor.white, size: CGSize(width: 40, height: 45))
        // Do any additional setup after loading the view.
       
        btngrp.setImage(UIImage.fontAwesomeIcon(name:.check, textColor: UIColor.white, size: CGSize(width: 40, height: 40)), for: UIControlState.normal)
        
        
        btnback.setImage(UIImage.fontAwesomeIcon(name:.chevronLeft, textColor: UIColor.white, size: CGSize(width: 40, height: 40)), for: UIControlState.normal)
        
        
        btndetail.setImage(UIImage.fontAwesomeIcon(name:.userPlus, textColor: UIColor.white, size: CGSize(width: 40, height: 40)), for: UIControlState.normal)
        threaddetail()
    }
    @IBAction func backclick(_ sender: Any) {
        
        
        if(UserDefaults.standard.value(forKey: "Test") as! String=="2"){

        let presentingViewController = self.presentingViewController
        self.dismiss(animated: false, completion: {
            presentingViewController!.dismiss(animated: true, completion: {})
        })
        }

          //UserDefaults.standard.set("n", forKey: "Test")
        
        
        
        if(UserDefaults.standard.value(forKey: "Test") as! String=="2"){
           UserDefaults.standard.set("3", forKey: "Test")
            let presentingViewController = self.presentingViewController
                        self.dismiss(animated: false, completion: {
                presentingViewController!.dismiss(animated: false, completion: {
                    
                                            action in
                        
                    
                        UserDefaults.standard.set("3", forKey: "Test")
                    
                    
                        if(UserDefaults.standard.value(forKey: "Test") as! String=="3"){
                           
                            
                    
                            self.dismiss(animated: true, completion: {})
                            
                            
                            
                        }
                       else{
                          self.dismiss(animated: true, completion: {})
                       }
                    
                   
                    
                })
            })
          //  self.dismiss(animated: true, completion: {})
            
        }
        else if(UserDefaults.standard.value(forKey: "Test") as! String=="3"){
            
            
            // let presentingViewController = self.presentingViewController
            self.dismiss(animated: false, completion: {
                
                action in UserDefaults.standard.set("1", forKey: "Test")
                
                
                
            })
            UserDefaults.standard.set("1", forKey: "Test")
            
            
        }
        else
        {
            self.dismiss(animated: true, completion: {
            })
        }
        
      //  self.dismiss(animated: true, completion: nil)
        

        
    }
    func dismissview(){
    
        let presentingViewController = self.presentingViewController
        self.dismiss(animated: false, completion: {
            presentingViewController!.dismiss(animated: true, completion: {})
        })

    }
    func didBackTapDetected() {
        
        if(UserDefaults.standard.value(forKey: "Test") as! String=="2"){
            
            let presentingViewController = self.presentingViewController
            self.dismiss(animated: false, completion: {
                presentingViewController!.dismiss(animated: true, completion: {})
            })
           
        }
        else if(UserDefaults.standard.value(forKey: "Test") as! String=="3"){
        
        
           // let presentingViewController = self.presentingViewController
                       self.dismiss(animated: false, completion: {
                     
                        action in UserDefaults.standard.set("1", forKey: "Test")
                        
                  
               
            })
     UserDefaults.standard.set("1", forKey: "Test")
        
        
        }
        else
        {
            self.dismiss(animated: true, completion: {
                 })
        }
        
       // self.dismiss(animated: true, completion: nil)
        
    }
    
   
    @IBAction func groupnameclick(_ sender: Any) {
        
        
        
        
        
        let userid:String = UserDefaults.standard.value(forKey: "UserID") as! String
        
        
        let thid:String=ThreadDetail.threadId!
        let thname:String=txtgrpname.text!
      
        
        
        let m = Chat_URL + "setThreadName"
        var base_url:URL? = nil
        base_url = URL(string: m )
        var r=""
        
     let param:Parameters=["threadId":thid,"threadName":thname]
        Alamofire.request(base_url!,method:.put,parameters:param,encoding: JSONEncoding.default).responseJSON{ response in
            let result = response.result
            
            
            if(response.response?.statusCode==200)
            {
                let grpname = UIAlertController(title: "Group  Rename", message: "Group rename successfully done.", preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler:nil)
                
                grpname.addAction(cancelAction)
                self.present(grpname, animated: true, completion: {  })
                print(response)

                
                
            }
            
        }
   

//        print("group name API")
    }
    
    func threaddetail()
    {
        
      // let thid:String=ThreadDetail.threadId!
        
        let thid:String=UserDefaults.standard.value(forKey: "ThID") as! String //UserDefaults.standard.Value(forKey: "ThID") as! String
        
        let m = Chat_URL + "GetThreadDetails/\(thid)"
        var base_url:URL? = nil
        base_url = URL(string: m )
       
        Alamofire.request(base_url!,method:.get).responseJSON{ response in
            let result = response.result
            
            self.detail.removeAll()
            if(response.response?.statusCode==200)
            {
                if let dict = result.value  as?  Dictionary<String,AnyObject>
                    
                {
                    let res = Mapper<ThreadDetailModel>().map(JSONObject: dict)
                    
                    print(res!)
                    
                   
                    
                    print(response)
                    self.tbgrpmember.dataSource=self
                    self.tbgrpmember.delegate=self
                    self.tbgrpmember.reloadData()
                   
                }
                
            }
            
            
            
        }

    }
    
    @IBAction func addthreadclick(_ sender: Any) {
        
        
        UserDefaults.standard.setValue(ThreadDetail.threadId, forKey: "ThID")

     
        //ThreadDetail.threadId
        performSegue(withIdentifier: "squefrdlist", sender:nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "threaddetailcell",for:indexPath) as? threaddetailcell
        {
            let par=ThreadDetail.participant?[indexPath.row]

          
              print("-----\(par?.thumbnailUrl)--\(par?.participantName)")
            cell.updatecell(image:(par?.thumbnailUrl)! , name1: (par?.participantName)!)
            threaddetail()
            return cell
        }
        
        return UITableViewCell()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let fedmem=ThreadDetail.participant?[indexPath.row]
        let thid:String=ThreadDetail.threadId!
      UserDefaults.standard.set(thid, forKey: "threadid")
        
        
        
        
        let m = Chat_URL + "RemoveThreadMember"
        var base_url:URL? = nil
        base_url = URL(string: m )
       
        let name = fedmem?.participantName!
        let memid=fedmem?.participantId!
        
        
        removrthread(Name: name!, memberid: memid!, thid: thid)
        
        tbgrpmember.reloadData()

        
        
        

            }
    
    
    func removrthread(Name:String,memberid:String,thid:String)
    {
    
        
        let m = Chat_URL + "RemoveThreadMember"
        var base_url:URL? = nil
        base_url = URL(string: m )
        
        let name = Name
        let memid=memberid
        let param:Parameters=["threadId":thid,"memberId":memid]
          self.detail.removeAll()
        
        let grpname = UIAlertController(title: "Remove Friend", message: "Are you sure you want to remove \(name)", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler:nil)
        let okAction = UIAlertAction(title: "Remove", style: .default, handler:{action in
            
            Alamofire.request(base_url!,method:.put,parameters:param,encoding: JSONEncoding.default).responseJSON{ response in
                // let result = response.result
                
                
                if(response.response?.statusCode==200)
                {
                    print(response)
                    
               
                    
                }
                
            }
            self.tbgrpmember.dataSource=self
            self.tbgrpmember.delegate=self
            self.tbgrpmember.reloadData()

        })
        grpname.addAction(cancelAction)
        grpname.addAction(okAction)
        self.present(grpname, animated: true, completion: {  })

    
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (ThreadDetail.participant?.count)!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //threaddetail()

        tbgrpmember.delegate=self
        tbgrpmember.dataSource=self
                tbgrpmember.reloadData()
    }
   
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
