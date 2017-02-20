//
//  MessageList.swift
//  MakeMePopular
//
//  Created by sachin shinde on 10/02/17.
//  Copyright © 2017 Realizer. All rights reserved.
//

import UIKit
import ObjectMapper
import CoreData

@objc
class DBMessageList: NSObject {
    var context:NSManagedObjectContext!
    func insertMessagelist(messagelist:MessageModel)
    {
        
        let appdel:AppDelegate=UIApplication.shared.delegate as! AppDelegate
        
        if #available(iOS 10.0, *) {
            context = appdel.persistentContainer.viewContext
        } else {
            // Fallback on earlier versions
        }
        
        let newname=NSEntityDescription.entity(forEntityName: "MessageList", in: self.context)
        print(newname!)
        let newuser=MessageList(entity: newname!, insertInto: context)
        
        
        newuser.setValue(messagelist.messageId, forKey:"messageId")
        newuser.setValue(messagelist.senderId, forKey: "senderId")
        newuser.setValue(messagelist.timeStamp, forKey: "timeStamp")
        newuser.setValue(messagelist.message, forKey:"message")
        newuser.setValue(messagelist.threadId, forKey: "threadId")
        newuser.setValue(messagelist.receiverId , forKey: "receiverId")
        newuser.setValue(messagelist.senderName!, forKey:"senderName")
        newuser.setValue(messagelist.senderThumbnail, forKey: "senderThumbnail")
        print(messagelist.senderName!)
        
        do {
            try self.context.save()
        } catch {
            
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        print(newuser)
        
        print("save")
    }
    func insertMessagelistNotice(messageId:String,senderId:String,timeStamp:String,message:String,threadId:String,receiverId:String,senderName:String,senderThumbnail:String)
    {
        
        let appdel:AppDelegate=UIApplication.shared.delegate as! AppDelegate
        
        if #available(iOS 10.0, *) {
            context = appdel.persistentContainer.viewContext
        } else {
            // Fallback on earlier versions
        }
        
