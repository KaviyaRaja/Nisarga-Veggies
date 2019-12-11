//
//  ProductMenuTableViewCell.swift
//  ECommerce
//
//  Created by Apple on 24/06/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class ProductMenuTableViewCell: UITableViewCell {

    @IBOutlet weak var producticonimageview: UIView!
    
    @IBOutlet weak var profilemenulabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
