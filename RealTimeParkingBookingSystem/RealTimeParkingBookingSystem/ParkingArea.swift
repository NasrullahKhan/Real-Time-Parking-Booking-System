//
//  ParkingArea.swift
//  RealTimeParkingBookingSystem
//
//  Created by Nasrullah Khan on 27/01/2017.
//  Copyright © 2017 Nasrullah Khan. All rights reserved.
//

import Foundation
import ObjectMapper

class ParkingArea:Mappable  {

    var areaName: String?
    var slots: [Slot]?
    var parkingID: String?
    
    init(areaName: String, slots: [Slot]?) {
        self.areaName = areaName
        self.slots = slots
    }

    // Mappable
    func mapping(map: Map) {
        self.areaName           <- map["areaName"]
        self.slots            <- map["slots"]
    }
    
    required init(map: Map) {
        
    }
}
