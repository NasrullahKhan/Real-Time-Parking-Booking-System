//
//  Slot.swift
//  RealTimeParkingBookingSystem
//
//  Created by Nasrullah Khan on 27/01/2017.
//  Copyright © 2017 Nasrullah Khan. All rights reserved.
//

import Foundation
import ObjectMapper

class Slot:Mappable  {
    
    var slotID: String?
    var slotNo: String?
    
    init(slotID: String, slotNo: String) {
        self.slotID = slotID
        self.slotNo = slotNo
    }
    
    // Mappable
    func mapping(map: Map) {
        self.slotNo   <- map["slotNo"]
    }
    
    required init(map: Map) {
        
    }
}
