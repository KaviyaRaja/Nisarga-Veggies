//
//  MyOrderTableViewCell.swift
//  ECommerce
//
//  Created by Apple on 24/06/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class MyOrderTableViewCell: UITableViewCell {

    @IBOutlet weak var OrderNumberlabel: CustomFontLabel!
    @IBOutlet weak var OrderDatelabel: CustomFontLabel!
    @IBOutlet weak var OrderStatuslabel: CustomFontLabel!
    @IBOutlet weak var mBgView : UIView!
    @IBOutlet weak var mCancelBtn : CustomFontButton!
    @IBOutlet weak var mDetailsBtn : CustomFontButton!
    @IBOutlet weak var mReorderBtn : CustomFontButton!
     @IBOutlet weak var mPayNowBtn : CustomFontButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
