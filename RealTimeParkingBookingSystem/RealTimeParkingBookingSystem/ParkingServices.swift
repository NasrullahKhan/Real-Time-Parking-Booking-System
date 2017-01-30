//
//  ParkingServices.swift
//  RealTimeParkingBookingSystem
//
//  Created by Nasrullah Khan on 27/01/2017.
//  Copyright © 2017 Nasrullah Khan. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import ObjectMapper

class ParkingServices {
    
    static func createParking(area: ParkingArea, completion : @escaping (_ errorDesc : String?) -> Void) {
        
        let slots: [String: Any] = [cRef.childByAutoId().key: ["SlotNo": "SlotNo 1"],cRef.childByAutoId().key: ["SlotNo": "SlotNo 2"],cRef.childByAutoId().key: ["SlotNo": "SlotNo 3"],cRef.childByAutoId().key: ["SlotNo": "SlotNo 4"]]
        
        let parkingEntry: [String: Any] = ["areaName": area.areaName!, "slots": slots]
        
        cRef.child("parking-areas/\(cRef.childByAutoId().key)").setValue(parkingEntry, withCompletionBlock: { (error, reference) in
            if error != nil {
                completion(error!.localizedDescription)
            }else {
                completion(nil)
            }
        })
    }
    
    static func getParkingAreas(completion : @escaping (_ errorDesc : String?) -> Void) {
        
        cRef.child("parking-areas").observe(.childAdded, with: { (data) in
            
            var slots = [Slot]()
            if let parkingArea = data.value as? [String:Any] {
                
                if let allSlots = parkingArea["slots"] as? [String: Any]{
                    
                    for slot in allSlots  {
                        if let slotNo = slot.value as? NSDictionary {
                            let slotObj = Slot(slotID: slot.key , slotNo: slotNo["SlotNo"] as! String)
                            slots.append(slotObj)
                        }
                    }
                }
                
                let parking = ParkingArea(areaName: parkingArea["areaName"]! as! String, slots: slots)
                parking.parkingID = data.key
                
                User.sharedParkings.value[data.key] = parking
            }
        })
    }
    
    static func checkAbvailiblity(pID:String,sID:String,startTime:Int,hours:Int,date:String,comletion:@escaping (_ error:String?)->Void){
        cRef.child("parking-availablity/\(pID)/\(sID)/\(date)").observe(.childAdded, with: { (data) in
            let timeArr = data.value as! [Int]
            for t in timeArr{
                if User.bookedSlots.value[sID] == nil {
                    User.bookedSlots.value[sID] = [t]
                }else{
                    User.bookedSlots.value[sID]!.append(t)
                }
            }
        })
        
        cRef.child("parking-availablity/\(pID)/\(sID)/\(date)").observe(.childRemoved, with: { (data) in
            let timeArr = data.value as! [Int]
            var indeciesArr = [Int]()
            for num in timeArr {
                if User.bookedSlots.value[sID] != nil {
                    let index = User.bookedSlots.value[sID]!.index(of: num)
                    indeciesArr.append(index!)
                }
            }
            
            for index in indeciesArr {
                User.bookedSlots.value[sID]!.remove(at: index)
            }
            
            
        })
    }
    
    static func allocateSlot(uID:String,pID:String,sID:String,startTime:Int,hours:Int,date:String,comletion:@escaping (_ error:String?)->Void){
        
        var calcualtedHours = [Int]()
        var time = startTime
        calcualtedHours.append(time)
        for _ in 1..<hours{
            time+=1
            calcualtedHours.append(time)
        }
        let autoID = cRef.childByAutoId().key
        
        let userData: [String: Any] = ["start": startTime, "hours": hours, "date": date]
        let multipath:[String:Any]  = ["parking-slot-booking-user/\(uID)/\(pID)/\(sID)/\(autoID)" : userData , "parking-availablity/\(pID)/\(sID)/\(date)/\(autoID)":calcualtedHours]
        cRef.updateChildValues(multipath) { (error, ref) in
            if error == nil{
                comletion(nil)
            }else{
                comletion(error!.localizedDescription)
            }
        }
    }
}
