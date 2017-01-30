//
//  SlotCell.swift
//  RealTimeParkingBookingSystem
//
//  Created by Nasrullah Khan on 27/01/2017.
//  Copyright © 2017 Nasrullah Khan. All rights reserved.
//

import UIKit

class SlotCell: UITableViewCell  {

    @IBOutlet weak var slotNo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
