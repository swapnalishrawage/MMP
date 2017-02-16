//
//  SelectMessageCenterListVC.swift
//  MakeMePopular
//
//  Created by sachin shinde on 08/02/17.
//  Copyright © 2017 Realizer. All rights reserved.
//


import UIKit
import Alamofire
import FontAwesome_swift
import ObjectMapper
import CoreData

class SelectMessageCenterListVC: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate{
    @IBOutlet weak var contatname: UILabel!
    @IBOutlet weak var messageviewtop: NSLayoutConstraint!
    
    @IBOutlet weak var stviewcentery: NSLayoutConstraint!
    @IBOutlet weak var headerview: UIView!
    @IBOutlet weak var back: UIImageView!
    @IBOutlet weak var textmsg: UITextField!
    @IBOutlet weak var usernamemenu: UIBarButtonItem!
    @IBOutlet weak var sendbutton: UIButton!
    
    var LastMsg=[Message]()
    
    let dbMsg = DBMessageList()
    private var   _lastthreadmsg:LastMsgDtls!
    var  LastThreadMsg : LastMsgDtls{
        get {
            return _lastthreadmsg
            
        }
        set
        {
            _lastthreadmsg = newValue
        }
    }
    
    var sendmsg=[Message]()
    var placeholderLabel : UILabel!
    
    var spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    var loadingView: UIView = UIView()
    
    
    @IBAction func sendMsgClick(_ sender: AnyObject) {
        
        
        if(textmsg.text == "")
        {
            
            let initiateNewThread = UIAlertController(title: "Message Center", message: "Please enter message", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler:nil)
            
            
            
            initiateNewThread.addAction(cancelAction)
            
            
            self.present(initiateNewThread, animated: true, completion: {  })
            hideActivityIndicator()
        }
        else{
            
            downloadSendMsgDetails {}
            
        }
        
    }
    
