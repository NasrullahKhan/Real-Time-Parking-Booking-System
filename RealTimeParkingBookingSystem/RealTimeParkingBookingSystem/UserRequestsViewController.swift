//
//  UserRequestsViewController.swift
//  RealTimeParkingBookingSystem
//
//  Created by Nasrullah Khan on 28/01/2017.
//  Copyright © 2017 Nasrullah Khan. All rights reserved.
//

import UIKit
import RxSwift
import Firebase

class UserRequestsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var userSlots = [String: UserRequestStruct]()
    var selectedUSer:User?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let u = selectedUSer{
            User.userSlots.value = [:]
            _ = User.sharedParkings.asObservable().subscribe { (parkingDict) in
                if User.sharedParkings.value.count == 3 {
                    
                    for parkingArea in User.sharedParkings.value{
                        
                        for slot in parkingArea.value.slots! {
                            
                            UserServices.getUserSlots(uID: u.uID!, pID: parkingArea.key, sID: slot.slotID!, completion: { (error) in
                                
                                if error != nil {
                                    
                                    
                                }else {
                                    
                                }
                                
                            })
                        }
                    }
                }
            }
        }else{
            _ = User.sharedParkings.asObservable().subscribe { (parkingDict) in
                if User.sharedParkings.value.count == 3 {
                    
                    for parkingArea in User.sharedParkings.value{
                        
                        for slot in parkingArea.value.slots! {
                            
                            UserServices.getUserSlots(uID: User.sharedUser.value!.uID!, pID: parkingArea.key, sID: slot.slotID!, completion: { (error) in
                                
                                if error != nil {
                                    
                                    
                                }else {
                                    
                                }
                                
                            })
                        }
                    }
                }
            }
        }
        
        _ = User.userSlots.asObservable()
            .subscribe({ (slots) in
                
                self.userSlots = User.userSlots.value
                self.tableView.reloadData()
            })
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userSlots.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "userRequestCellIdentifier", for: indexPath) as! UserRequestsCell

        let userRequestObj = Array(self.userSlots.values)[indexPath.row]
        
        let parkingObj = User.sharedParkings.value[userRequestObj.pID]!
        var slotObj : Slot?
        for slot in parkingObj.slots! {
            if slot.slotID == userRequestObj.slotID {
                slotObj = slot
                break
            }
        }
        
        cell.parkingName.text = parkingObj.areaName!
        cell.slotNo.text = slotObj!.slotNo
        
        cell.startTime.text = "\(userRequestObj.start)"
        cell.totalHours.text = "\(userRequestObj.hours)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.view.showHud()
        
        let alertController = UIAlertController(title: "Alert", message:
            "Do you really want to remove this slot", preferredStyle: UIAlertControllerStyle.alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) -> Void in
            
            let userRequestObj = Array(self.userSlots.values)[indexPath.row]
            if let u = self.selectedUSer {
                UserServices.removeUserSlots(uID: u.uID!, userRequest: userRequestObj) { (error) in
                    if error != nil {
                        self.showAlert(title: "ERROR", msg: error!)
                    }else {
                        self.showAlert(title: "Message", msg: "Slot Removed Successfully")
                    }
                }
            }else{
                UserServices.removeUserSlots(uID: User.sharedUser.value!.uID!, userRequest: userRequestObj) { (error) in
                    if error != nil {
                        self.showAlert(title: "ERROR", msg: error!)
                    }else {
                        self.showAlert(title: "Message", msg: "Slot Removed Successfully")
                    }
                }
            }
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { (action) -> Void in
            return
        }))
        
        self.present(alertController, animated: true, completion: nil)
        self.view.hideHud()
    }

}
