//
//  Auth.swift
//  CampusRecruitmentSystem
//
//  Created by Nasrullah Khan on 25/01/2017.
//  Copyright © 2017 Nasrullah Khan. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class Auth {
    
    static func createUser(user: User, completion : @escaping (_ errorDesc : String?) -> Void) {
        
        FIRAuth.auth()?.createUser(withEmail: user.email!, password: user.password!, completion: { (FIR_USER, ERROR) in
            
            guard let _ = FIR_USER else {
                completion(ERROR!.localizedDescription)
                return
            }
            
            let userEntry: [String: Any] = ["email": user.email!, "name": user.name!, "contactNo": user.contactNo!, "userType": 0]
            
            cRef.child("users/\(FIR_USER!.uid)").setValue(userEntry, withCompletionBlock: { (error, reference) in
                if error != nil {
                    completion(error!.localizedDescription)
                }else {
                    completion(nil)
                }
            })
        })
    }
    
    
    static func login(email: String, password: String, completion : @escaping (_ user: User? ,_ errorDesc : String?) -> Void) {
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            
            guard let _ = user else {
                completion(nil, error!.localizedDescription)
                return
            }
            
            cRef.child("users/\(user!.uid)").observeSingleEvent(of: .value, with: { (snapshot) in
                
                let data = snapshot.value as! [String:Any]
                let userObj = User(JSON: data)
                userObj!.uID = user!.uid
                
                User.sharedUser.value = userObj!
                
                switch userObj!.userType! {
                case .user:
                    completion(userObj, nil)
                case .admin:
                    completion(userObj, nil)
                }
            })
        })
    }
}
