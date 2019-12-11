//
//  ProductListCell.swift
//  ECommerce
//
//  Created by Apple on 19/06/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
class ProductListCell: UICollectionViewCell {

    @IBOutlet weak var productlistView: UIView!
    @IBOutlet weak var productListImage: UIImageView!
    @IBOutlet weak var wishListImage: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productCostLabel: UILabel!
    @IBOutlet weak var attributeLabel: UILabel!
    @IBOutlet weak var  mCartBtn : UIButton!
    @IBOutlet weak var  mWishListBtn : UIButton!
    @IBOutlet weak var mCartView : UIView!
    @IBOutlet weak var mPlusBtn: UIButton!
    @IBOutlet weak var mMinusBtn: UIButton!
    @IBOutlet weak var mCartCountLabel : UILabel!
    @IBOutlet weak var mGramTF: IQDropDownTextField!
    @IBOutlet weak var mArrowImageView : UIImageView!
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
        self.mCartBtn.roundCorners([.bottomLeft, .bottomRight], radius: 5)
        self.mCartView.roundCorners([.bottomLeft, .bottomRight], radius: 5)
    }
    
}


