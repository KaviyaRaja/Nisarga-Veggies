//
//  CheckOutItemsCell.swift
//  ECommerce
//
//  Created by Apple on 23/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class CheckOutItemsCell: UITableViewCell {

    @IBOutlet weak var productsName: UILabel!
    @IBOutlet weak var productskglabel: UILabel!
    @IBOutlet weak var productsQuantityLabel: UILabel!
    @IBOutlet weak var productsPriceLabel: UILabel!
    @IBOutlet weak var updatedpricelabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
