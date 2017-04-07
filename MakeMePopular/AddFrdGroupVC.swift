////
////  AddFrdGroupVC.swift
////  MakeMePopular
////
////  Created by Rz on 29/03/17.
////  Copyright © 2017 Realizer. All rights reserved.
////
//
//import UIKit
//
//class AddFrdGroupVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
//
//    @IBOutlet weak var imgdone: UIImageView!
//    @IBOutlet weak var back: NSLayoutConstraint!
//    @IBOutlet weak var back1: UIImageView!
//    @IBOutlet weak var tbfrd: UITableView!
//      var clist=[ContactList]()
//       var uid1=[Int]()
//     var contacts:[String] = []
//     let friend1 = FriendListDetail()
//      var userid:String!
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        tbfrd.allowsMultipleSelectionDuringEditing = true
//        tbfrd.setEditing(true, animated: true)
//        
//        let singleTap = UITapGestureRecognizer(target: self, action: #selector(MessageCenterVC.didBackTapDetected))
//        singleTap.numberOfTapsRequired = 1 // you can change this value
    //    back1.isUserInteractionEnabled = true
//        back1.addGestureRecognizer(singleTap)
//        
//        
//        
//        let singleTap1 = UITapGestureRecognizer(target: self, action: #selector(MessageCenterVC.doneclick))
//        singleTap1.numberOfTapsRequired = 1 // you can change this value
//        imgdone.isUserInteractionEnabled = true
//        imgdone.addGestureRecognizer(singleTap1)
//        
//        
//        
//        //attachview.isHidden=true
//        back1.image = UIImage.fontAwesomeIcon(name: .chevronLeft, textColor: UIColor.white, size: CGSize(width: 40, height: 45))
//        
//        // Do any additional setup after loading the view.
//    }
//    func doneclick() {
//        var name=""
//        var u=""
//        for n in 0...uid1.count-1{
//            
//            if(uid1.count>1){
//                
//                userid=u+","+clist[uid1[n]].frienduserId
//                
//                
//            }
//            u=clist[uid1[n]].frienduserId
//            
//        }
//        
//    }
//    override func viewDidAppear(_ animated: Bool) {
//        tablefrd.dataSource=self
//        tablefrd.delegate=self
//        tablefrd.allowsMultipleSelectionDuringEditing = true
//        tablefrd.setEditing(true, animated: true)
//        
//
//    }
//    func didBackTapDetected() {
//        
//        self.dismiss(animated: true, completion: {})
//        
//    }
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if let cell = tableView.dequeueReusableCell(withIdentifier: "friendtablecell",for:indexPath) as? friendtablecell
//        {
//            let Friend=clist[indexPath.row]
//            cell.updatecell(Image: Friend.thumbnailurl, Name: Friend.username,ID:Friend.frienduserId)
//            //            cell.accessoryType = cell.isSelected ? .checkmark : .none
//            //  cell.selectionStyle = .none
//            return cell
//        }
//        return UITableViewCell()
//    }
//    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 
//    }
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