        let newname=NSEntityDescription.entity(forEntityName: "MessageList", in: self.context)
        print(newname!)
        let newuser=MessageList(entity: newname!, insertInto: context)
        
        
        newuser.setValue(messageId, forKey:"messageId")
        newuser.setValue(senderId, forKey: "senderId")
        newuser.setValue(timeStamp, forKey: "timeStamp")
        newuser.setValue(message, forKey:"message")
        newuser.setValue(threadId, forKey: "threadId")
        newuser.setValue(receiverId , forKey: "receiverId")
        newuser.setValue(senderName, forKey:"senderName")
        newuser.setValue(senderThumbnail, forKey: "senderThumbnail")
        print(senderName)
        
        
        do {
            try self.context.save()
        } catch {
            
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        print(newuser)
        
        print("save")
    }
    @available(iOS 10.0, *)
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func lastupdatetime(thid:String,receiverid:String)->String
    {
        
        let request=NSFetchRequest<NSFetchRequestResult>(entityName: "MessageList")
        
        let predicate = NSPredicate(format: "threadId == %@" , thid)
       
     let p1 =  NSPredicate(format: "receiverId == %@" , receiverid)
        request.predicate = predicate
        request.predicate=p1
        var time=""
        var c1:Int!
        
        let datesortDescriptor = NSSortDescriptor(key: "timeStamp", ascending: false)
        let sortDescriptors = [datesortDescriptor]
        request.sortDescriptors = sortDescriptors
        
        if #available(iOS 10.0, *) {
            
            do{
                let searchResults=try self.getContext().fetch(request)
                print ("num of results = \(searchResults.count)")
                c1=searchResults.count-1
                print(c1)
                if(searchResults.count != 0)
                {
                    if((searchResults[0] as AnyObject).value(forKey: "timeStamp") != nil){
                        time=(searchResults[0] as AnyObject).value(forKey: "timeStamp") as! String
                        print(time)
                    }
                    
                }
                else{
                    time=""
                }
            }
                
                
            catch
            {
                print("no result")
            }
        }
        return time
        
    }
    func getThread(threadId:String) -> Bool {
        
        var isPresent:Bool = false
        //create a fetch request, telling it about the entity
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "MessageList")
        let predicate = NSPredicate(format: "threadId == %@", threadId)
        fetchRequest.predicate = predicate
        
        
        do {
            //go get the results
            if #available(iOS 10.0, *) {
                let searchResults = try getContext().fetch(fetchRequest)
                for trans in searchResults as! [NSManagedObject] {
                    //get the Key Value pairs (although there may be a better way to do that...
                    
                    var threadid:String = ""
                    if(trans.value(forKey: "threadId") != nil){
                        threadid = trans.value(forKey: "threadId") as! String
                        isPresent = true
                        print(threadid)
                    }
                    
                }
                print ("num of results = \(searchResults.count)")
                
            } else {
                // Fallback on earlier versions
            }
            
            //I like to check the size of the returned results!
            
            //You need to convert to NSManagedObject to use 'for' loops
        } catch {
            print("Error with request: \(error)")
        }
        
        return isPresent
    }
    

    func getmessage(messageid:String) -> Bool {
        
        var isPresent:Bool = false
        //create a fetch request, telling it about the entity
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "MessageList")
        let predicate = NSPredicate(format: "messageId == %@", messageid)
        fetchRequest.predicate = predicate
        
        
        do {
            //go get the results
            if #available(iOS 10.0, *) {
                let searchResults = try getContext().fetch(fetchRequest)
                for trans in searchResults as! [NSManagedObject] {
                    //get the Key Value pairs (although there may be a better way to do that...
                    
                    var messageId:String = ""
                    if(trans.value(forKey: "messageId") != nil){
                        messageId = trans.value(forKey: "messageId") as! String
                        isPresent = true
                        print(messageId)
                    }
                    
                }
                print ("num of results = \(searchResults.count)")
                
            } else {
                // Fallback on earlier versions
            }
            
            //I like to check the size of the returned results!
            
            //You need to convert to NSManagedObject to use 'for' loops
        } catch {
            print("Error with request: \(error)")
        }
        
        return isPresent
    }

    func retriveallmessage(threadid:String) ->[Message]
    {
        let request=NSFetchRequest<NSFetchRequestResult>(entityName: "MessageList")
        
        
        let predicate = NSPredicate(format: "threadId == %@", threadid)
        request.predicate = predicate
        print(threadid)

        
        
      
        
        var LastMsg=[Message]()
        if #available(iOS 10.0, *) {
            
            do{
                let searchResults=try self.getContext().fetch(request)
                print ("num of results = \(searchResults.count)")
                
                //You need to convert to NSManagedObject to use 'for' loops
                for trans in searchResults as! [NSManagedObject] {
                    //get the Key Value pairs (although there may be a better way to do that...
                    var messageid:String = ""
                    var senderId:String=""
                    var timeStamp:String=""
                    var message:String!
                    var threadId:String=""
                    var receiverId:String=""
                    var SenderName:String=""
                    var senderThumbnail:String=""
                    if(trans.value(forKey: "messageId") != nil){
                        messageid=trans.value(forKey: "messageId") as! String
                        print(messageid)
                    }
                    if(trans.value(forKey: "message") != nil){
                        message=trans.value(forKey: "message") as! String
                        print( message)
                    }
                    
                    if(trans.value(forKey: "senderId") != nil){
                        senderId=trans.value(forKey: "senderId") as! String
                        print(senderId)
                    }
                    if(trans.value(forKey: "threadId") != nil){
                        threadId=trans.value(forKey: "threadId") as! String
                        print(threadId)
                    }
                    if(trans.value(forKey: "timeStamp") != nil){
                        timeStamp=trans.value(forKey: "timeStamp") as! String
                        print(timeStamp)
                    }
                    if(trans.value(forKey: "receiverId") != nil){
                        receiverId=trans.value(forKey: "receiverId") as! String
                        print(receiverId)
                    }
                    if(trans.value(forKey: "senderName") != nil){
                        SenderName=trans.value(forKey: "senderName") as! String
                        UserDefaults.standard.set(SenderName, forKey: "SenderName")
                        print(SenderName)
                    }
                    if(trans.value(forKey: "senderThumbnail") != nil){
                        senderThumbnail=trans.value(forKey: "senderThumbnail") as! String
                        print(senderThumbnail)
                        UserDefaults.standard.set(senderThumbnail, forKey: "Senderpic")
                    }
                    let msgget=Message(MsgSender: SenderName, msgtext: message, MsgTime:timeStamp, msgSenderimage: senderThumbnail)
                    LastMsg.append(msgget)
                    
                }
                
            }
            catch
            {
                print("no result")
            }
        } else {
            // Fallback on earlier versions
        }
        return LastMsg
        
    }
    
    
    
    
    func retriveallmessage() ->[Message]
    {
        let request=NSFetchRequest<NSFetchRequestResult>(entityName: "MessageList")
        
        
   
        
        
        
        var LastMsg=[Message]()
        if #available(iOS 10.0, *) {
            
            do{
                let searchResults=try self.getContext().fetch(request)
                print ("num of results = \(searchResults.count)")
                
                //You need to convert to NSManagedObject to use 'for' loops
                for trans in searchResults as! [NSManagedObject] {
                    //get the Key Value pairs (although there may be a better way to do that...
                    var messageid:String = ""
                    var senderId:String=""
                    var timeStamp:String=""
                    var message:String!
                    var threadId:String=""
                    var receiverId:String=""
                    var SenderName:String=""
                    var senderThumbnail:String=""
                    if(trans.value(forKey: "messageId") != nil){
                        messageid=trans.value(forKey: "messageId") as! String
                        print(messageid)
                    }
                    if(trans.value(forKey: "message") != nil){
                        message=trans.value(forKey: "message") as! String
                        print( message)
                    }
                    
                    if(trans.value(forKey: "senderId") != nil){
                        senderId=trans.value(forKey: "senderId") as! String
                        print(senderId)
                    }
                    if(trans.value(forKey: "threadId") != nil){
                        threadId=trans.value(forKey: "threadId") as! String
                        print(threadId)
                    }
                    if(trans.value(forKey: "timeStamp") != nil){
                        timeStamp=trans.value(forKey: "timeStamp") as! String
                        print(timeStamp)
                    }
                    if(trans.value(forKey: "receiverId") != nil){
                        receiverId=trans.value(forKey: "receiverId") as! String
                        print(receiverId)
                    }
                    if(trans.value(forKey: "senderName") != nil){
                        SenderName=trans.value(forKey: "senderName") as! String
                        UserDefaults.standard.set(SenderName, forKey: "SenderName")
                        print(SenderName)
                    }
                    if(trans.value(forKey: "senderThumbnail") != nil){
                        senderThumbnail=trans.value(forKey: "senderThumbnail") as! String
                        print(senderThumbnail)
                        UserDefaults.standard.set(senderThumbnail, forKey: "Senderpic")
                    }
                    let msgget=Message(MsgSender: SenderName, msgtext: message, MsgTime:timeStamp, msgSenderimage: senderThumbnail)
                    LastMsg.append(msgget)
                    
                }
                
            }
            catch
            {
                print("no result")
            }
        } else {
            // Fallback on earlier versions
        }
        return LastMsg
        
    }
    func deleteallvalues(){
        // Create Fetch Request
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "MessageList")
        
        // Create Batch Delete Request
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            if #available(iOS 10.0, *) {
                try self.getContext().execute(batchDeleteRequest)
            } else {
                // Fallback on earlier versions
            }
            
        } catch {
            // Error Handling
        }
    }

    override init(){
    }
    
    
}
