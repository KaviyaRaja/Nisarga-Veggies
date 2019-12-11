//
//  PaymentHistoryCell.swift
//  Nisagra
//
//  Created by Apple on 26/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class PaymentHistoryCell: UITableViewCell {

    @IBOutlet weak var moneySpentImageView: UIImageView!
    
    @IBOutlet weak var StatusLabel: CustomFontLabel!
    
    @IBOutlet weak var statusDispalyLabel: CustomFontLabel!
    
    @IBOutlet weak var MoneySpentLabel: CustomFontLabel!
    
    @IBOutlet weak var TxnIDLabel: CustomFontLabel!
    @IBOutlet weak var mAmountLabel: CustomFontLabel!
    @IBOutlet weak var mDateLabel: CustomFontLabel!
    
    @IBOutlet weak var debitLabel: CustomFontLabel!
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
