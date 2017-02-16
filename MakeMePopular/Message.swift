//
//  Message.swift
//  MakeMePopular
//
//  Created by sachin shinde on 08/02/17.
//  Copyright © 2017 Realizer. All rights reserved.
//



import Foundation

class Message
{
    private var _MsgTime:String!
    private var _MsgSender:String!
    private var _msgtext:String!
    private var _msgSenderimage:String!
    private var _messageId:String!
    private var _senderId:String!
    private var _receiverId:String!
    var MsgTime : String{
        get {
            return _MsgTime
            
        }
        set
        {
            _MsgTime = newValue
        }
    }
    var messageId:String
    {
        return _messageId
        
    }
    var MsgSender:String
    {
        return  _MsgSender
        
    }
    var senderId:String{
        return _senderId
    }
    var receiverId:String
        
    {
        return _receiverId
    }
    var msgtext:String
    {
        return _msgtext
        
    }
    var msgSenderimage:String
    {
        return _msgSenderimage
        
    }
    
    init(MsgSender:String,msgtext:String,MsgTime:String,msgSenderimage:String)
    {
        _MsgSender=MsgSender
        _msgtext=msgtext
        _MsgTime=MsgTime
        _msgSenderimage=msgSenderimage
        
    }
    init(messageId:String,senderId:String,MsgTime:String,msgtext:String,receiverId:String)
    {
        _messageId=messageId
        _senderId=senderId
        _MsgTime=MsgTime
        _msgtext=msgtext
        _receiverId=receiverId
    }
    
}
