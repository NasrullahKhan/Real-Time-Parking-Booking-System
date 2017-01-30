//
//  UserServices.swift
//  RealTimeParkingBookingSystem
//
//  Created by Nasrullah Khan on 28/01/2017.
//  Copyright © 2017 Nasrullah Khan. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import ObjectMapper


class UserServices {
    
    static func getUserSlots(uID:String,pID:String,sID:String, completion : @escaping (_ errorDesc : String?) -> Void) {
        
        cRef.child("parking-slot-booking-user/\(uID)/\(pID)/\(sID)").observe(.childAdded, with: { (data) in
           
            if let dataDic = data.value as? [String:Any] {
                let userReqObj = UserRequestStruct(reqID: data.key, slotID: sID, pID: pID, hours: dataDic["hours"]! as! Int, start: dataDic["start"]! as! Int, date : dataDic["date"]! as! String)
                
                User.userSlots.value[data.key] = userReqObj
            }
            
        })
        
        cRef.child("parking-slot-booking-user/\(uID)/\(pID)/\(sID)").observe(.childRemoved, with: { (data) in
            
            User.userSlots.value.removeValue(forKey: data.key)
            
        })
    }
    
    static func removeUserSlots(uID: String, userRequest: UserRequestStruct, completion : @escaping (_ errorDesc : String?) -> Void) {
        
        let multiPath = ["parking-slot-booking-user/\(uID)/\(userRequest.pID)/\(userRequest.slotID)/\(userRequest.reqID)": NSNull(),
                                        "parking-availablity/\(userRequest.pID)/\(userRequest.slotID)/\(userRequest.date)/\(userRequest.reqID)": NSNull()]
        cRef.updateChildValues(multiPath, withCompletionBlock: { (error, ref) in
            if error != nil {
                completion(error!.localizedDescription)
            }else {
                completion(nil)
            }
            
        })
      
    }
    
    static func sendFeedback(uID:String,mes:String,comletion:@escaping (_ error:String?)->Void){
        
        let message:[String:Any] = ["message":mes, "timestamp":kFirebaseServerValueTimestamp]
        
        cRef.child("feedbacks/\(uID)").childByAutoId().setValue(message) { (error, ref) in
            if error == nil{
                comletion(nil)
            }else{
                comletion(error!.localizedDescription)
            }
        }
    }
    
    
}



