//
//  wishlistCell.swift
//  ECommerce
//
//  Created by Apple on 19/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class WishListCell: UITableViewCell {

    @IBOutlet weak var wishattributeLabel: UILabel!
    @IBOutlet weak var wishlistImage: UIImageView!
    @IBOutlet weak var wishProductLabel: UILabel!
    @IBOutlet weak var wishPriceLable: UILabel!
    @IBOutlet weak var wishkgLabel: UILabel!
    @IBOutlet weak var cartImage: UIImageView!
    @IBOutlet weak var deleteImage: UIImageView!
    @IBOutlet weak var moveCartBtn : UIButton!
    @IBOutlet weak var removeBtn : UIButton!
    @IBOutlet weak var mBgView : UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
