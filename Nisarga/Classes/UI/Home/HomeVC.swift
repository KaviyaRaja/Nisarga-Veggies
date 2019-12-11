//
//  HomeVC.swift
//  ECommerce
//
//  Created by Apple on 19/06/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import SKActivityIndicatorView

extension String {
    var isInteger: Bool { return Int(self) != nil }
    var isFloat: Bool { return Float(self) != nil }
    var isDouble: Bool { return Double(self) != nil }
}

class HomeVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,IQDropDownTextFieldDelegate,UITableViewDataSource,UITableViewDelegate  {
    
    @IBOutlet weak var bannerCollectionView: UICollectionView!
    @IBOutlet weak var mDealsCollectionView: UICollectionView!
    @IBOutlet weak var mProductsCollectionView: UICollectionView!
    @IBOutlet weak var mRecommendedCollectionView: UICollectionView!
    @IBOutlet weak var mDealsView: UIView!
    @IBOutlet weak var ProductsView: UIView!
    @IBOutlet weak var mRecommendedView: UIView!
    @IBOutlet weak var profileImage : UIImageView!
    @IBOutlet weak var contentHeight: NSLayoutConstraint!
    @IBOutlet weak var mPageCtrl : UIPageControl!
    @IBOutlet var mRateView: UIView!
    @IBOutlet var mRateLikeView: UIView!
    @IBOutlet var mRateUnLikeView: UIView!
    @IBOutlet weak var mRateLikeImage : UIImageView!
    @IBOutlet weak var mRateUnLikeImage : UIImageView!
    @IBOutlet weak var mRateLikeBtn : UIButton!
    @IBOutlet weak var mRateUnLikeBtn : UIButton!
    @IBOutlet weak var mCartCountLabel : CustomFontLabel!
    @IBOutlet weak var mlayout1TableView : UITableView!
    @IBOutlet weak var mlayout1CollectionView: UICollectionView!
    @IBOutlet weak var mlayoutHeaderLabel : CustomFontLabel!
    @IBOutlet weak var layoutHeight: NSLayoutConstraint!
    @IBOutlet weak var layout2Height: NSLayoutConstraint!
     @IBOutlet var moffer2View: UIView!
    @IBOutlet var mOfferLabelView: UIView!
    @IBOutlet var mOffer1View: UIView!
    
