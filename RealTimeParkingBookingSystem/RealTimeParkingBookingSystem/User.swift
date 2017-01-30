//
//  Model.swift
//  Firebase-SignUP-SignIN
//
//  Created by Nasrullah Khan on 25/01/2017.
//  Copyright © 2017 Nasrullah Khan. All rights reserved.
//

import Foundation
import ObjectMapper
import RxSwift

struct messageStruct{
    var mID: String
    var uID: String
    var timestamp: Double
    var message: String
}

class User:Mappable {
    
    var email: String?
    var name: String?
    var contactNo: String?
    var userType: UserType?
    var password: String?
    var uID: String?
    var messages : Variable<[String: messageStruct]> = Variable([:])
    
    static var sharedUser: Variable<User?> = Variable<User?>(nil)
    static var sharedParkings: Variable<[String: ParkingArea]> = Variable([:])
    static var bookedSlots = Variable<[String:[Int]]>([:])
    static var userSlots = Variable<[String:UserRequestStruct]>([:])
    static var sharedAllUsers = Variable<[User]>([])
    static var sharedAllUsersMessages = Variable<[String:String]>([:])
    
    init(email: String, name: String, contactNo: String, password: String) {
        self.email = email
        self.name = name
        self.contactNo = contactNo
        self.password = password
    }
    
    // Mappable
    func mapping(map: Map) {
        self.email           <- map["email"]
        self.name            <- map["name"]
        self.contactNo       <- map["contactNo"]
        self.userType        <- (map["userType"], transformIntoUserType)
        self.password        <- map["password"]
    }
    
    required init(map: Map) {
        
    }

}

