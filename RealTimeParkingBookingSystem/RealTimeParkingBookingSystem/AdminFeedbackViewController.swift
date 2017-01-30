//
//  AdminFeedbackViewController.swift
//  RealTimeParkingBookingSystem
//
//  Created by Nasrullah Khan on 28/01/2017.
//  Copyright © 2017 Nasrullah Khan. All rights reserved.
//

import UIKit
import RxSwift

class AdminFeedbackViewController: UIViewController,UITableViewDelegate , UITableViewDataSource {

    @IBOutlet weak var table: UITableView!
    
    var messages = [String: messageStruct]()
    override func viewDidLoad() {
        super.viewDidLoad()

        User.sharedAllUsers.asObservable().subscribe { (user) in
            for u in user.element!{
                u.messages.asObservable().subscribe({ (mes) in
                    for message in mes.element!.values {
                        self.messages[message.mID] = message
                    }
                    self.table.reloadData()
                })
                
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = table.dequeueReusableCell(withIdentifier: "feedbackCell") as! AdminFeedbackTableViewCell
        let messageObj = Array(self.messages.values)[indexPath.row]
        
        for user in User.sharedAllUsers.value {
            if user.uID == messageObj.uID {
                cell.userName.text = user.name
                break
            }
        }
        
        cell.message.text =  messageObj.message
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    

}
