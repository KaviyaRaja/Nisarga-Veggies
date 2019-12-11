//
//  HomeCell.swift
//  Nisagra
//
//  Created by Hari Krish on 29/07/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import UIKit
extension UIView {
    func roundCorners(_ corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}
class HomeCell: UICollectionViewCell {
    
    @IBOutlet weak var mImageView : UIImageView!
    @IBOutlet weak var mGramTF: IQDropDownTextField!
    @IBOutlet weak var mCartBtn : UIButton!
    @IBOutlet weak var mPlusBtn: UIButton!
    @IBOutlet weak var mMinusBtn: UIButton!
    @IBOutlet weak var mCartCountLabel : UILabel!
    @IBOutlet weak var mTitleLabel : UILabel!
    @IBOutlet weak var mPriceLabel : UILabel!
    @IBOutlet weak var mDicountLabel : UILabel!
    @IBOutlet weak var mAddView : UIView!
    @IBOutlet weak var mBGView : UIView!
    @IBOutlet weak var mArrowImageView : UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.mCartBtn.roundCorners([.bottomLeft, .bottomRight], radius: 5)
        self.mAddView.roundCorners([.bottomLeft, .bottomRight], radius: 5)
    }

}