    @IBOutlet weak var MessageCenter: UITableView!
    @IBOutlet weak var headertop: NSLayoutConstraint!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(SelectMessageCenterListVC.didBackTapDetected))
        singleTap.numberOfTapsRequired = 1 // you can change this value
        back.isUserInteractionEnabled = true
        back.addGestureRecognizer(singleTap)
        back.image = UIImage.fontAwesomeIcon(name: .chevronLeft, textColor: UIColor.white, size: CGSize(width: 40, height: 45))
        NotificationCenter.default.addObserver(self, selector: #selector(loadList(notification:)),name:NSNotification.Name(rawValue: "loadMessage"), object: nil)
        
        
        if Reachability.isConnectedToNetwork() == true{
            
            print("Internet connection OK")
        } else {
            print("Internet connection FAILED")
            
            let uialert = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Ok", style: .cancel, handler:nil)
            
            
            uialert.addAction(okAction)
            
            present(uialert, animated: true, completion: {  })
            
            hideActivityIndicator()
        }
        
        self.textmsg.delegate = self
        
        textmsg.layer.borderColor=UIColor.black.cgColor
        textmsg.layer.borderWidth=1
        textmsg.layer.cornerRadius=5
        
        
        
        
        contatname.text=LastThreadMsg.ThreadName
        
        downloadthreadlmsgDetails {}
        
        loadingView.removeFromSuperview()
        loadingView.isHidden=true
        spinner.stopAnimating()
        spinner.hidesWhenStopped = true
        spinner.backgroundColor=UIColor.white
        hideActivityIndicator()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SelectMessageCenterListVC.dismissKeyboard))
        
        
        view.addGestureRecognizer(tap)
        
        
    }
    
    
    @available(iOS 10.0, *)
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        return appDelegate.persistentContainer.viewContext
        
    }
    
    func didBackTapDetected() {
        
        self.dismiss(animated: true, completion: {})
        
    }
    
    func loadList(notification: NSNotification){
        
        self.showActivityIndicator()
        let t:String=UserDefaults.standard.value(forKey: "ThreadID") as! String
        let newthid=UserDefaults.standard.value(forKey: "THID") as! String
        let lstmsgSender=UserDefaults.standard.value(forKey: "SendBy") as! String
        let lstMsgTime=UserDefaults.standard.value(forKey: "Time") as! String
        let lstMsgText:String=UserDefaults.standard.value(forKey: "MSG") as! String
        let lstSenderImage:String=UserDefaults.standard.value(forKey: "SenderPic") as! String
        
        
        if(t==newthid){
            
            let msgget=Message(MsgSender: lstmsgSender, msgtext:lstMsgText, MsgTime:lstMsgTime, msgSenderimage: lstSenderImage)
            
            
            
            
            self.LastMsg.append(msgget)
            if(LastMsg.count>0)
            {
                MessageCenter.dataSource=self
                MessageCenter.delegate=self
                MessageCenter.reloadData()
            }
            self.hideActivityIndicator()
            MessageCenter.scrollToLastRow(animated: true)
            
        }
        else{
            print("not done")
        }
        self.hideActivityIndicator()
        loadingView.isHidden=true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showActivityIndicator()
    }
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        view.endEditing(true)
        textmsg.resignFirstResponder()
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if(self.LastMsg.count<5)
        {
            
            self.MessageCenter.scrollToMiddle(animated: true)
            
        }
        else{
            self.MessageCenter.scrollToLastRow(animated: true)
        }
        
        
        animateViewMoving(up: true, moveValue:245)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        animateViewMoving(up: false, moveValue: 245)
        
        if(self.LastMsg.count<5)
        {
            self.MessageCenter.scrollToMiddle(animated: true)
        }
        else{
            self.MessageCenter.scrollToLastRow(animated: true)
        }
        
        
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        print("end editing")
        
        if(self.LastMsg.count<5)
        {
            self.MessageCenter.scrollToMiddle(animated: true)
        }
        else{
            self.MessageCenter.scrollToLastRow(animated: true)
        }
        
        
        return true
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    
    @IBAction func exit(_ sender: Any) {
        textmsg.resignFirstResponder()
        let numberOfSections = self.MessageCenter.numberOfSections
        let numberOfRows = self.MessageCenter.numberOfRows(inSection: numberOfSections-1)
        
        if numberOfRows > 0 {
            let indexPath = IndexPath(row: numberOfRows-1, section: numberOfSections-1)
            self.MessageCenter.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: true)
        }
        
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textmsg.resignFirstResponder()
        showActivityIndicator()
        
        return true
    }
    
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        
        
        
        let movementDuration:TimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        
        
        
        
        UITableView.beginAnimations("animateView", context: nil)
        
        UITableView.setAnimationBeginsFromCurrentState(true)
        UITableView.setAnimationDuration(movementDuration)
        
        self.MessageCenter.frame=self.MessageCenter.frame.offsetBy(dx: 0, dy: movement)
        
        headertop.constant=0.0
        
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(0)
        self.headerview.frame = self.view.frame.offsetBy(dx: 0,  dy: 0)
        messageviewtop.constant=0
        UITableView.commitAnimations()
        UIView.commitAnimations()
        
        
    }
    
    
    
    func downloadthreadlmsgDetails(completed: DownloadComplete){
        let m = Chat_URL + "GetThreadMessages"
        if(!self.spinner.isAnimating)
        {
            self.showActivityIndicator()
            
        }
        
        
        var base_url:URL? = nil
        base_url = URL(string: m )
        let time=dbMsg.lastupdatetime()
        
        let param:Parameters=["threadId":LastThreadMsg.ThreadId,"searchText":"","LastMessageTime":time]
        Alamofire.request(base_url!,method: .post,parameters:param).responseJSON{ response in
            let result = response.result
            
            
            self.spinner.backgroundColor=UIColor.white
            self.loadingView.isHidden=true
            self.textmsg.text = ""
            
            if let dict = result.value  as?  [Dictionary<String,AnyObject>]
                
            {
                
                let res = Mapper<MessageModel>().mapArray(JSONObject: dict)
                
                if((res?.count) != 0 )
                {
                    for i in 0...((res?.count)! - 1)
                    {
                        let msg = res?[i]
                        self.dbMsg.insertMessagelist(messagelist: msg!)
                        
                        
                    }
                }
                
                self.LastMsg = self.dbMsg.retriveallmessage()
                self.spinner.backgroundColor=UIColor.white
                
            }
            
            
            self.MessageCenter.reloadData()
            
            
            if (self.MessageCenter.contentSize.height < self.MessageCenter.frame.size.height) {
                self.MessageCenter.isScrollEnabled = false;
                self.hideActivityIndicator()
            }
            else {
                self.MessageCenter.isScrollEnabled = true;
                let numberOfSections = self.MessageCenter.numberOfSections
                let numberOfRows = self.MessageCenter.numberOfRows(inSection: numberOfSections-1)
                
                if numberOfRows > 0 {
                    let indexPath = IndexPath(row: numberOfRows-1, section: numberOfSections-1)
                    self.MessageCenter.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: true)
                    self.hideActivityIndicator()
                }
                
            }
            self.spinner.backgroundColor=UIColor.white
            
            self.hideActivityIndicator()
        }
        
        
        self.MessageCenter.dataSource=self
        self.MessageCenter.delegate=self
        
        
        
        
        completed()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        navigationController?.hidesBarsWhenKeyboardAppears = false
        
    }
    func downloadSendMsgDetails(completed: DownloadComplete){
        
        
        self.showActivityIndicator()
        
        let m = Chat_URL + "sendMessage"
        
        
        
        
        var base_url:URL? = nil
        base_url = URL(string: m )
        
        
        let userid:String = UserDefaults.standard.value(forKey: "UserID") as! String
       
        let receverid:String = _lastthreadmsg.receiverId
        var ReceverId:String!
        
        let initiateid:String = _lastthreadmsg.InitiateId
        
        if(userid == receverid)
        {
            ReceverId = initiateid
        }
        else{
            ReceverId = receverid
        }
        
        
        let msg:String=textmsg.text! as String
        textmsg.text=""
        let date = Date()
        //let dt=DateUtil()
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MM/dd/yyyy HH:mm:ss"
        let d:String=dateformatter.string(from: date)
        
        
        dismissKeyboard()
        
        dateformatter.dateFormat="yyyy-MM-dd"
        
        
        let parameters: Parameters = ["senderId":userid,"timeStamp":d,"message":msg,"threadId":LastThreadMsg.ThreadId,"receiverId":ReceverId]
        
        
        Alamofire.request(base_url!,method: .post ,parameters:parameters,encoding:JSONEncoding.default).responseJSON{ response in
            
            var pic:String=""
            print(response)
            self.hideActivityIndicator()
            if((UserDefaults.standard.value(forKey: "Senderpic") as! String) != "")
            {
                pic=UserDefaults.standard.value(forKey: "Senderpic") as! String
            }
            else{
                pic=""
            }
            
            var sender:String!
            if((UserDefaults.standard.value(forKey: "SenderName") as! String)=="")
            {
                sender="ABC"
            }
            else{
                sender=UserDefaults.standard.value(forKey: "SenderName") as! String
                print(sender)
            }
            
            print(d)
            let msgget=Message(MsgSender:sender, msgtext: msg, MsgTime:d, msgSenderimage: pic)
            
            self.LastMsg.append(msgget)
            
            self.MessageCenter.reloadData()
            self.textmsg.text=""
            
            if(self.LastMsg.count<5)
            {
                self.MessageCenter.scrollToMiddle(animated: true)
            }
            else{
                self.MessageCenter.scrollToLastRow(animated: true)
            }
            
            
        }
        
        completed()
        
        
    }
    
    
    
    @IBOutlet weak var backbtn: UIBarButtonItem!
    @IBOutlet weak var lblmsgtime: UILabel!
    @IBOutlet weak var lblmsg: UILabel!
    @IBOutlet weak var lblusername: UILabel!
    @IBOutlet weak var imgsender: UIImageView!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    @IBOutlet weak var sendbtn: UIButton!
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LastMsg.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCenterCell",for:indexPath) as? MessageCenterCell
        {
            
            let LastMsgtest=LastMsg[indexPath.row]
            let dateformat1 = DateFormatter()
            dateformat1.dateFormat = "yyyy-MM-dd"
            let dateobj = DateUtil()
            
            
            let d1=LastMsgtest.MsgTime.components(separatedBy: "T")[0]
            
            
            let dateinput1=dateformat1.date(from: d1)
            
            
            
            
            var dateinput:String!
            var dtinput:String!
            print(LastMsgtest.MsgTime)
            
            let dlocal=dateobj.getLocalDate(utcDate: LastMsgtest.MsgTime)
            print(dlocal)
            
            if(dateinput1 != nil)
            {
                dateinput=dateformat1.string(from: dateinput1!)
                print(dateinput)
                
                
                
                dtinput=dateobj.getDate(date: dateinput, FLAG: "D",t:dlocal)
                print(dtinput)
            }
            else{
                
                let t0:String=LastMsgtest.MsgTime.components(separatedBy: " ")[1]
                print(t0)
                dtinput=dateobj.getDate(date: LastMsgtest.MsgTime, FLAG: "D",t:LastMsgtest.MsgTime)
                
                print(dtinput)
            }
            
            cell.updateCell(MsgSender: LastMsgtest.MsgSender, msgtext: LastMsgtest.msgtext, MsgTime: dtinput, msgSenderimage: LastMsgtest.msgSenderimage)
            
            
            
            
            
            
            
            return cell
            
        }
        self.spinner.backgroundColor=UIColor.white
        return UITableViewCell()
        
    }
    
    func showActivityIndicator() {
        
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
    
    
    
    @IBAction func backbtnpresed(_ sender: AnyObject) {
        
        
        self.dismiss(animated: true) {}
        
        
        
    }
    
    
    
    
    
}
extension UITableView {
    func setOffsetToBottom(animated: Bool) {
        self.setContentOffset(CGPoint(x: 0, y: self.contentSize.height - self.frame.size.height), animated: true)
    }
    
    
    func scrollToLastRow(animated: Bool) {
        
        
        
        if self.numberOfRows(inSection: 0) > 0 {
            self.scrollToRow(at: IndexPath(row: self.numberOfRows(inSection: 0) - 1, section: 0), at: UITableViewScrollPosition.bottom, animated: true)
        }
        
    }
    func scrollToMiddle(animated: Bool) {
        
        
        
        if self.numberOfRows(inSection: 0) > 0 {
            self.scrollToRow(at: IndexPath(row: self.numberOfRows(inSection: 0) - 1, section: 0), at: UITableViewScrollPosition.top, animated: true)
        }
        
    }
    
}
