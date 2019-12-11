//
//  OrderDetailsCell.swift
//  Nisagra
//
//  Created by Apple on 24/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class OrderDetailsCell: UITableViewCell {

    @IBOutlet weak var OrderDetailsImage: UIImageView!
    @IBOutlet weak var detailsname: UILabel!
    @IBOutlet weak var Orderdetailkg: UILabel!
    @IBOutlet weak var orderattributePrice: UILabel!
    @IBOutlet weak var orderdetailsPrice: UILabel!
    @IBOutlet weak var orderDetailsQuantiy: UILabel!
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