    var slideCount : Int?
    var bannerArray : NSArray = []
    var productsArray : NSArray = []
    var dealsArray : NSArray = []
    var recommendedArray : NSArray = []
    var mProductID : String!
    var layout1Array : NSArray = []
    var layout2Array : NSArray = []
    var collectionType : NSString = ""
    override func viewDidLoad()
    {
        // Do any additional setup after loading the view.
        super.viewDidLoad()
        self.bannerCollectionView.register(UINib(nibName: "SliderCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SliderCollectionViewCell")
        self.mProductsCollectionView.register(UINib(nibName: "HomeCell", bundle: nil), forCellWithReuseIdentifier: "HomeCell")
        self.mDealsCollectionView.register(UINib(nibName: "HomeCell", bundle: nil), forCellWithReuseIdentifier: "HomeCell")
        self.mRecommendedCollectionView.register(UINib(nibName: "HomeCell", bundle: nil), forCellWithReuseIdentifier: "HomeCell")
        self.mlayout1TableView.register(UINib(nibName: "layout1TableViewCell", bundle: .main), forCellReuseIdentifier: "layout1TableViewCell")
        self.mlayout1CollectionView.register(UINib(nibName: "layout2CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "layout2CollectionViewCell")
        self.contentHeight.constant = 780
        
        
        
        self.mCartCountLabel.layer.cornerRadius = self.mCartCountLabel.frame.size.width/2
        self.mCartCountLabel.layer.masksToBounds = true
        
        let myColor = UIColor.lightGray
        
//        self.mOffer1View.layer.shadowColor = UIColor.lightGray.cgColor
//        self.mOffer1View.layer.shadowOffset = CGSize(width: 1, height:3)
//        self.mOffer1View.layer.shadowOpacity = 0.6
//        self.mOffer1View.layer.shadowRadius = 3.0
//        self.mOffer1View.layer.cornerRadius = 5.0
//        mOffer1View.layer.borderColor = UIColor.lightGray.cgColor
//        mOffer1View.layer.borderWidth = 1.0
        
        
        mOfferLabelView.layer.borderColor = myColor.cgColor
        mOfferLabelView.layer.borderWidth = 1.0
        
        
        self.moffer2View.layer.shadowColor = UIColor.lightGray.cgColor
        self.moffer2View.layer.shadowOffset = CGSize(width: 1, height:3)
        self.moffer2View.layer.shadowOpacity = 0.6
        self.moffer2View.layer.shadowRadius = 3.0
        self.moffer2View.layer.cornerRadius = 5.0
        self.moffer2View.layer.borderColor = UIColor.lightGray.cgColor
        self.moffer2View.layer.borderWidth = 1.0
        
//        self.mlayout1TableView.layer.shadowColor = UIColor.lightGray.cgColor
//        self.mlayout1TableView.layer.shadowOffset = CGSize(width: 1, height:3)
//        self.mlayout1TableView.layer.shadowOpacity = 0.6
//        self.mlayout1TableView.layer.shadowRadius = 3.0
//        self.mlayout1TableView.layer.cornerRadius = 5.0
      
        

       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let profileTapped =  UserDefaults.standard.string(forKey: "isProfileTapped")
        if(profileTapped == "1")
        {
            UserDefaults.standard.setValue("0", forKey: "isProfileTapped")
        }
        else
        {
            getData()
            getCartCount()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.showRateView), name: NSNotification.Name("ShowRate"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.RefreshPic), name: NSNotification.Name("RefreshPic"), object: nil)
        
        var image = UserDefaults.standard.string(forKey: "ProfilePic")
        if(image != nil){
            if(image == "0")
            {
                image = "http://3.213.33.73/Ecommerce/upload/image/backend/profile.png"
            }
            else
            {
                image = image?.replacingOccurrences(of: " ", with: "%20")
            }
            self.profileImage.sd_setImage(with: URL(string: image!), placeholderImage: UIImage(named: "Rectangle"))
            self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width/2
            self.profileImage.layer.masksToBounds = true
        }
        
    }
    @objc func RefreshPic()
    {
        var image = UserDefaults.standard.string(forKey: "ProfilePic")
        if(image != nil){
            if(image == "0")
            {
                image = "http://3.213.33.73/Ecommerce/upload/image/backend/profile.png"
            }
            else
            {
                image = image?.replacingOccurrences(of: " ", with: "%20")
            }
            self.profileImage.sd_setImage(with: URL(string: image!), placeholderImage: UIImage(named: "Rectangle"))
            self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width/2
            self.profileImage.layer.masksToBounds = true
        }
    }
    @objc func showRateView()
    {
        self.mRateView.frame = self.view.frame
        self.view.addSubview(self.mRateView)
        
        self.mRateLikeView.layer.shadowColor = UIColor.darkGray.cgColor
        self.mRateLikeView.layer.shadowOffset = CGSize(width: 1, height:3)
        self.mRateLikeView.layer.shadowOpacity = 0.6
        self.mRateLikeView.layer.shadowRadius = 3.0
        self.mRateLikeView.layer.cornerRadius = 5.0
        self.mRateLikeBtn.isSelected = false
        
        self.mRateUnLikeView.layer.shadowColor = UIColor.darkGray.cgColor
        self.mRateUnLikeView.layer.shadowOffset = CGSize(width: 1, height:3)
        self.mRateUnLikeView.layer.shadowOpacity = 0.6
        self.mRateUnLikeView.layer.shadowRadius = 3.0
        self.mRateUnLikeView.layer.cornerRadius = 5.0
        self.mRateUnLikeBtn.isSelected = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Button Actions
    
    @IBAction func myCart(_ sender: UIButton)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MyCartVC") as! MyCartVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func searchBtnAction(_ sender: UIButton)
    {
        UserDefaults.standard.setValue("HomeList", forKey: "SelectedTab")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func notificationBtnAction(_ sender: UIButton)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "NotificationVC") as? NotificationVC
        self.navigationController?.pushViewController(myVC!, animated: true)
    }

    @IBAction func viewAllBtnAction(_ sender: UIButton)
    {
        UserDefaults.standard.setValue("HomeList", forKey: "SelectedTab")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "ListVC") as? ListVC
        if(sender.tag == 1)
        {
            myVC?.typeID = "2"
        }
        else if(sender.tag == 2)
        {
            myVC?.typeID = "1"
        }
        else if(sender.tag == 3)
        {
            myVC?.typeID = "3"
        }
        self.navigationController?.pushViewController(myVC!, animated: true)
    }
    @IBAction func removeBtnAction(_ sender: Any)
    {
        self.mRateView.removeFromSuperview()
    }
    @IBAction func rateLikeBtnAction(_ sender: Any)
    {
        if(self.mRateLikeBtn.isSelected)
        {
            self.mRateLikeBtn.isSelected = false
            self.mRateLikeImage.image = UIImage(named: "Ratelike")
            
        }
        else
        {
            self.mRateLikeBtn.isSelected = true
            self.mRateLikeImage.image = UIImage(named: "Ratelike(green)")
            self.mRateUnLikeBtn.isSelected = false
            self.mRateUnLikeImage.image = UIImage(named: "Rateunlike")
            
        }
    }
    @IBAction func rateUnLikeBtnAction(_ sender: Any)
    {
        if(self.mRateUnLikeBtn.isSelected)
        {
            self.mRateUnLikeBtn.isSelected = false
            self.mRateUnLikeImage.image = UIImage(named: "Rateunlike")
        }
        else
        {
            self.mRateUnLikeBtn.isSelected = true
            self.mRateUnLikeImage.image = UIImage(named: "Rateunlike(green)")
            self.mRateLikeBtn.isSelected = false
            self.mRateLikeImage.image = UIImage(named: "Ratelike")
            
        }
    }
    @IBAction func submitBtnAction(_ sender: Any)
    {
        if(self.mRateLikeBtn.isSelected == false && self.mRateUnLikeBtn.isSelected == false)
        {
            self.view.makeToast("Please choose your feeback")
            return
        }
        submitRate()
    }

    
    // MARK: - API
    
    func getData()
    {
        SKActivityIndicator.show("Loading...")
        let Url = String(format: "%@api/custom/homepage",Constants.BASEURL)
        print(Url)
        let userID =  UserDefaults.standard.string(forKey: "customer_id")
        let parameters: Parameters =
        [
            "customer_id" : userID ?? "",
            //"customer_id" : "1",
            "id" : "7"
        ]
        print(parameters)
        let headers: HTTPHeaders =
        [
            "Content-Type": "application/json"
        ]
        Alamofire.request(Url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                print(response)
                SKActivityIndicator.dismiss()
                switch(response.result) {
                
                case .success:
                    if let json = response.result.value
                    {
                        let JSON = json as! NSDictionary
                        print(JSON)
                        if(JSON["status"] as? String == "success")
                        {
                        self.bannerArray = (JSON["banner"] as? NSArray)!
                        self.bannerCollectionView.reloadData()
                        self.dealsArray = (JSON["dealoftheday"] as? NSArray)!
                        self.mDealsCollectionView.reloadData()
                        self.productsArray = (JSON["products"] as? NSArray)!
                        self.mProductsCollectionView.reloadData()
                        self.recommendedArray = (JSON["recommended"] as? NSArray)!
                        self.mRecommendedCollectionView.reloadData()
                        self.mPageCtrl.numberOfPages = self.bannerArray.count
                            
                        self.layout1Array = (JSON["layout1"] as? NSArray)!
                        self.mlayout1TableView.reloadData()
                        self.layout2Array = (JSON["layout2"] as? NSArray)!
                        self.mlayout1CollectionView.reloadData()
                        self.layoutHeight.constant = CGFloat(self.layout1Array.count * 100)
                            self.layout2Height.constant = CGFloat(self.layout2Array.count/2 * 140 + 35)
                        self.mlayoutHeaderLabel.text = JSON["layout2_title"] as? String
                            self.contentHeight.constant = 780  +  self.layoutHeight.constant + self.layout2Height.constant
                        }
                        else
                        {
                               //self.view.makeToast(JSON["message"] as? String)
                        }
                    }
                    break
                    
                case .failure(let error):
                    print(error)
                    break
                    
                }
        }
        
    }
    func submitRate()
    {
        var rateVlaue = ""
        if(self.mRateLikeBtn.isSelected)
        {
            rateVlaue = "1"
        }
        else{
            rateVlaue = "0"
        }
        SKActivityIndicator.show("Loading...")
        let Url = String(format: "%@api/rateus/giveRateUs",Constants.BASEURL)
        print(Url)
        let userID =  UserDefaults.standard.string(forKey: "customer_id")
        let parameters: Parameters =
        [
            "customer_id" : userID ?? "",
            "rate" : rateVlaue
        ]
        print(parameters)
        let headers: HTTPHeaders =
        [
            "Content-Type": "application/json"
        ]
        Alamofire.request(Url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                print(response)
                SKActivityIndicator.dismiss()
                switch(response.result) {
                    
                case .success:
                    if let json = response.result.value
                    {
                        let JSON = json as! NSDictionary
                        print(JSON)
                        if(JSON["status"] as? String == "success")
                        {
                            self.view.makeToast("Thanks for your Valuable Feedback!")
                            self.mRateView.removeFromSuperview()
                        }
                        else
                        {
                            self.view.makeToast(JSON["message"] as? String)
                        }
                    }
                    break
                    
                case .failure(let error):
                    print(error)
                    break
                    
                }
        }
        
    }
    func getCartCount()
    {
        let Url = String(format: "%@api/cart/cartcount&api_token=%@",Constants.BASEURL,UserDefaults.standard.string(forKey: "api_token")!)
        print(Url)
        let headers: HTTPHeaders =
        [
            "Content-Type": "application/json"
        ]
        Alamofire.request(Url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                print(response)
                SKActivityIndicator.dismiss()
                switch(response.result) {
                    
                case .success:
                    if let json = response.result.value
                    {
                        let JSON = json as! NSDictionary
                        print(JSON)
                        if(JSON["status"] as? String == "success")
                        {
                            self.mCartCountLabel.text = JSON["data"] as? String
                            if(self.mCartCountLabel.text == "0")
                            {
                                self.mCartCountLabel.isHidden = true
                            }
                            else
                            {
                                self.mCartCountLabel.isHidden = false
                            }
                        }
                        else
                        {
                            //self.view.makeToast(JSON["message"] as? String)
                        }
                    }
                    break
                    
                case .failure(let error):
                    print(error)
                    break
                    
                }
        }
        
    }
    
    // MARK: - CollectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if(collectionView == self.bannerCollectionView)
        {
            return self.bannerArray.count
        }
        else if(collectionView == self.mDealsCollectionView)
        {
            return self.dealsArray.count
        }
        else if(collectionView == self.mProductsCollectionView)
        {
            return self.productsArray.count
        }
        else if(collectionView == self.mRecommendedCollectionView)
        {
            return self.recommendedArray.count
        }
        else if(collectionView == self.mlayout1CollectionView)
        {
            return self.layout2Array.count
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        var defaultCell : UICollectionViewCell!
        if(collectionView == self.bannerCollectionView)
        {
            let cell: SliderCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SliderCollectionViewCell", for: indexPath) as! SliderCollectionViewCell
            let dict = self.bannerArray[indexPath.row] as? NSDictionary
            var image = dict!["image"] as? String
            if(image != nil){
                image = image?.replacingOccurrences(of: " ", with: "%20")
                cell.imageView.sd_setImage(with: URL(string: image!), placeholderImage: UIImage(named: "placeholder"))
            }
            return cell
        }
        else if(collectionView == self.mlayout1CollectionView)
        {
            let cell: layout2CollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "layout2CollectionViewCell", for: indexPath) as! layout2CollectionViewCell
            
            cell.mlayout2View .layer.shadowColor = UIColor.darkGray.cgColor
            cell.mlayout2View.layer.shadowOffset = CGSize(width: 1, height:3)
            cell.mlayout2View.layer.shadowOpacity = 0.6
            cell.mlayout2View.layer.shadowRadius = 1.0
            //cell.mlayout2View.layer.cornerRadius = 5.0
            if (indexPath.row % 3 == 0)
            {
                cell.mlayout2View.backgroundColor = UIColor.white
            }
            else
            {
                cell.mlayout2View.backgroundColor = UIColor.groupTableViewBackground
            }
            let dict = self.layout2Array[indexPath.row] as? NSDictionary
            cell.mlayout2Label.text = dict!["title"] as? String
            var image = dict!["image"] as? String
            if(image != nil){
                image = image?.replacingOccurrences(of: " ", with: "%20")
                cell.mlayout2ImageView.sd_setImage(with: URL(string: image!), placeholderImage: UIImage(named: "placeholder"))
            }
            return cell
        }
        else if(collectionView == self.mProductsCollectionView)
        {
            let cell: HomeCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCell", for: indexPath) as! HomeCell
            
            cell.mBGView.layer.shadowColor = UIColor.darkGray.cgColor
            cell.mBGView.layer.shadowOffset = CGSize(width: 1, height:3)
            cell.mBGView.layer.shadowOpacity = 0.6
            cell.mBGView.layer.shadowRadius = 3.0
            cell.mBGView.layer.cornerRadius = 5.0
            
            let dict = self.productsArray[indexPath.row] as? NSDictionary
            var image = dict!["image"] as? String
            if(image != nil){
                image = image?.replacingOccurrences(of: " ", with: "%20")
                cell.mImageView.sd_setImage(with: URL(string: image!), placeholderImage: UIImage(named: "category"))
            }
            cell.mTitleLabel.text = dict!["name"] as? String
            
            let priceSting = String(format : "%@",dict!["price"] as? String ?? "")
            let priceDouble =  Double (priceSting)
            if((priceDouble) != nil)
            {
                cell.mPriceLabel.text = String(format : "₹%.2f",priceDouble!)
            }
           // cell.mGramTF.text = String(format : "%@ Grams",dict!["quantity"] as? String ?? "")
            var discount = String(format : "%@",dict!["discount_price"] as? String ?? "")
            if(discount == "null")
            {
                
            }
            else
            {
                let discountSting = String(format : "%@",dict!["discount_price"] as? String ?? "")
                let discountDouble =  Double (discountSting)
                if((discountDouble) != nil)
                {
                    discount = String(format : "₹%.2f",discountDouble!)
                    let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: discount)
                    attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                    cell.mDicountLabel.attributedText = attributeString
                }
                
            }
            cell.mCartBtn.tag = indexPath.row
            cell.mCartBtn.addTarget(self, action:#selector(productsCartBtnAction(_:)), for: UIControlEvents.touchUpInside)
            cell.mPlusBtn.tag = indexPath.row
            cell.mPlusBtn.addTarget(self, action:#selector(productsPlusBtnAction(_:)), for: UIControlEvents.touchUpInside)
            cell.mMinusBtn.tag = indexPath.row
            cell.mMinusBtn.addTarget(self, action:#selector(productsMinusBtnAction(_:)), for: UIControlEvents.touchUpInside)
            if(dict!["Add_product_quantity_in_cart"] as? Int == 0 || dict!["Add_product_quantity_in_cart"] as? String == "0")
            {
                cell.mCartBtn.isHidden = false
                cell.mAddView.isHidden = true
            }
            else
            {
                cell.mCartBtn.isHidden = true
                cell.mAddView.isHidden = false
                cell.mCartCountLabel.text = String(format : "%@",(dict!["Add_product_quantity_in_cart"] as? String)!)
            }
            
            cell.mGramTF.delegate = self as? IQDropDownTextFieldDelegate
            cell.mGramTF.tag = indexPath.row + 200
            cell.mGramTF.itemList = ["1 Piece"]
            let weights = dict!["weight_classes"] as? AnyObject
            let options = dict!["options"] as? AnyObject
            if(weights as? String == "null" && options as? String == "null")
            {
                cell.mGramTF.selectedItem = "1 Piece"
                cell.mArrowImageView.isHidden = true
            }
            else{
                if(weights == nil || weights as? String == "null")
                {
                    if(options == nil || options as? String == "null")
                    {
                        cell.mGramTF.selectedItem = "1 Piece"
                        cell.mGramTF.isUserInteractionEnabled = false
                        cell.mArrowImageView.isHidden = true
                        
                        
                    }
                    else
                    {
                        var optArray = dict!["options"] as? NSArray
                        if((optArray?.count)! > 0)
                        {
                            var optionsArray = [String]()
                            for optionsDict in optArray! {
                                let size = (optionsDict as AnyObject).object(forKey: "name") as? String
                                optionsArray.append(size!)
                            }
                            print("weightArray=\(optionsArray)")
                            
                            cell.mGramTF.itemList = optionsArray
                            cell.mGramTF.selectedRow = 1
                            cell.mArrowImageView.isHidden = false
                            var optDict = optArray![0] as? NSDictionary
                            let priceSting = String(format : "%d",optDict!["price"] as? Int ?? "")
                            cell.mPriceLabel.text = String(format : "₹%@",priceSting)
                            let doubleSting = String(format : "%d",optDict!["discount_price"] as? Int ?? "")
                            let discount = String(format : "₹%@",doubleSting)
                            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: discount)
                            attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                            cell.mDicountLabel.attributedText = attributeString
                            if(optDict!["cart_count"] as? Int == 0 || optDict!["cart_count"] as? String == "0")
                            {
                                cell.mCartBtn.isHidden = false
                                cell.mAddView.isHidden = true
                            }
                            else
                            {
                                cell.mCartBtn.isHidden = true
                                cell.mAddView.isHidden = false
                                cell.mCartCountLabel.text = String(format : "%@",(optDict!["cart_count"] as? String)!)
                            }
                        }
                    }
                }
                else //if((weights?.count)! > 0)
                {
                    var weighArray = dict!["weight_classes"] as? NSArray
                    if((weighArray?.count)! > 0)
                    {
                        var weightsArray = [String]()
                        for weightsDict in weighArray! {
                            let size = (weightsDict as AnyObject).object(forKey: "name") as? String
                            weightsArray.append(size!)
                        }
                        print("weightArray=\(weightsArray)")
                        
                        cell.mGramTF.itemList = weightsArray
                        cell.mGramTF.selectedRow = 1
                        cell.mArrowImageView.isHidden = false
                        
                        var weighDict = weighArray![0] as? NSDictionary
                        let priceSting = String(format : "%d",weighDict!["price"] as? Int ?? "")
                        cell.mPriceLabel.text = String(format : "₹%@",priceSting)
                        let doubleSting = String(format : "%d",weighDict!["discount_price"] as? Int ?? "")
                        let discount = String(format : "₹%@",doubleSting)
                        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: discount)
                        attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                        cell.mDicountLabel.attributedText = attributeString
                        
                        if(weighDict!["cart_count"] as? Int == 0 || weighDict!["cart_count"] as? String == "0")
                        {
                            cell.mCartBtn.isHidden = false
                            cell.mAddView.isHidden = true
                        }
                        else
                        {
                            cell.mCartBtn.isHidden = true
                            cell.mAddView.isHidden = false
                            cell.mCartCountLabel.text = String(format : "%@",(weighDict!["cart_count"] as? String)!)
                        }
                    }
                }
            }
            return cell
        }
        else if(collectionView == self.mDealsCollectionView)
        {
            let cell: HomeCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCell", for: indexPath) as! HomeCell
            
            cell.mBGView.layer.shadowColor = UIColor.darkGray.cgColor
            cell.mBGView.layer.shadowOffset = CGSize(width: 1, height:3)
            cell.mBGView.layer.shadowOpacity = 0.6
            cell.mBGView.layer.shadowRadius = 3.0
            cell.mBGView.layer.cornerRadius = 5.0
            
            let dict = self.dealsArray[indexPath.row] as? NSDictionary
            var image = dict!["image"] as? String
            if(image != nil){
               image = image?.replacingOccurrences(of: " ", with: "%20")
                cell.mImageView.sd_setImage(with: URL(string: image!), placeholderImage: UIImage(named: "category"))
            }
            cell.mTitleLabel.text = dict!["name"] as? String
            let priceSting = String(format : "%@",dict!["price"] as? String ?? "")
            let priceDouble =  Double (priceSting)
            if((priceDouble) != nil)
            {
                cell.mPriceLabel.text = String(format : "₹%.2f",priceDouble!)
            }
            //cell.mGramTF.text = String(format : "%@ Grams",dict!["quantity"] as? String ?? "")
            var discount = String(format : "%@",dict!["discount_price"] as? String ?? "")
            if(discount == "null")
            {
                
            }
            else
            {
                let discountSting = String(format : "%@",dict!["discount_price"] as? String ?? "")
                let discountDouble =  Double (discountSting)
                if((discountDouble) != nil)
                {
                    discount = String(format : "₹%.2f",discountDouble!)
                    let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: discount)
                    attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                    cell.mDicountLabel.attributedText = attributeString
                    
                    
                }
                
            }
            if(dict!["Add_product_quantity_in_cart"] as? Int == 0 || dict!["Add_product_quantity_in_cart"] as? String == "0")
            {
                cell.mCartBtn.isHidden = false
                cell.mAddView.isHidden = true
            }
            else
            {
                cell.mCartBtn.isHidden = true
                cell.mAddView.isHidden = false
                cell.mCartCountLabel.text = String(format : "%@",(dict!["Add_product_quantity_in_cart"] as? String)!)
            }
            cell.mGramTF.delegate = self as? IQDropDownTextFieldDelegate
            cell.mGramTF.tag = indexPath.row + 100
            cell.mGramTF.itemList = ["1 Piece"]
            let weights = dict!["weight_classes"] as? AnyObject
            let options = dict!["options"] as? AnyObject
            if(weights as? String == "null" && options as? String == "null")
            {
                cell.mGramTF.selectedItem = "1 Piece"
                cell.mArrowImageView.isHidden = true
            }
            else{
                if(weights == nil || weights as? String == "null")
                {
                    if(options == nil || options as? String == "null")
                    {
                        cell.mGramTF.selectedItem = "1 Piece"
                        cell.mGramTF.isUserInteractionEnabled = false
                        cell.mArrowImageView.isHidden = true
                        
                        
                    }
                    else
                    {
                        var optArray = dict!["options"] as? NSArray
                        if((optArray?.count)! > 0)
                        {
                            var optionsArray = [String]()
                            for optionsDict in optArray! {
                                let size = (optionsDict as AnyObject).object(forKey: "name") as? String
                                optionsArray.append(size!)
                            }
                            print("weightArray=\(optionsArray)")
                            
                            cell.mGramTF.itemList = optionsArray
                            cell.mGramTF.selectedRow = 1
                            cell.mArrowImageView.isHidden = false
                            var optDict = optArray![0] as? NSDictionary
                            let priceSting = String(format : "%d",optDict!["price"] as? Int ?? "")
                            cell.mPriceLabel.text = String(format : "₹%@",priceSting)
                            let doubleSting = String(format : "%d",optDict!["discount_price"] as? Int ?? "")
                            let discount = String(format : "₹%@",doubleSting)
                            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: discount)
                            attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                            cell.mDicountLabel.attributedText = attributeString
                            if(optDict!["cart_count"] as? Int == 0 || optDict!["cart_count"] as? String == "0")
                            {
                                cell.mCartBtn.isHidden = false
                                cell.mAddView.isHidden = true
                            }
                            else
                            {
                                cell.mCartBtn.isHidden = true
                                cell.mAddView.isHidden = false
                                cell.mCartCountLabel.text = String(format : "%@",(optDict!["cart_count"] as? String)!)
                            }
                        }
                    }
                }
                else //if((weights?.count)! > 0)
                {
                    var weighArray = dict!["weight_classes"] as? NSArray
                    if((weighArray?.count)! > 0)
                    {
                        var weightsArray = [String]()
                        for weightsDict in weighArray! {
                            let size = (weightsDict as AnyObject).object(forKey: "name") as? String
                            weightsArray.append(size!)
                        }
                        print("weightArray=\(weightsArray)")
                        
                        cell.mGramTF.itemList = weightsArray
                        cell.mGramTF.selectedRow = 1
                        cell.mArrowImageView.isHidden = false
                        
                        var weighDict = weighArray![0] as? NSDictionary
                        let priceSting = String(format : "%d",weighDict!["price"] as? Int ?? "")
                        cell.mPriceLabel.text = String(format : "₹%@",priceSting)
                        let doubleSting = String(format : "%d",weighDict!["discount_price"] as? Int ?? "")
                        let discount = String(format : "₹%@",doubleSting)
                        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: discount)
                        attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                        cell.mDicountLabel.attributedText = attributeString
                        
                        if(weighDict!["cart_count"] as? Int == 0 || weighDict!["cart_count"] as? String == "0")
                        {
                            cell.mCartBtn.isHidden = false
                            cell.mAddView.isHidden = true
                        }
                        else
                        {
                            cell.mCartBtn.isHidden = true
                            cell.mAddView.isHidden = false
                            cell.mCartCountLabel.text = String(format : "%@",(weighDict!["cart_count"] as? String)!)
                        }
                    }
                }
            }
            cell.mCartBtn.tag = indexPath.row
            cell.mCartBtn.addTarget(self, action:#selector(cartBtnAction(_:)), for: UIControlEvents.touchUpInside)
            cell.mPlusBtn.tag = indexPath.row
            cell.mPlusBtn.addTarget(self, action:#selector(plusBtnAction(_:)), for: UIControlEvents.touchUpInside)
            cell.mMinusBtn.tag = indexPath.row
            cell.mMinusBtn.addTarget(self, action:#selector(minusBtnAction(_:)), for: UIControlEvents.touchUpInside)
            
            
            return cell
        }
        else if(collectionView == self.mRecommendedCollectionView)
        {
            let cell: HomeCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCell", for: indexPath) as! HomeCell
            
            cell.mBGView.layer.shadowColor = UIColor.darkGray.cgColor
            cell.mBGView.layer.shadowOffset = CGSize(width: 1, height:3)
            cell.mBGView.layer.shadowOpacity = 0.6
            cell.mBGView.layer.shadowRadius = 3.0
            cell.mBGView.layer.cornerRadius = 5.0
            
            let dict = self.recommendedArray[indexPath.row] as? NSDictionary
            var image = dict!["image"] as? String
            if(image != nil){
                image = image?.replacingOccurrences(of: " ", with: "%20")
                cell.mImageView.sd_setImage(with: URL(string: image!), placeholderImage: UIImage(named: "category"))
            }
            cell.mTitleLabel.text = dict!["name"] as? String
            let priceSting = String(format : "%@",dict!["price"] as? String ?? "")
            let priceDouble =  Double (priceSting)
            if((priceDouble) != nil)
            {
                cell.mPriceLabel.text = String(format : "₹%.2f",priceDouble!)
            }
           // cell.mGramTF.text = String(format : "%@ Grams",dict!["quantity"] as? String ?? "")
            var discount = String(format : "%@",dict!["discount_price"] as? String ?? "")
            if(discount == "null")
            {
                
            }
            else
            {
                let discountSting = String(format : "%@",dict!["discount_price"] as? String ?? "")
                let discountDouble =  Double (discountSting)
                if((discountDouble) != nil)
                {
                    discount = String(format : "₹%.2f",discountDouble!)
                    let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: discount)
                    attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                    cell.mDicountLabel.attributedText = attributeString
                }
            }
                cell.mCartBtn.tag = indexPath.row
                cell.mCartBtn.addTarget(self, action:#selector(recCartBtnAction(_:)), for: UIControlEvents.touchUpInside)
                cell.mPlusBtn.tag = indexPath.row
                cell.mPlusBtn.addTarget(self, action:#selector(recPlusBtnAction(_:)), for: UIControlEvents.touchUpInside)
                cell.mMinusBtn.tag = indexPath.row
                cell.mMinusBtn.addTarget(self, action:#selector(recMinusBtnAction(_:)), for: UIControlEvents.touchUpInside)
                if(dict!["Add_product_quantity_in_cart"] as? Int == 0 || dict!["Add_product_quantity_in_cart"] as? String == "0")
                {
                    cell.mCartBtn.isHidden = false
                    cell.mAddView.isHidden = true
                }
                else
                {
                    cell.mCartBtn.isHidden = true
                    cell.mAddView.isHidden = false
                    cell.mCartCountLabel.text = String(format : "%@",(dict!["Add_product_quantity_in_cart"] as? String)!)
                }
            cell.mGramTF.delegate = self as? IQDropDownTextFieldDelegate
            cell.mGramTF.tag = indexPath.row + 300
            cell.mGramTF.itemList = ["1 Piece"]
            let weights = dict!["weight_classes"] as? AnyObject
            let options = dict!["options"] as? AnyObject
            if(weights as? String == "null" && options as? String == "null")
            {
                cell.mGramTF.selectedItem = "1 Piece"
                cell.mArrowImageView.isHidden = true
            }
            else{
                if(weights == nil || weights as? String == "null")
                {
                    if(options == nil || options as? String == "null")
                    {
                        cell.mGramTF.selectedItem = "1 Piece"
                        cell.mGramTF.isUserInteractionEnabled = false
                        cell.mArrowImageView.isHidden = true
                        
                        
                    }
                    else
                    {
                        var optArray = dict!["options"] as? NSArray
                        if((optArray?.count)! > 0)
                        {
                            var optionsArray = [String]()
                            for optionsDict in optArray! {
                                let size = (optionsDict as AnyObject).object(forKey: "name") as? String
                                optionsArray.append(size!)
                            }
                            print("weightArray=\(optionsArray)")
                            
                            cell.mGramTF.itemList = optionsArray
                            cell.mGramTF.selectedRow = 1
                            cell.mArrowImageView.isHidden = false
                            var optDict = optArray![0] as? NSDictionary
                            let priceSting = String(format : "%d",optDict!["price"] as? Int ?? "")
                            cell.mPriceLabel.text = String(format : "₹%@",priceSting)
                            let doubleSting = String(format : "%d",optDict!["discount_price"] as? Int ?? "")
                            let discount = String(format : "₹%@",doubleSting)
                            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: discount)
                            attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                            cell.mDicountLabel.attributedText = attributeString
                        }
                    }
                }
                else //if((weights?.count)! > 0)
                {
                    var weighArray = dict!["weight_classes"] as? NSArray
                    if((weighArray?.count)! > 0)
                    {
                        var weightsArray = [String]()
                        for weightsDict in weighArray! {
                            let size = (weightsDict as AnyObject).object(forKey: "name") as? String
                            weightsArray.append(size!)
                        }
                        print("weightArray=\(weightsArray)")
                        
                        cell.mGramTF.itemList = weightsArray
                        cell.mGramTF.selectedRow = 1
                        cell.mArrowImageView.isHidden = false
                        
                        var weighDict = weighArray![0] as? NSDictionary
                        let priceSting = String(format : "%d",weighDict!["price"] as? Int ?? "")
                        cell.mPriceLabel.text = String(format : "₹%@",priceSting)
                        let doubleSting = String(format : "%d",weighDict!["discount_price"] as? Int ?? "")
                        let discount = String(format : "₹%@",doubleSting)
                        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: discount)
                        attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                        cell.mDicountLabel.attributedText = attributeString
                    }
                }
            }
            
            return cell
        }
        return defaultCell!
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if(collectionView == self.bannerCollectionView)
        {
            return CGSize(width: Constants.SCREEN_WIDTH, height: collectionView.bounds.size.height)
        }
        else if(collectionView == self.mProductsCollectionView || collectionView == self.mDealsCollectionView || collectionView == self.mRecommendedCollectionView)
        {
           return CGSize(width: 140, height: 150)
        }
        else if(collectionView == self.mlayout1CollectionView)
        {
             return CGSize(width: self.view.frame.size.width/2 - 10, height: 140)
        }
         return CGSize(width: 0, height: 0)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if(collectionView == self.bannerCollectionView)
        {
            return
        }
        if(collectionView == self.mDealsCollectionView)
        {
            let dict = self.dealsArray[indexPath.row] as? NSDictionary
            self.mProductID = dict![ "product_id"] as? String
        }
        else if(collectionView == self.mProductsCollectionView)
        {
            let dict = self.productsArray[indexPath.row] as? NSDictionary
            self.mProductID = dict!["product_id"] as? String
        }
        else if(collectionView == self.mRecommendedCollectionView)
        {
            let dict = self.recommendedArray[indexPath.row] as? NSDictionary
            self.mProductID = dict!["product_id"] as? String
        }
        else if(collectionView == self.mlayout1CollectionView)
        {
            UserDefaults.standard.setValue("HomeList", forKey: "SelectedTab")
            let dict = self.layout2Array[indexPath.row] as? NSDictionary
            let id = dict![ "id"] as? String
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let myVC = storyboard.instantiateViewController(withIdentifier: "ListVC") as? ListVC
            myVC?.typeID = id
            self.navigationController?.pushViewController(myVC!, animated: true)
            return
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "ProductDetailVC") as? ProductDetailVC
        myVC?.productID = self.mProductID! as NSString
        self.navigationController?.pushViewController(myVC!, animated: false)

    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        if(scrollView == self.bannerCollectionView)
        {
            for cell in self.bannerCollectionView.visibleCells  as! [SliderCollectionViewCell]    {
                let indexPath = self.bannerCollectionView.indexPath(for: cell as UICollectionViewCell)
                self.slideCount = (indexPath?.item)!
                self.mPageCtrl.currentPage = self.slideCount!
            }
        }
    }
    @objc func cartBtnAction(_ sender: UIButton)
    {
        let tag = sender.tag
        let dict = self.dealsArray[tag] as? NSDictionary
        let productID = dict!["product_id"] as! String
        let path = IndexPath(row: tag, section: 0)
        let cell = self.mDealsCollectionView.cellForItem(at: path) as! HomeCell?
        cell?.mAddView.isHidden = false
        cell?.mCartCountLabel.text = "1"
        let selectedRow = cell?.mGramTF.selectedRow
        var optionID : String!
        var optionValueID : String!
        var isOPtionsAvailable : Bool = false
        
        let weights = dict!["weight_classes"] as? AnyObject
        let options = dict!["options"] as? AnyObject
        if(weights as? String == "null" && options as? String == "null")
        {
        }
        else{
            if(weights == nil || weights as? String == "null")
            {
                if(options == nil || options as? String == "null")
                {
                }
                else
                {
                    var optArray = dict!["options"] as? NSArray
                    if((optArray?.count)! > 0)
                    {
                        var optDict = optArray![selectedRow!] as? NSDictionary
                        optionID = optDict!["product_option_id"] as? String
                        optionValueID = optDict!["product_option_value_id"] as? String
                        isOPtionsAvailable = true
                    }
                }
            }
            else //if((weights?.count)! > 0)
            {
                var weighArray = dict!["weight_classes"] as? NSArray
                if((weighArray?.count)! > 0)
                {
                    var weighDict = weighArray![selectedRow!] as? NSDictionary
                    optionID = weighDict!["product_option_id"] as? String
                    optionValueID = weighDict!["product_option_value_id"] as? String
                    isOPtionsAvailable = true
                }
            }
        }
        SKActivityIndicator.show("Loading...")
        let Url =  String(format: "%@api/cart/add&api_token=%@",Constants.BASEURL,UserDefaults.standard.string(forKey: "api_token")!)
        print(Url)
        let userID =  UserDefaults.standard.string(forKey: "customer_id")
        var parameters: Parameters = [:]
        if(isOPtionsAvailable)
        {
            parameters = [
                "customer_id" : userID ?? "",
                "product_id" : productID,
                "quantity" : "1",
                "product_option_id" : optionID ?? "",
                "product_option_value_id" : optionValueID ?? ""
            ]
        }
        else{
        parameters = [
           "customer_id" : userID ?? "",
            "product_id" : productID,
            "quantity" : "1",
        ]
        }
        
        print (parameters)
        let headers: HTTPHeaders =
        [
            "Content-Type": "application/json"
        ]
        Alamofire.request(Url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                print(response)
                SKActivityIndicator.dismiss()
                switch(response.result) {
                    
                case .success:
                    if let json = response.result.value
                    {
                        let JSON = json as! NSDictionary
                        print(JSON)
                        if(JSON["status"] as? String == "success")
                        {
                            self.view.makeToast(JSON["message"] as? String)
                            self.getCartCount()
                        }
                        else
                        {
                            self.view.makeToast(JSON["message"] as? String)
                        }
                    }
                    break
                    
                case .failure(let error):
                    print(error)
                    break
                    
                }
        }
    
    }
    @objc func plusBtnAction(_ sender: UIButton)
    {
        let tag = sender.tag
        let dict = self.dealsArray[tag] as? NSDictionary
        let productID = dict!["product_id"] as! String
        let path = IndexPath(row: tag, section: 0)
        let cell = self.mDealsCollectionView.cellForItem(at: path) as! HomeCell?
        cell?.mAddView.isHidden = false
        //cell?.mCartCountLabel.text = "1"
        let countStr = cell?.mCartCountLabel.text
        var count : Int = 0
        count = Int(countStr!)!
        count = count + 1
        cell?.mCartCountLabel.text = String(format:"%d",count)
        
        let selectedRow = cell?.mGramTF.selectedRow
        var optionID : String!
        var optionValueID : String!
        var isOPtionsAvailable : Bool = false
        
        let weights = dict!["weight_classes"] as? AnyObject
        let options = dict!["options"] as? AnyObject
        if(weights as? String == "null" && options as? String == "null")
        {
        }
        else{
            if(weights == nil || weights as? String == "null")
            {
                if(options == nil || options as? String == "null")
                {
                }
                else
                {
                    var optArray = dict!["options"] as? NSArray
                    if((optArray?.count)! > 0)
                    {
                        var optDict = optArray![selectedRow!] as? NSDictionary
                        optionID = optDict!["product_option_id"] as? String
                        optionValueID = optDict!["product_option_value_id"] as? String
                        isOPtionsAvailable = true
                    }
                }
            }
            else //if((weights?.count)! > 0)
            {
                var weighArray = dict!["weight_classes"] as? NSArray
                if((weighArray?.count)! > 0)
                {
                    var weighDict = weighArray![selectedRow!] as? NSDictionary
                    optionID = weighDict!["product_option_id"] as? String
                    optionValueID = weighDict!["product_option_value_id"] as? String
                    isOPtionsAvailable = true
                }
            }
        }
        
         SKActivityIndicator.show("Loading...")
         let Url =  String(format: "%@api/cart/edit_new&api_token=%@",Constants.BASEURL,UserDefaults.standard.string(forKey: "api_token")!)
         print(Url)
         let userID =  UserDefaults.standard.string(forKey: "customer_id")
         var parameters: Parameters = [:]
        if(isOPtionsAvailable)
        {
        parameters =
         [
         "customer_id" : userID ?? "",
         "product_id" : productID,
         "quantity" : count,
         "product_option_id" : optionID ?? "",
         "product_option_value_id" : optionValueID ?? ""
         ]
        }
        else{
            parameters =
            [ "customer_id" : userID ?? "",
            "product_id" : productID,
            "quantity" : count,
            ]
        }
         
         print (parameters)
         let headers: HTTPHeaders =
         [
         "Content-Type": "application/json"
         ]
         Alamofire.request(Url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
         .responseJSON { response in
         print(response)
         SKActivityIndicator.dismiss()
         switch(response.result) {
         
         case .success:
         if let json = response.result.value
         {
         let JSON = json as! NSDictionary
         print(JSON)
         if(JSON["status"] as? String == "success")
         {
         self.view.makeToast(JSON["message"] as? String)
         self.getCartCount()
         }
         else
         {
           // self.view.makeToast(JSON["message"] as? String)
            }
         }
         break
         
         case .failure(let error):
         print(error)
         break
         
         }
         }
        
    }
    @objc func minusBtnAction(_ sender: UIButton)
    {
        let tag = sender.tag
        let dict = self.dealsArray[tag] as? NSDictionary
        let productID = dict!["product_id"] as! String
        let path = IndexPath(row: tag, section: 0)
        let cell = self.mDealsCollectionView.cellForItem(at: path) as! HomeCell?
        cell?.mAddView.isHidden = false
        //cell?.mCartCountLabel.text = "1"
        let countStr = cell?.mCartCountLabel.text
        var count : Int = 0
        count = Int(countStr!)!
        count = count - 1
        if(count == 0)
        {
            cell?.mAddView.isHidden = true
            cell?.mCartBtn.isHidden = false
        }
        
        cell?.mCartCountLabel.text = String(format:"%d",count)
        let selectedRow = cell?.mGramTF.selectedRow
        var optionID : String!
        var optionValueID : String!
        var isOPtionsAvailable : Bool = false
        
        let weights = dict!["weight_classes"] as? AnyObject
        let options = dict!["options"] as? AnyObject
        if(weights as? String == "null" && options as? String == "null")
        {
        }
        else{
            if(weights == nil || weights as? String == "null")
            {
                if(options == nil || options as? String == "null")
                {
                }
                else
                {
                    var optArray = dict!["options"] as? NSArray
                    if((optArray?.count)! > 0)
                    {
                        var optDict = optArray![selectedRow!] as? NSDictionary
                        optionID = optDict!["product_option_id"] as? String
                        optionValueID = optDict!["product_option_value_id"] as? String
                        isOPtionsAvailable = true
                    }
                }
            }
            else //if((weights?.count)! > 0)
            {
                var weighArray = dict!["weight_classes"] as? NSArray
                if((weighArray?.count)! > 0)
                {
                    var weighDict = weighArray![selectedRow!] as? NSDictionary
                    optionID = weighDict!["product_option_id"] as? String
                    optionValueID = weighDict!["product_option_value_id"] as? String
                    isOPtionsAvailable = true
                }
            }
        }
        
         SKActivityIndicator.show("Loading...")
        var Url =  ""
        if(count == 0)
        {
            Url = String(format: "%@api/cart/edit_new&api_token=%@",Constants.BASEURL,UserDefaults.standard.string(forKey: "api_token")!)
        }
        else
        {
            Url = String(format: "%@api/cart/edit_new&api_token=%@",Constants.BASEURL,UserDefaults.standard.string(forKey: "api_token")!)
        }
         print(Url)
         let userID =  UserDefaults.standard.string(forKey: "customer_id")
        var parameters: Parameters = [:]
        if(isOPtionsAvailable)
        {
            parameters =
                [
                    "customer_id" : userID ?? "",
                    "product_id" : productID,
                    "quantity" : count,
                    "product_option_id" : optionID ?? "",
                    "product_option_value_id" : optionValueID ?? ""
            ]
        }
        else{
            parameters =
                [ "customer_id" : userID ?? "",
                  "product_id" : productID,
                  "quantity" : count,
            ]
        }
         
         print (parameters)
         let headers: HTTPHeaders =
         [
         "Content-Type": "application/json"
         ]
         Alamofire.request(Url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
         .responseJSON { response in
         print(response)
         SKActivityIndicator.dismiss()
         switch(response.result) {
         
         case .success:
         if let json = response.result.value
         {
         let JSON = json as! NSDictionary
         print(JSON)
         if(JSON["status"] as? String == "success")
         {
         self.view.makeToast(JSON["message"] as? String)
         self.getCartCount()
         }
         else
         {
           // self.view.makeToast(JSON["message"] as? String)
            }
         }
         break
         
         case .failure(let error):
         print(error)
         break
         
         }
         }
        
    }
    @objc func productsCartBtnAction(_ sender: UIButton)
    {
        let tag = sender.tag
        let dict = self.productsArray[tag] as? NSDictionary
        let productID = dict!["product_id"] as! String
        let path = IndexPath(row: tag, section: 0)
        let cell = self.mProductsCollectionView.cellForItem(at: path) as! HomeCell?
        cell?.mAddView.isHidden = false
        cell?.mCartCountLabel.text = "1"
        let selectedRow = cell?.mGramTF.selectedRow
        var optionID : String!
        var optionValueID : String!
        var isOPtionsAvailable : Bool = false
        
        let weights = dict!["weight_classes"] as? AnyObject
        let options = dict!["options"] as? AnyObject
        if(weights as? String == "null" && options as? String == "null")
        {
        }
        else{
            if(weights == nil || weights as? String == "null")
            {
                if(options == nil || options as? String == "null")
                {
                }
                else
                {
                    var optArray = dict!["options"] as? NSArray
                    if((optArray?.count)! > 0)
                    {
                        var optDict = optArray![selectedRow!] as? NSDictionary
                        optionID = optDict!["product_option_id"] as? String
                        optionValueID = optDict!["product_option_value_id"] as? String
                        isOPtionsAvailable = true
                    }
                }
            }
            else //if((weights?.count)! > 0)
            {
                var weighArray = dict!["weight_classes"] as? NSArray
                if((weighArray?.count)! > 0)
                {
                    var weighDict = weighArray![selectedRow!] as? NSDictionary
                    optionID = weighDict!["product_option_id"] as? String
                    optionValueID = weighDict!["product_option_value_id"] as? String
                    isOPtionsAvailable = true
                }
            }
        }
        
         SKActivityIndicator.show("Loading...")
         let Url =  String(format: "%@api/cart/add&api_token=%@",Constants.BASEURL,UserDefaults.standard.string(forKey: "api_token")!)
         print(Url)
         let userID =  UserDefaults.standard.string(forKey: "customer_id")
         var parameters: Parameters = [:]
        if(isOPtionsAvailable)
        {
            parameters = [
                "customer_id" : userID ?? "",
                "product_id" : productID,
                "quantity" : "1",
                "product_option_id" : optionID ?? "",
                "product_option_value_id" : optionValueID ?? ""
            ]
        }
        else{
            parameters = [
                "customer_id" : userID ?? "",
                "product_id" : productID,
                "quantity" : "1",
            ]
        }
         
         print (parameters)
         let headers: HTTPHeaders =
         [
         "Content-Type": "application/json"
         ]
         Alamofire.request(Url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
         .responseJSON { response in
         print(response)
         SKActivityIndicator.dismiss()
         switch(response.result) {
         
         case .success:
         if let json = response.result.value
         {
         let JSON = json as! NSDictionary
         print(JSON)
         if(JSON["status"] as? String == "success")
         {
            self.view.makeToast(JSON["message"] as? String)
            self.getCartCount()
         }
         else
         {
            //self.view.makeToast(JSON["message"] as? String)
            }
         }
         break
         
         case .failure(let error):
         print(error)
         break
         
         }
         }
        
    }
    @objc func productsPlusBtnAction(_ sender: UIButton)
    {
        let tag = sender.tag
        let dict = self.productsArray[tag] as? NSDictionary
        let productID = dict!["product_id"] as! String
        let path = IndexPath(row: tag, section: 0)
        let cell = self.mProductsCollectionView.cellForItem(at: path) as! HomeCell?
        cell?.mAddView.isHidden = false
        //cell?.mCartCountLabel.text = "1"
        let countStr = cell?.mCartCountLabel.text
        var count : Int = 0
        count = Int(countStr!)!
        count = count + 1
        cell?.mCartCountLabel.text = String(format:"%d",count)
        
        let selectedRow = cell?.mGramTF.selectedRow
        var optionID : String!
        var optionValueID : String!
        var isOPtionsAvailable : Bool = false
        
        let weights = dict!["weight_classes"] as? AnyObject
        let options = dict!["options"] as? AnyObject
        if(weights as? String == "null" && options as? String == "null")
        {
        }
        else{
            if(weights == nil || weights as? String == "null")
            {
                if(options == nil || options as? String == "null")
                {
                }
                else
                {
                    var optArray = dict!["options"] as? NSArray
                    if((optArray?.count)! > 0)
                    {
                        var optDict = optArray![selectedRow!] as? NSDictionary
                        optionID = optDict!["product_option_id"] as? String
                        optionValueID = optDict!["product_option_value_id"] as? String
                        isOPtionsAvailable = true
                    }
                }
            }
            else //if((weights?.count)! > 0)
            {
                var weighArray = dict!["weight_classes"] as? NSArray
                if((weighArray?.count)! > 0)
                {
                    var weighDict = weighArray![selectedRow!] as? NSDictionary
                    optionID = weighDict!["product_option_id"] as? String
                    optionValueID = weighDict!["product_option_value_id"] as? String
                    isOPtionsAvailable = true
                }
            }
        }
        
         SKActivityIndicator.show("Loading...")
         let Url =  String(format: "%@api/cart/edit_new&api_token=%@",Constants.BASEURL,UserDefaults.standard.string(forKey: "api_token")!)
         print(Url)
         let userID =  UserDefaults.standard.string(forKey: "customer_id")
        var parameters: Parameters = [:]
        if(isOPtionsAvailable)
        {
            parameters =
                [
                    "customer_id" : userID ?? "",
                    "product_id" : productID,
                    "quantity" : count,
                    "product_option_id" : optionID ?? "",
                    "product_option_value_id" : optionValueID ?? ""
            ]
        }
        else{
            parameters =
                [ "customer_id" : userID ?? "",
                  "product_id" : productID,
                  "quantity" : count,
            ]
        }
         
         print (parameters)
         let headers: HTTPHeaders =
         [
         "Content-Type": "application/json"
         ]
         Alamofire.request(Url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
         .responseJSON { response in
         print(response)
         SKActivityIndicator.dismiss()
         switch(response.result) {
         
         case .success:
         if let json = response.result.value
         {
         let JSON = json as! NSDictionary
         print(JSON)
         if(JSON["status"] as? String == "success")
         {
         self.view.makeToast(JSON["message"] as? String)
         self.getCartCount()
         }
         else
         {
           // self.view.makeToast(JSON["message"] as? String)
            }
         }
         break
         
         case .failure(let error):
         print(error)
         break
         
         }
         }
        
    }
    @objc func productsMinusBtnAction(_ sender: UIButton)
    {
        let tag = sender.tag
        let dict = self.productsArray[tag] as? NSDictionary
        let productID = dict!["product_id"] as! String
        let path = IndexPath(row: tag, section: 0)
        let cell = self.mProductsCollectionView.cellForItem(at: path) as! HomeCell?
        cell?.mAddView.isHidden = false
        //cell?.mCartCountLabel.text = "1"
        let countStr = cell?.mCartCountLabel.text
        var count : Int = 0
        count = Int(countStr!)!
        count = count - 1
        if(count == 0)
        {
            cell?.mAddView.isHidden = true
            cell?.mCartBtn.isHidden = false
        }
        cell?.mCartCountLabel.text = String(format:"%d",count)
        
        let selectedRow = cell?.mGramTF.selectedRow
        var optionID : String!
        var optionValueID : String!
        var isOPtionsAvailable : Bool = false
        
        let weights = dict!["weight_classes"] as? AnyObject
        let options = dict!["options"] as? AnyObject
        if(weights as? String == "null" && options as? String == "null")
        {
        }
        else{
            if(weights == nil || weights as? String == "null")
            {
                if(options == nil || options as? String == "null")
                {
                }
                else
                {
                    var optArray = dict!["options"] as? NSArray
                    if((optArray?.count)! > 0)
                    {
                        var optDict = optArray![selectedRow!] as? NSDictionary
                        optionID = optDict!["product_option_id"] as? String
                        optionValueID = optDict!["product_option_value_id"] as? String
                        isOPtionsAvailable = true
                    }
                }
            }
            else //if((weights?.count)! > 0)
            {
                var weighArray = dict!["weight_classes"] as? NSArray
                if((weighArray?.count)! > 0)
                {
                    var weighDict = weighArray![selectedRow!] as? NSDictionary
                    optionID = weighDict!["product_option_id"] as? String
                    optionValueID = weighDict!["product_option_value_id"] as? String
                    isOPtionsAvailable = true
                }
            }
        }
        
         SKActivityIndicator.show("Loading...")
        var Url =  ""
        if(count == 0)
        {
            Url = String(format: "%@api/cart/edit_new&api_token=%@",Constants.BASEURL,UserDefaults.standard.string(forKey: "api_token")!)
        }
        else
        {
            Url = String(format: "%@api/cart/edit_new&api_token=%@",Constants.BASEURL,UserDefaults.standard.string(forKey: "api_token")!)
        }
         print(Url)
         let userID =  UserDefaults.standard.string(forKey: "customer_id")
        var parameters: Parameters = [:]
        if(isOPtionsAvailable)
        {
            parameters =
                [
                    "customer_id" : userID ?? "",
                    "product_id" : productID,
                    "quantity" : count,
                    "product_option_id" : optionID ?? "",
                    "product_option_value_id" : optionValueID ?? ""
            ]
        }
        else{
            parameters =
                [ "customer_id" : userID ?? "",
                  "product_id" : productID,
                  "quantity" : count,
            ]
        }
         
         print (parameters)
         let headers: HTTPHeaders =
         [
         "Content-Type": "application/json"
         ]
         Alamofire.request(Url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
         .responseJSON { response in
         print(response)
         SKActivityIndicator.dismiss()
         switch(response.result) {
         
         case .success:
         if let json = response.result.value
         {
         let JSON = json as! NSDictionary
         print(JSON)
         if(JSON["status"] as? String == "success")
         {
         self.view.makeToast(JSON["message"] as? String)
         self.getCartCount()
         }
         else
         {
            //self.view.makeToast(JSON["message"] as? String)
            }
         }
         break
         
         case .failure(let error):
         print(error)
         break
         
         }
         }
        
    }
    @objc func recCartBtnAction(_ sender: UIButton)
    {
        let tag = sender.tag
        let dict = self.recommendedArray[tag] as? NSDictionary
        let productID = dict!["product_id"] as! String
        let path = IndexPath(row: tag, section: 0)
        let cell = self.mRecommendedCollectionView.cellForItem(at: path) as! HomeCell?
        cell?.mAddView.isHidden = false
        cell?.mCartCountLabel.text = "1"
        
        let selectedRow = cell?.mGramTF.selectedRow
        var optionID : String!
        var optionValueID : String!
        var isOPtionsAvailable : Bool = false
        
        let weights = dict!["weight_classes"] as? AnyObject
        let options = dict!["options"] as? AnyObject
        if(weights as? String == "null" && options as? String == "null")
        {
        }
        else{
            if(weights == nil || weights as? String == "null")
            {
                if(options == nil || options as? String == "null")
                {
                }
                else
                {
                    var optArray = dict!["options"] as? NSArray
                    if((optArray?.count)! > 0)
                    {
                        var optDict = optArray![selectedRow!] as? NSDictionary
                        optionID = optDict!["product_option_id"] as? String
                        optionValueID = optDict!["product_option_value_id"] as? String
                        isOPtionsAvailable = true
                    }
                }
            }
            else //if((weights?.count)! > 0)
            {
                var weighArray = dict!["weight_classes"] as? NSArray
                if((weighArray?.count)! > 0)
                {
                    var weighDict = weighArray![selectedRow!] as? NSDictionary
                    optionID = weighDict!["product_option_id"] as? String
                    optionValueID = weighDict!["product_option_value_id"] as? String
                    isOPtionsAvailable = true
                }
            }
        }
        
         SKActivityIndicator.show("Loading...")
         let Url =  String(format: "%@api/cart/add&api_token=%@",Constants.BASEURL,UserDefaults.standard.string(forKey: "api_token")!)
         print(Url)
         let userID =  UserDefaults.standard.string(forKey: "customer_id")
         var parameters: Parameters = [:]
        if(isOPtionsAvailable)
        {
            parameters = [
                "customer_id" : userID ?? "",
                "product_id" : productID,
                "quantity" : "1",
                "product_option_id" : optionID ?? "",
                "product_option_value_id" : optionValueID ?? ""
            ]
        }
        else{
            parameters = [
                "customer_id" : userID ?? "",
                "product_id" : productID,
                "quantity" : "1",
            ]
        }
         
         print (parameters)
         let headers: HTTPHeaders =
         [
         "Content-Type": "application/json"
         ]
         Alamofire.request(Url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
         .responseJSON { response in
         print(response)
         SKActivityIndicator.dismiss()
         switch(response.result) {
         
         case .success:
         if let json = response.result.value
         {
         let JSON = json as! NSDictionary
         print(JSON)
         if(JSON["status"] as? String == "success")
         {
         self.view.makeToast(JSON["message"] as? String)
         self.getCartCount()
         }
         else
         {
            self.view.makeToast(JSON["message"] as? String)
            }
         }
         break
         
         case .failure(let error):
         print(error)
         break
         
         }
         }
         
    }
    @objc func recPlusBtnAction(_ sender: UIButton)
    {
        let tag = sender.tag
        let dict = self.recommendedArray[tag] as? NSDictionary
        let productID = dict!["product_id"] as! String
        let path = IndexPath(row: tag, section: 0)
        let cell = self.mRecommendedCollectionView.cellForItem(at: path) as! HomeCell?
        cell?.mAddView.isHidden = false
        //cell?.mCartCountLabel.text = "1"
        let countStr = cell?.mCartCountLabel.text
        var count : Int = 0
        count = Int(countStr!)!
        count = count + 1
        cell?.mCartCountLabel.text = String(format:"%d",count)
        
        let selectedRow = cell?.mGramTF.selectedRow
        var optionID : String!
        var optionValueID : String!
        var isOPtionsAvailable : Bool = false
        
        let weights = dict!["weight_classes"] as? AnyObject
        let options = dict!["options"] as? AnyObject
        if(weights as? String == "null" && options as? String == "null")
        {
        }
        else{
            if(weights == nil || weights as? String == "null")
            {
                if(options == nil || options as? String == "null")
                {
                }
                else
                {
                    var optArray = dict!["options"] as? NSArray
                    if((optArray?.count)! > 0)
                    {
                        var optDict = optArray![selectedRow!] as? NSDictionary
                        optionID = optDict!["product_option_id"] as? String
                        optionValueID = optDict!["product_option_value_id"] as? String
                        isOPtionsAvailable = true
                    }
                }
            }
            else //if((weights?.count)! > 0)
            {
                var weighArray = dict!["weight_classes"] as? NSArray
                if((weighArray?.count)! > 0)
                {
                    var weighDict = weighArray![selectedRow!] as? NSDictionary
                    optionID = weighDict!["product_option_id"] as? String
                    optionValueID = weighDict!["product_option_value_id"] as? String
                    isOPtionsAvailable = true
                }
            }
        }
        
         SKActivityIndicator.show("Loading...")
         let Url =  String(format: "%@api/cart/edit_new&api_token=%@",Constants.BASEURL,UserDefaults.standard.string(forKey: "api_token")!)
         print(Url)
         let userID =  UserDefaults.standard.string(forKey: "customer_id")
        var parameters: Parameters = [:]
        if(isOPtionsAvailable)
        {
            parameters =
                [
                    "customer_id" : userID ?? "",
                    "product_id" : productID,
                    "quantity" : count,
                    "product_option_id" : optionID ?? "",
                    "product_option_value_id" : optionValueID ?? ""
            ]
        }
        else{
            parameters =
                [ "customer_id" : userID ?? "",
                  "product_id" : productID,
                  "quantity" : count,
            ]
        }
         
         print (parameters)
         let headers: HTTPHeaders =
         [
         "Content-Type": "application/json"
         ]
         Alamofire.request(Url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
         .responseJSON { response in
         print(response)
         SKActivityIndicator.dismiss()
         switch(response.result) {
         
         case .success:
         if let json = response.result.value
         {
         let JSON = json as! NSDictionary
         print(JSON)
         if(JSON["status"] as? String == "success")
         {
         self.view.makeToast(JSON["message"] as? String)
         self.getCartCount()
         }
         else
         {
           // self.view.makeToast(JSON["message"] as? String)
            }
         }
         break
         
         case .failure(let error):
         print(error)
         break
         
         }
         }
        
    }
    @objc func recMinusBtnAction(_ sender: UIButton)
    {
        let tag = sender.tag
        let dict = self.recommendedArray[tag] as? NSDictionary
        let productID = dict!["product_id"] as! String
        let path = IndexPath(row: tag, section: 0)
        let cell = self.mRecommendedCollectionView.cellForItem(at: path) as! HomeCell?
        cell?.mAddView.isHidden = false
        //cell?.mCartCountLabel.text = "1"
        let countStr = cell?.mCartCountLabel.text
        var count : Int = 0
        count = Int(countStr!)!
        count = count - 1
        if(count == 0)
        {
            cell?.mAddView.isHidden = true
            cell?.mCartBtn.isHidden = false
        }
        cell?.mCartCountLabel.text = String(format:"%d",count)
        
        let selectedRow = cell?.mGramTF.selectedRow
        var optionID : String!
        var optionValueID : String!
        var isOPtionsAvailable : Bool = false
        
        let weights = dict!["weight_classes"] as? AnyObject
        let options = dict!["options"] as? AnyObject
        if(weights as? String == "null" && options as? String == "null")
        {
        }
        else{
            if(weights == nil || weights as? String == "null")
            {
                if(options == nil || options as? String == "null")
                {
                }
                else
                {
                    var optArray = dict!["options"] as? NSArray
                    if((optArray?.count)! > 0)
                    {
                        var optDict = optArray![selectedRow!] as? NSDictionary
                        optionID = optDict!["product_option_id"] as? String
                        optionValueID = optDict!["product_option_value_id"] as? String
                        isOPtionsAvailable = true
                    }
                }
            }
            else //if((weights?.count)! > 0)
            {
                var weighArray = dict!["weight_classes"] as? NSArray
                if((weighArray?.count)! > 0)
                {
                    var weighDict = weighArray![selectedRow!] as? NSDictionary
                    optionID = weighDict!["product_option_id"] as? String
                    optionValueID = weighDict!["product_option_value_id"] as? String
                    isOPtionsAvailable = true
                }
            }
        }
        
         SKActivityIndicator.show("Loading...")
        var Url =  ""
        if(count == 0)
        {
            Url = String(format: "%@api/cart/edit_new&api_token=%@",Constants.BASEURL,UserDefaults.standard.string(forKey: "api_token")!)
        }
        else
        {
            Url = String(format: "%@api/cart/edit_new&api_token=%@",Constants.BASEURL,UserDefaults.standard.string(forKey: "api_token")!)
        }
         print(Url)
         let userID =  UserDefaults.standard.string(forKey: "customer_id")
        var parameters: Parameters = [:]
        if(isOPtionsAvailable)
        {
            parameters =
                [
                    "customer_id" : userID ?? "",
                    "product_id" : productID,
                    "quantity" : count,
                    "product_option_id" : optionID ?? "",
                    "product_option_value_id" : optionValueID ?? ""
            ]
        }
        else{
            parameters =
                [ "customer_id" : userID ?? "",
                  "product_id" : productID,
                  "quantity" : count,
            ]
        }
         
         print (parameters)
         let headers: HTTPHeaders =
         [
         "Content-Type": "application/json"
         ]
         Alamofire.request(Url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
         .responseJSON { response in
         print(response)
         SKActivityIndicator.dismiss()
         switch(response.result) {
         
         case .success:
         if let json = response.result.value
         {
         let JSON = json as! NSDictionary
         print(JSON)
         if(JSON["status"] as? String == "success")
         {
         self.view.makeToast(JSON["message"] as? String)
         self.getCartCount()
         }
         else
         {
            //self.view.makeToast(JSON["message"] as? String)
            }
         }
         break
         
         case .failure(let error):
         print(error)
         break
         
         }
         }
        
    }
    //MARK: IQDropdown delegate
    func textField(_ textField: IQDropDownTextField, didSelectItem item: String?) {
        
        print ("Tag=\(textField.tag)")
      
        if(textField.tag >= 300)
        {
            collectionType = "Recommended"
            textField.tag = textField.tag - 300
        }
        else if(textField.tag >= 200 && textField.tag < 300)
        {
            collectionType = "Products"
            textField.tag = textField.tag - 200
        }
        else if(textField.tag >= 100 && textField.tag < 200)
        {
            collectionType = "Deals"
            textField.tag = textField.tag - 100
        }
        else{
            textField.tag = textField.tag
        }
        print ("textFieldTag=\(textField.tag)")
        
        print ("item=\(textField.selectedRow)")
        if (textField.selectedRow == -1) {
            textField.selectedRow = 1
        }
        let selectedRow = textField.selectedRow
        let path = IndexPath(row: textField.tag, section: 0)
        let tag = textField.tag
        var finalPrice : String!
        var finalDiscount : String!
        var cartValue : String!
        var dict : NSDictionary!
        if(collectionType == "Deals")
        {
            dict = self.dealsArray[tag] as? NSDictionary
        }
        else if(collectionType == "Products")
        {
             dict = self.productsArray[tag] as? NSDictionary
        }
        else if(collectionType == "Recommended")
        {
             dict = self.recommendedArray[tag] as? NSDictionary
        }
        
        let weights = dict!["weight_classes"] as? AnyObject
        let options = dict!["options"] as? AnyObject
        if(weights as? String == "null" && options as? String == "null")
        {
            
        }
        else{
            if(weights == nil || weights as? String == "null")
            {
                
                
                if(options == nil || options as? String == "null")
                {
                }
                else
                {
                    var optArray = dict!["options"] as? NSArray
                    if((optArray?.count)! > 0)
                    {
                        var optDict = optArray![selectedRow] as? NSDictionary
                        let priceSting = String(format : "%d",optDict!["price"] as? Int ?? "")
                        finalPrice = String(format : "₹%@",priceSting)
                        
                        let doubleSting = String(format : "%d",optDict!["discount_price"] as? Int ?? "")
                        finalDiscount = String(format : "₹%@",doubleSting)
                        if(optDict!["cart_count"] as? Int == 0 || optDict!["cart_count"] as? String == "0")
                        {
                            cartValue = "0"
                        }
                        else{
                            cartValue = String(format : "%@",(optDict!["cart_count"] as? String)!)
                        }
                        
                    }
                }
            }
            else //if((weights?.count)! > 0)
            {
                var weighArray = dict!["weight_classes"] as? NSArray
                if((weighArray?.count)! > 0)
                {
                    var weighDict = weighArray![selectedRow] as? NSDictionary
                    let priceSting = String(format : "%d",weighDict!["price"] as? Int ?? "")
                    finalPrice = String(format : "₹%@",priceSting)
                    
                    let doubleSting = String(format : "%d",weighDict!["discount_price"] as? Int ?? "")
                    finalDiscount = String(format : "₹%@",doubleSting)
                    if(weighDict!["cart_count"] as? Int == 0 || weighDict!["cart_count"] as? String == "0")
                    {
                        cartValue = "0"
                    }
                    else{
                        cartValue = String(format : "%@",(weighDict!["cart_count"] as? String)!)
                    }
                    
                    
                }
            }
            
        }
        if(collectionType == "Deals")
        {
            let cell = self.mDealsCollectionView.cellForItem(at: path) as! HomeCell?
            cell?.mPriceLabel.text = finalPrice
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: finalDiscount)
            attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            cell?.mDicountLabel.attributedText = attributeString
            if(cartValue == "0")
            {
                cell?.mCartBtn.isHidden = false
                cell?.mAddView.isHidden = true
            }
            else
            {
                cell?.mCartBtn.isHidden = true
                cell?.mAddView.isHidden = false
                cell?.mCartCountLabel.text = String(format : "%@",cartValue)
            }
        }
        else if(collectionType == "Products")
        {
            let cell = self.mProductsCollectionView.cellForItem(at: path) as! HomeCell?
            cell?.mPriceLabel.text = finalPrice
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: finalDiscount)
            attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            cell?.mDicountLabel.attributedText = attributeString
            if(cartValue == "0")
            {
                cell?.mCartBtn.isHidden = false
                cell?.mAddView.isHidden = true
            }
            else
            {
                cell?.mCartBtn.isHidden = true
                cell?.mAddView.isHidden = false
                cell?.mCartCountLabel.text = String(format : "%@",cartValue)
            }
            
        }
        else if(collectionType == "Recommended")
        {
            let cell = self.mDealsCollectionView.cellForItem(at: path) as! HomeCell?
            cell?.mPriceLabel.text = finalPrice
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: finalDiscount)
            attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            cell?.mDicountLabel.attributedText = attributeString
            if(cartValue == "0")
            {
                cell?.mCartBtn.isHidden = false
                cell?.mAddView.isHidden = true
            }
            else
            {
                cell?.mCartBtn.isHidden = true
                cell?.mAddView.isHidden = false
                cell?.mCartCountLabel.text = String(format : "%@",cartValue)
            }
        }
       
        
    }
    //MARK: TableView delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.layout1Array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:layout1TableViewCell =  mlayout1TableView.dequeueReusableCell(withIdentifier: "layout1TableViewCell", for: indexPath) as!layout1TableViewCell
        
        cell.mLayout1View.layer.shadowColor = UIColor.darkGray.cgColor
        cell.mLayout1View.layer.shadowOffset = CGSize(width: 1, height:3)
        cell.mLayout1View.layer.shadowOpacity = 0.6
        cell.mLayout1View.layer.shadowRadius = 3.0
        cell.mLayout1View.layer.cornerRadius = 5.0
        
        
        let dict = self.layout1Array[indexPath.row] as? NSDictionary
        var image = dict!["image"] as? String
        if(image != nil){
            image = image?.replacingOccurrences(of: " ", with: "%20")
            cell.mLayout1ImageView?.sd_setImage(with: URL(string: image!), placeholderImage: UIImage(named: "placeholder"))
        }
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        UserDefaults.standard.setValue("HomeList", forKey: "SelectedTab")
        let dict = self.layout1Array[indexPath.row] as? NSDictionary
        let id = dict![ "id"] as? String
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "ListVC") as? ListVC
        myVC?.typeID = id
        self.navigationController?.pushViewController(myVC!, animated: true)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

