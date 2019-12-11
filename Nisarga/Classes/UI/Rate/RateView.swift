//
//  RateView.swift
//  Nisarga
//
//  Created by Hari Krish on 05/08/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import Foundation
class RateView: UIView
{
    @IBOutlet var contentView: UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    private func commonInit()
    {
        Bundle.main.loadNibNamed("RateView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
    }
}
