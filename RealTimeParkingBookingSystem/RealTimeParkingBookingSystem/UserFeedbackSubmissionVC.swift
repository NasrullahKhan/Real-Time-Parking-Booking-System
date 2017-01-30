//
//  UserFeedbackSubmissionVC.swift
//  RealTimeParkingBookingSystem
//
//  Created by Nasrullah Khan on 28/01/2017.
//  Copyright © 2017 Nasrullah Khan. All rights reserved.
//

import UIKit

class UserFeedbackSubmissionVC: UIViewController {

    @IBOutlet weak var feedback: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func send(_ sender: Any) {
        
        self.view.showHud()
        UserServices.sendFeedback(uID: User.sharedUser.value!.uID!, mes: self.feedback.text!) { (error) in
            self.view.hideHud()
            if error == nil{
                self.showAlert(title: "Message", msg: "Feedback Sent!")
            }else{
                self.showAlert(title: "ERROR", msg: error!)
            }
        }
        
    }

}
