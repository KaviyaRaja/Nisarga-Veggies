//
//  LeftViewCell.swift
//  LGSideMenuControllerDemo
//

class LeftViewCell: UITableViewCell {

    @IBOutlet var separatorView: UIView!
    
    @IBOutlet weak var mTitleLabel: UILabel!
    @IBOutlet weak var mImageView : UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = .clear
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        //titleLabel.alpha = highlighted ? 0.5 : 1.0
    }

}
