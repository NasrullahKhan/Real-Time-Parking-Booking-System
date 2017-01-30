//
//  AdminServices.swift
//  RealTimeParkingBookingSystem
//
//  Created by Nasrullah Khan on 28/01/2017.
//  Copyright © 2017 Nasrullah Khan. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import Firebase
import ObjectMapper

class AdminServices {
    
    static func getAllUSers(comletion:@escaping (_ error:String?)->Void){
        
        cRef.child("users").queryOrdered(byChild: "userType").queryEqual(toValue: 0).observe(.childAdded, with: { (user) in
            let userObj = Mapper<User>().map(JSONObject: user.value!)
            userObj!.uID = user.key
            User.sharedAllUsers.value.append(userObj!)
            AdminServices.getFeedbacks(comletion: { (error) in
                
            })
        })
    }
    
    static func getFeedbacks(comletion:@escaping (_ error:String?)->Void){
        
        for user in User.sharedAllUsers.value {
            
            cRef.child("feedbacks/\(user.uID!)").observe(.childAdded, with: { (data) in
                let dataObj = data.value as! [String:Any]
                let timeStamp = dataObj["timestamp"] as! Double
                let mes = dataObj["message"] as! String
                
                let msgObj = messageStruct(mID: data.key, uID: user.uID!, timestamp: timeStamp, message: mes)
                user.messages.value[data.key] = msgObj
            })
        }
        
    }
    
}

