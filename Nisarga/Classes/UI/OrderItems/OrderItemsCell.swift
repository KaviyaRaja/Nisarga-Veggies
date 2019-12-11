//
//  OrderItemsCell.swift
//  ECommerce
//
//  Created by Apple on 23/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class OrderItemsCell: UITableViewCell {

    @IBOutlet weak var orderitemsImage: UIImageView!
    @IBOutlet weak var orderItemsName: UILabel!
    @IBOutlet weak var orderitemsKg: UILabel!
    @IBOutlet weak var orderitemsAttribute: UILabel!
    @IBOutlet weak var orderitemsPrice: UILabel!
    @IBOutlet weak var orderItemsQuantity: UILabel!
    @IBOutlet weak var orderItemsRevisedPrice: UILabel!
    @IBOutlet weak var mBgView : UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
