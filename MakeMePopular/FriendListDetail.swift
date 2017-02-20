//
//  FrienList.swift
//  MakeMePopular
//
//  Created by sachin shinde on 14/02/17.
//  Copyright © 2017 Realizer. All rights reserved.
//

import UIKit
import CoreData

class FriendListDetail: NSObject {
    var context:NSManagedObjectContext!
    @available(iOS 10.0, *)
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func getupdateddateoffriend() -> String{
        
        let request=NSFetchRequest<NSFetchRequestResult>(entityName: "FriendList")
        
        
        var time=""
        var c1:Int!
        if #available(iOS 10.0, *) {
            
            do{
                let searchResults=try self.getContext().fetch(request)
                print ("num of results = \(searchResults.count)")
                c1=searchResults.count-1
                print(c1)
                if(searchResults.count != 0)
                {
                    if((searchResults[0] as AnyObject).value(forKey: "createTS") != nil){
                        time=(searchResults[0] as AnyObject).value(forKey: "createTS") as! String
                        print("\(time)" )
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
    
    func getfriends(friendId:String) -> Bool {
        
        var isPresent:Bool = false
        //create a fetch request, telling it about the entity
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "FriendList")
        let predicate = NSPredicate(format: "friendsUserId == %@", friendId)
        fetchRequest.predicate = predicate
        
        
        do {
            //go get the results
            if #available(iOS 10.0, *) {
                let searchResults = try getContext().fetch(fetchRequest)
                for trans in searchResults as! [NSManagedObject] {
                    //get the Key Value pairs (although there may be a better way to do that...
                    
                    var friendsId:String = ""
                    if(trans.value(forKey: "friendsUserId") != nil){
                        friendsId = trans.value(forKey: "friendsUserId") as! String
                        isPresent = true
                        print(friendsId)
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
    
    func insertfriendlist(friendlist:FriendListModel)
    {
        let appdel:AppDelegate=UIApplication.shared.delegate as! AppDelegate
        if #available(iOS 10.0, *) {
            context = appdel.persistentContainer.viewContext
        } else {
            // Fallback on earlier versions
        }
        
        
        
        let newname=NSEntityDescription.entity(forEntityName: "FriendList", in: self.context)
        print(newname!)
        let newuser=FriendList(entity: newname!,insertInto: self.context)
        
        
        
        newuser.setValue(friendlist.userId, forKey:"userId")
        newuser.setValue(friendlist.friendName, forKey: "friendName")
        print(friendlist.friendName!)
        newuser.setValue(friendlist.friendThumbnailUrl, forKey: "friendThumbnailUrl")
        newuser.setValue(friendlist.friendsId, forKey: "friendsId")
        newuser.setValue(friendlist.isMessagingAllowed, forKey: "isMessagingAllowed")
        print(friendlist.isMessagingAllowed!)
        newuser.setValue(friendlist.status, forKey: "status")
        print(friendlist.status!)
        newuser.setValue(friendlist.friendsUserId, forKey: "friendsUserId")
        newuser.setValue(friendlist.allowTrackingTillDate, forKey:"allowTrackingTillDate")
        newuser.setValue(friendlist.createTS, forKey: "createTS")
        newuser.setValue(friendlist.isEmergencyAlert, forKey:"isEmergencyAlert")
        newuser.setValue(friendlist.isRequestSent, forKey: "isRequestSent")
        newuser.setValue(friendlist.trackingStatusChangeDate, forKey: "trackingStatusChangeDate")
        newuser.setValue(friendlist.isDeleted, forKey: "isdeleted")
        newuser.setValue(friendlist.isTrackingAllowed, forKey: "isTrackingAllowed")
        
        do {
            try self.context.save()
        } catch {
            
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        print(newuser)
        
        print("save")
    }
    func deleteallvalues(){
        // Create Fetch Request
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "FriendList")
        
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
    
    func retrivefriendlist()->[ContactList]
    {
        var contacts:[String] = []
        var clist=[ContactList]()
        let request=NSFetchRequest<NSFetchRequestResult>(entityName: "FriendList")
        
        
        if #available(iOS 10.0, *) {
            do{
                let searchResults = try self.getContext().fetch(request)
                
                print ("num of results = \(searchResults.count)")
                
                //You need to convert to NSManagedObject to use 'for' loops
                for trans in searchResults as! [NSManagedObject] {
                    print(trans)
                    //get the Key Value pairs (although there may be a better way to do that...
                    var userId:String = ""
                    var friendName:String=""
                    var friendThumbnailUrl:String=""
                    var friendsId:String=""
                    var status:String=""
                    var frienduserid:String=""
                    var  isMessagingAllowed:Bool!
                    if(trans.value(forKey: "userId") != nil){
                        userId=trans.value(forKey: "userId") as! String
                        print(userId)
                    }
                    if(trans.value(forKey: "friendName") != nil){
                        friendName=trans.value(forKey: "friendName") as! String
                        print(friendName)
                    }
                    if(trans.value(forKey: "friendsId") != nil){
                        friendsId=trans.value(forKey: "friendsId") as! String
                        print(friendsId)
                    }

                    if(trans.value(forKey: "friendThumbnailUrl") != nil){
                        friendThumbnailUrl=trans.value(forKey: "friendThumbnailUrl") as! String
                        print(friendThumbnailUrl)
                    }
                    if(trans.value(forKey: "friendsUserId") != nil){
                        frienduserid=trans.value(forKey: "friendsUserId") as! String
                        print(frienduserid)
                    }
                    
                    if(trans.value(forKey: "status") != nil){
                        status=trans.value(forKey: "status") as! String
                        print(status)
                    }
                    if(trans.value(forKey: "isMessagingAllowed") != nil){
                        isMessagingAllowed=trans.value(forKey: "isMessagingAllowed") as! Bool
                        print(isMessagingAllowed)
                    }
                    
                  
                    let friend=ContactList(userId: userId, username: friendName, ThumbnailUrl: friendThumbnailUrl, FriendId:friendsId, FrienduserId: frienduserid)
                    
                    
                    if(isMessagingAllowed==true && status=="Accepted"){
                        
                        
                        contacts.append(friendName)
                        
                        clist.append(friend)
                        print(clist.count)
                    }
                    if(status=="Blocked"){
                        
                    }
                    
                    
                    
                }
                
                
            }
            catch{}
        }
        else {
            // Fallback on earlier versions
        }
        
        print(clist.count)
        return clist
        
        
        
    }
    
    func deletsinglefriend(frienduserid:String)
    {
        let predicate = NSPredicate(format: " friendsUserId == %@",frienduserid)
        
        let  fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "FriendList")
        fetchRequest.predicate = predicate
        
        do {
            if #available(iOS 10.0, *) {
                let fetchedEntities = try getContext().fetch(fetchRequest)
                if let entityToDelete = fetchedEntities.first {
                    let e1=entityToDelete as! NSManagedObject
                    self.getContext().delete(e1)
                   
                    
                }
                
            } else {
                // Fallback on earlier versions
            }
            do {
                if #available(iOS 10.0, *) {
                    try self.getContext().save()
                } else {
                    // Fallback on earlier versions
                }
            } catch {
                // Do something in response to error condition
            }
            
        } catch {
            // Do something in response to error condition
        }
        
    }
    
    
}
