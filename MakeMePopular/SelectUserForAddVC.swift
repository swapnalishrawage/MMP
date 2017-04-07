//
//  SelectUserForAddVC.swift
//  MakeMePopular
//
//  Created by Rz on 30/03/17.
//  Copyright © 2017 Realizer. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

class SelectUserForAddVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var frddetailstb: UITableView!
    @IBOutlet weak var back: UIImageView!
    @IBOutlet weak var doneimage: UIImageView!
var uid1=[Int]()
    var contacts:[String] = []
    var clist=[ContactList]()
    var userid:String!
    var useridlist:[String]=[]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        hidelabel.isHidden=true
         UserDefaults.standard.set("0", forKey: "TEST")
        
        if(UserDefaults.standard.value(forKey: "TEST") as! String=="1")
        {
            
            self.dismiss(animated: true, completion: {})
        }
        frddetailstb.allowsMultipleSelectionDuringEditing = true
        frddetailstb.setEditing(true, animated: true)
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(SelectUserForAddVC.didBackTapDetected))
        singleTap.numberOfTapsRequired = 1 // you can change this value
        back.isUserInteractionEnabled = true
        back.addGestureRecognizer(singleTap)
        
        
        
        let singleTap1 = UITapGestureRecognizer(target: self, action: #selector(MessageCenterVC.doneclick))
        singleTap1.numberOfTapsRequired = 1 // you can change this value
        doneimage.isUserInteractionEnabled = true
        doneimage.addGestureRecognizer(singleTap1)
        
        
        
        //attachview.isHidden=true
        back.image = UIImage.fontAwesomeIcon(name: .chevronLeft, textColor: UIColor.white, size: CGSize(width: 40, height: 45))
        doneimage.image=UIImage.fontAwesomeIcon(name: .check, textColor: UIColor.white, size: CGSize(width: 40, height: 45))
        // Do any additional setup after loading the view.
        
        
        getFriendList {
            
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ThreadDetailVC
        {
            if let dtl = sender as? ThreadDetailModel{
                
                
                
                destination.ThreadDetail=dtl
            }
        }
    }
    func doneclick() {
        
        var c1=0
//        var name=""
//        var u=""
//        var t1="\",\""
//        print(t1)
//        for n in 0...uid1.count-1{
//            selectfriend.titleLabel?.text=""
//            
//            
//            selectfriend.setTitle(name+","+contacts[uid1[n]], for: UIControlState())
//            
//            name=contacts[uid1[n]]
//            if(uid1.count>1){
//                
//                //userid.append(clist[uid1[n]].frienduserId)
//                userid=u+","+clist[uid1[n]].frienduserId
//                
//                
//                
//                //userid.append(clist[uid1[n]].frienduserId)
//                
//                
//                
//            }
//            
//            u=clist[uid1[n]].frienduserId
//            
//        }
//        print(userid)
        
        
            addthread()
        
        
        
        
        
    }
    
    
    //tableview delegate methods
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "AddUserCell",for:indexPath) as? AddUserCell
        {
            let Friend=clist[indexPath.row]
            cell.updatecell(Image: Friend.thumbnailurl, Name: Friend.username,ID:Friend.frienduserId)
            //            cell.accessoryType = cell.isSelected ? .checkmark : .none
            //  cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle(rawValue: 3)!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("select")
        userid=clist[indexPath.row].frienduserId
        uid1.append(indexPath.row)
        print(uid1)
       //UserDefaults.standard.set("2", forKey: "Test")
    }
    func addthread()
    {
        let m = Chat_URL + "addThreadMember"
        let m0 :Dictionary<String,String> = ["userId":userid]
        //print(userid)
        
        let id:[String]=[userid]
        UserDefaults.standard.set(id, forKey: "UserArray")
        let thid:String=UserDefaults.standard.value(forKey: "ThID") as! String
        
        let param:Parameters=["threadId":thid,"memberId":id]
        
        var base_url:URL? = nil
        base_url = URL(string: m )
        
        
        Alamofire.request(base_url!,method:.put,parameters:param,encoding: JSONEncoding.default).responseJSON{ response in
            let result = response.result
            
            
            if(response.response?.statusCode==200)
            {
                print(response)
                
                 UserDefaults.standard.set("2", forKey: "Test")
                
               
                
                let m = Chat_URL + "GetThreadDetails/\(thid)"
                var base_url:URL? = nil
                base_url = URL(string: m )
               
                Alamofire.request(base_url!,method:.get).responseJSON{ response in
                    let result = response.result
                    
                    
                    if(response.response?.statusCode==200)
                    {
                        if let dict = result.value  as?  Dictionary<String,AnyObject>
                            
                        {
                            let res = Mapper<ThreadDetailModel>().map(JSONObject: dict)
                            // var participant = Mapper<participantListModel>().mapArray(JSONString: dict["participantListModel"] as! String)
                            print(res!)
                            UserDefaults.standard.set("2", forKey: "Test")
                            self.performSegue(withIdentifier: "squeadduser", sender: res!)
                            
                            print(response)
                        }
                        
                    }
                    
                }

                
          //  self.performSegue(withIdentifier: "squeadduser", sender: thid)
                
                
            }
            
        }
        
        
    }
    @IBOutlet weak var hidelabel: UILabel!
    func didBackTapDetected() {
        
        self.dismiss(animated: true, completion: {})
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        
        frddetailstb.dataSource=self
        frddetailstb.delegate=self
        

       frddetailstb.allowsMultipleSelectionDuringEditing = true
        frddetailstb.setEditing(true, animated: true)
        
        

    }
    func getFriendList(completed: @escaping DownloadComplete){
        let friend1=FriendListDetail()
        
        
        
        
        let methodName = "getFriendList"
        Current_Url = "\(BASE_URL)\(methodName)"
        
        
        let current_url = URL(string: Current_Url)!
        let time=friend1.getupdateddateoffriend()
        
        let userId = UserDefaults.standard.value(forKey: "UserID") as! String
        
        var parameters1 = ["userId":userId,"searchText":"","lastUpdatedDate":time] as [String : Any]
        if(time=="")
        {
            parameters1=["userId":userId,"searchText":""] as [String : Any]
            
        }
        
        let headers1:HTTPHeaders = ["Content-Type": "application/json",
                                    "Accept": "application/json"]
        
        print(current_url)
        
        Alamofire.request(current_url, method: .post, parameters: parameters1, encoding: JSONEncoding.default, headers: headers1).responseJSON{ response in
            
            
            let result = response.result
            
            if(response.response?.statusCode==200)
            {
                if let dict = result.value  as?  [Dictionary<String,AnyObject>]
                    
                {
                    let res = Mapper<FriendListModel>().mapArray(JSONObject: dict)
                    
                    
                    if((res?.count)! > 0)
                    {
                        for i in 0...((res?.count)! - 1)
                        {
                            let msg = res?[i]
                            let isfriend:Bool=friend1.getfriends(friendId: (msg?.friendsUserId)!)
                            if(isfriend == true)
                            {
                                
                                
                                //update....
                                
                            }
                                
                            else{
                                
                                friend1.insertfriendlist(friendlist: msg!)
                                
                            }
                        }
                    }
                        
                    else { }
                    
                    self.uid1.removeAll()
                    self.clist.removeAll()
                    self.clist=friend1.retrivefriendlist()
                    
                    
                    print(self.clist)
                    self.contacts.removeAll()
                    if(!self.clist.isEmpty)
                    {
                        for i in 0...(self.clist.count-1){
                            
                            
                            self.clist.sort(){$0.username < $1.username}
                            let m = self.clist[i].username
                            
                            self.contacts.append(m)
                            
                        }
                    }
                    else{
                        self.hidelabel.isHidden=false
                                            
                }
                
            }
            
            if(self.clist.count > 0){
                self.frddetailstb.dataSource=self
                self.frddetailstb.delegate=self
                self.frddetailstb.reloadData()
             
            }
                
            else{
                
                self.hidelabel.isHidden=false
                self.frddetailstb.isHidden=true

            }
            
            
            
                

            completed()
        }
    }
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
