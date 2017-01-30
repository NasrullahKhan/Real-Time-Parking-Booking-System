//
//  AllUserController.swift
//  RealTimeParkingBookingSystem
//
//  Created by Nasrullah Khan on 28/01/2017.
//  Copyright © 2017 Nasrullah Khan. All rights reserved.
//

import UIKit

class AllUserController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        User.sharedAllUsers.asObservable().subscribe { (user) in
            self.tableView.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return User.sharedAllUsers.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "allUserCellIdentifier", for: indexPath) as! AllUserCell
        cell.userName.text = User.sharedAllUsers.value[indexPath.row].name!
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = User.sharedAllUsers.value[indexPath.row]
        performSegue(withIdentifier: "userRequestedController", sender: user)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! UserRequestsViewController
        dest.selectedUSer = sender as? User
    }


}
