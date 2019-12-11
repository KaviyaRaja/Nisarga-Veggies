//
//  ProductDetailVC.swift
//  Nisagra
//
//  Created by Hari Krish on 29/07/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import SKActivityIndicatorView
extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
extension String{
    func convertHtml() -> NSAttributedString{
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do{
            
            return try NSAttributedString(data: data, options: [.documentType : NSAttributedString.DocumentType.html], documentAttributes: nil)
        }catch{
            return NSAttributedString()
        }
    }
}
class ProductDetailVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate,IQDropDownTextFieldDelegate{
    
    @IBOutlet weak var mTitleLabel: CustomFontLabel!
    @IBOutlet weak var mBannerCollectionView: UICollectionView!
    @IBOutlet weak var mPageCtrl: UIPageControl!
    @IBOutlet weak var mSimilarProductsCollectionView: UICollectionView!
    @IBOutlet weak var maboutLabel: CustomFontLabel!
    @IBOutlet weak var mNutLabel: CustomFontLabel!
    @IBOutlet weak var mBenefitsLabel: CustomFontLabel!
    @IBOutlet weak var mDescriptionLabel: CustomFontLabel!
    @IBOutlet weak var mGramTF: IQDropDownTextField!
    @IBOutlet weak var mCartCountLabel : CustomFontLabel!
    @IBOutlet weak var mNameLabel : CustomFontLabel!
    @IBOutlet weak var mPriceLabel : CustomFontLabel!
    @IBOutlet weak var mDicountLabel : CustomFontLabel!
    @IBOutlet weak var mAddView : UIView!
    @IBOutlet weak var mCartView : UIView!
    @IBOutlet weak var mPlusImageView : UIImageView!
    @IBOutlet weak var mMinusImageView : UIImageView!
    var bannerArray : NSArray = []
    var similarArray : NSArray = []
    var productID : NSString!
    var detailarray : NSArray = []
    var relatedID : NSString!
    var isSimilarProducts : Bool = false
    
    @IBOutlet weak var mSimilarView : UIView!
    @IBOutlet weak var SimilarHeight: NSLayoutConstraint!
    @IBOutlet weak var descriptionHeight: NSLayoutConstraint!
    @IBOutlet weak var contentHeight: NSLayoutConstraint!
    
    @IBOutlet weak var mDetailView : UIView!
    @IBOutlet weak var mDetailImageView : UIImageView!
    @IBOutlet weak var mScrollView : UIScrollView!
    @IBOutlet weak var mArrowImageView : UIImageView!
    @IBOutlet weak var mWishlistBtn : UIButton!
    @IBOutlet weak var mCartBtn : UIButton!
    var slideCount : Int?
    var collectionType : NSString = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mBannerCollectionView.register(UINib(nibName: "BannerCell", bundle: nil), forCellWithReuseIdentifier: "BannerCell")
        self.mSimilarProductsCollectionView.register(UINib(nibName: "HomeCell", bundle: nil), forCellWithReuseIdentifier: "HomeCell")
        self.mAddView.layer.cornerRadius = 5
        self.mAddView.layer.borderColor = UIColor(red:0.20, green:0.47, blue:0.24, alpha:1.0).cgColor
        self.mAddView.layer.borderWidth = 1
        
        self.mPlusImageView.image = self.mPlusImageView.image!.withRenderingMode(.alwaysTemplate)
        self.mMinusImageView.image = self.mMinusImageView.image!.withRenderingMode(.alwaysTemplate)
        
        self.mPlusImageView.tintColor = UIColor.white
        self.mMinusImageView.tintColor = UIColor.white
        self.mGramTF.delegate = self as? IQDropDownTextFieldDelegate
        
        // Do any additional setup after loading the view.
        getOrderDetail()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Btn Actions
    
    
    
    @IBAction func backBtnAction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func faqBtnAction(_ sender: Any)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "FAQSVC") as? FAQSVC
        self.navigationController?.pushViewController(myVC!, animated: true)
    }
    @IBAction func wishListBtnAction(_ sender: Any)
    {
        SKActivityIndicator.show("Loading...")
        let detaildict = self.detailarray[0] as! NSDictionary
        var Url =  ""
        if(detaildict["wishlist_status"] as? Int == 1)
        {
            Url = String(format: "%@account/wishlist/removeWishList",Constants.BASEURL)
        }
        else
        {
            Url = String(format: "%@account/wishlist/insertWishList",Constants.BASEURL)
        }
        print(Url)
        let userID =  UserDefaults.standard.string(forKey: "customer_id")
        let parameters: Parameters =
            [
                "customer_id" : userID ?? "",
                "product_id" : productID as String? ?? ""
        ]
        
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
                            self.getOrderDetail()
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
    
    @IBAction func addBtnAction(_ sender: Any)
    {
        self.mAddView.isHidden = true
        self.mCartView.isHidden = false
        self.mCartCountLabel.text = "1"
        let dict = self.detailarray[0] as! NSDictionary
        let selectedRow = self.mGramTF.selectedRow
        var optionID : String!
        var optionValueID : String!
        var isOPtionsAvailable : Bool = false
        
        let weights = dict["weight_classes"] as? AnyObject
        let options = dict["options"] as? AnyObject
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
                    var optArray = dict["options"] as? NSArray
                    if((optArray?.count)! > 0)
                    {
                        var optDict = optArray![selectedRow] as? NSDictionary
                        optionID = optDict!["product_option_id"] as? String
                        optionValueID = optDict!["product_option_value_id"] as? String
                        isOPtionsAvailable = true
                    }
                }
            }
            else //if((weights?.count)! > 0)
            {
                var weighArray = dict["weight_classes"] as? NSArray
                if((weighArray?.count)! > 0)
                {
                    var weighDict = weighArray![selectedRow] as? NSDictionary
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
                "product_id" : productID ?? "",
                "quantity" : "1",
                "product_option_id" : optionID ?? "",
                "product_option_value_id" : optionValueID ?? ""
            ]
        }
        else{
            parameters = [
                "customer_id" : userID ?? "",
                "product_id" : productID ?? "",
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
                            self.getOrderDetail()
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
    @IBAction func plusBtnAction(_ sender: Any)
    {
        self.mAddView.isHidden = true
        self.mCartView.isHidden = false
        let dict = self.detailarray[0] as! NSDictionary
        let selectedRow = self.mGramTF.selectedRow
        var optionID : String!
        var optionValueID : String!
        var isOPtionsAvailable : Bool = false
        
        let weights = dict["weight_classes"] as? AnyObject
        let options = dict["options"] as? AnyObject
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
                    var optArray = dict["options"] as? NSArray
                    if((optArray?.count)! > 0)
                    {
                        var optDict = optArray![selectedRow] as? NSDictionary
                        optionID = optDict!["product_option_id"] as? String
                        optionValueID = optDict!["product_option_value_id"] as? String
                        isOPtionsAvailable = true
                    }
                }
            }
            else //if((weights?.count)! > 0)
            {
                var weighArray = dict["weight_classes"] as? NSArray
                if((weighArray?.count)! > 0)
                {
                    var weighDict = weighArray![selectedRow] as? NSDictionary
                    optionID = weighDict!["product_option_id"] as? String
                    optionValueID = weighDict!["product_option_value_id"] as? String
                    isOPtionsAvailable = true
                }
            }
        }
        let countStr = self.mCartCountLabel.text
        var count : Int = 0
        count = Int(countStr!)!
        count = count + 1
        self.mCartCountLabel.text = String(format:"%d",count)
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
    @IBAction func minusBtnAction(_ sender: Any)
    {
        self.mAddView.isHidden = true
        self.mCartView.isHidden = false
        let dict = self.detailarray[0] as! NSDictionary
        let selectedRow = self.mGramTF.selectedRow
        var optionID : String!
        var optionValueID : String!
        var isOPtionsAvailable : Bool = false
        
        let weights = dict["weight_classes"] as? AnyObject
        let options = dict["options"] as? AnyObject
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
                    var optArray = dict["options"] as? NSArray
                    if((optArray?.count)! > 0)
                    {
                        var optDict = optArray![selectedRow] as? NSDictionary
                        optionID = optDict!["product_option_id"] as? String
                        optionValueID = optDict!["product_option_value_id"] as? String
                        isOPtionsAvailable = true
                    }
                }
            }
            else //if((weights?.count)! > 0)
            {
                var weighArray = dict["weight_classes"] as? NSArray
                if((weighArray?.count)! > 0)
                {
                    var weighDict = weighArray![selectedRow] as? NSDictionary
                    optionID = weighDict!["product_option_id"] as? String
                    optionValueID = weighDict!["product_option_value_id"] as? String
                    isOPtionsAvailable = true
                }
            }
        }
        let countStr = self.mCartCountLabel.text
        var count : Int = 0
        count = Int(countStr!)!
        count = count - 1
        if(count == 0)
        {
            self.mAddView.isHidden = false
            self.mCartView.isHidden = true
        }
        
        self.mCartCountLabel.text = String(format:"%d",count)
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
    @IBAction func closeBtnAction(_ sender: Any)
    {
        self.mDetailView.removeFromSuperview()
    }
    // MARK: - API
    
    func getOrderDetail()
    {
        SKActivityIndicator.show("Loading...")
        let Url = String(format: "%@api/custom/productdetails/",Constants.BASEURL)
        print(Url)
        let userID =  UserDefaults.standard.string(forKey: "customer_id")
        var id : String = ""
        if(self.isSimilarProducts)
        {
            id = self.relatedID as String
        }
        else{
            id = self.productID as String
        }
        let parameters: Parameters =
            [
                "customer_id" : userID ?? "",
                "product_id" : id
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
                            self.getsimilarProducts()
                            self.detailarray = (JSON["result"] as? NSArray)!
                            let dict = self.detailarray[0] as! NSDictionary
                            self.mTitleLabel.text = dict["name"] as? String
                            self.mNameLabel.text = dict["name"] as? String
                            
                            if(dict["wishlist_status"] as? Int == 1)
                            {
                                self.mWishlistBtn .setTitle("Added to Wishlist", for: .normal)
                            }
                            else
                            {
                                self.mWishlistBtn .setTitle("Add to Wishlist", for: .normal)
                            }
                            
                            let priceSting = String(format : "%@",dict["price"] as? String ?? "")
                            let priceDouble =  Double (priceSting)
                            if((priceDouble) != nil)
                            {
                                self.mPriceLabel.text = String(format : "₹%.2f",priceDouble!)
                            }
                            var discount = String(format : "%@",dict["discount_price"] as? String ?? "")
                            if(discount == "null" || discount == "0")
                            {
                                
                            }
                            else
                            {
                                let discountSting = String(format : "%@",dict["discount_price"] as? String ?? "")
                                let discountDouble =  Double (discountSting)
                                if((discountDouble) != nil)
                                {
                                    discount = String(format : "₹%.2f",discountDouble!)
                                    let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: discount)
                                    attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                                    self.mDicountLabel.attributedText = attributeString
                                }
                                
                            }
                            self.mGramTF.delegate = self as? IQDropDownTextFieldDelegate
                            self.mGramTF.isHidden = false
                            self.mGramTF.itemList = ["1 Piece"]
                            if(dict["Add_product_quantity_in_cart"] as? Int == 0  || dict["Add_product_quantity_in_cart"] as? String == "0")
                            {
                                self.mCartView.isHidden = true
                                self.mAddView.isHidden = false
                                self.mCartBtn .setTitle("Add to Cart", for: .normal)
                            }
                            else
                            {
                                self.mCartView.isHidden = false
                                self.mAddView.isHidden = true
                                self.mCartCountLabel.text = String(format : "%@",(dict["Add_product_quantity_in_cart"] as? String)!)
                                self.mCartBtn .setTitle("Added to Cart", for: .normal)
                            }
                            
                            let weights = dict["weight_classes"] as? AnyObject
                            let options = dict["options"] as? AnyObject
                            if(weights as? String == "null" && options as? String == "null")
                            {
                                self.mGramTF.selectedItem = ""
                                self.mGramTF.isHidden = true
                                self.mArrowImageView.isHidden = true
                            }
                            else{
                                if(weights == nil || weights as? String == "null")
                                {
                                    if(options == nil || options as? String == "null")
                                    {
                                        self.mGramTF.selectedItem = ""
                                        self.mGramTF.isUserInteractionEnabled = false
                                        self.mArrowImageView.isHidden = true
                                        
                                        
                                    }
                                    else
                                    {
                                        var optArray = dict["options"] as? NSArray
                                        if((optArray?.count)! > 0)
                                        {
                                            var optionsArray = [String]()
                                            for optionsDict in optArray! {
                                                let size = (optionsDict as AnyObject).object(forKey: "name") as? String
                                                optionsArray.append(size!)
                                            }
                                            print("weightArray=\(optionsArray)")
                                            
                                            self.mGramTF.itemList = optionsArray
                                            self.mGramTF.selectedRow = 1
                                            self.mArrowImageView.isHidden = false
                                            var optDict = optArray![0] as? NSDictionary
                                            let priceSting = String(format : "%d",optDict!["price"] as? Int ?? "")
                                            self.mPriceLabel.text = String(format : "₹%@",priceSting)
                                            let doubleSting = String(format : "%d",optDict!["discount_price"] as? Int ?? "")
                                            let discount = String(format : "₹%@",doubleSting)
                                            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: discount)
                                            attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                                            self.mDicountLabel.attributedText = attributeString
                                            
                                            if(optDict!["cart_count"] as? Int == 0  || optDict!["cart_count"] as? String == "0")
                                            {
                                                self.mCartView.isHidden = true
                                                self.mAddView.isHidden = false
                                                self.mCartBtn .setTitle("Add to Cart", for: .normal)
                                            }
                                            else
                                            {
                                                self.mCartView.isHidden = false
                                                self.mAddView.isHidden = true
                                                self.mCartCountLabel.text = String(format : "%@",(optDict!["cart_count"] as? String)!)
                                                self.mCartBtn .setTitle("Added to Cart", for: .normal)
                                            }
                                        }
                                    }
                                }
                                else //if((weights?.count)! > 0)
                                {
                                    var weighArray = dict["weight_classes"] as? NSArray
                                    if((weighArray?.count)! > 0)
                                    {
                                        var weightsArray = [String]()
                                        for weightsDict in weighArray! {
                                            let size = (weightsDict as AnyObject).object(forKey: "name") as? String
                                            weightsArray.append(size!)
                                        }
                                        print("weightArray=\(weightsArray)")
                                        
                                        self.mGramTF.itemList = weightsArray
                                        self.mGramTF.selectedRow = 1
                                        self.mArrowImageView.isHidden = false
                                        
                                        var weighDict = weighArray![0] as? NSDictionary
                                        let priceSting = String(format : "%d",weighDict!["price"] as? Int ?? "")
                                        self.mPriceLabel.text = String(format : "₹%@",priceSting)
                                        let doubleSting = String(format : "%d",weighDict!["discount_price"] as? Int ?? "")
                                        let discount = String(format : "₹%@",doubleSting)
                                        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: discount)
                                        attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                                        self.mDicountLabel.attributedText = attributeString
                                        if(weighDict!["cart_count"] as? Int == 0  || weighDict!["cart_count"] as? String == "0")
                                        {
                                            self.mCartView.isHidden = true
                                            self.mAddView.isHidden = false
                                            self.mCartBtn .setTitle("Add to Cart", for: .normal)
                                        }
                                        else
                                        {
                                            self.mCartView.isHidden = false
                                            self.mAddView.isHidden = true
                                            self.mCartCountLabel.text = String(format : "%@",(weighDict!["cart_count"] as? String)!)
                                            self.mCartBtn .setTitle("Added to Cart", for: .normal)
                                        }
                                        
                                    }
                                }
                            }
                         
                            let htmlStr = dict["description"] as! String
                            self.mDescriptionLabel.attributedText = htmlStr.convertHtml()
                            self.descriptionHeight.constant = self.mDescriptionLabel.bounds.size.height
                            self.bannerArray = (dict["image"] as? NSArray)!
                            self.mBannerCollectionView.reloadData()
                            self.mPageCtrl.numberOfPages = self.bannerArray.count
                            self.contentHeight.constant = 250 + self.SimilarHeight.constant + self.descriptionHeight.constant
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
    func getsimilarProducts()
    {
        SKActivityIndicator.show("Loading...")
        let Url = String(format: "%@api/order/similarProductList",Constants.BASEURL)
        print(Url)
        
        let userID =  UserDefaults.standard.string(forKey: "customer_id")
        var id : String = ""
        if(self.isSimilarProducts)
        {
            id = self.relatedID as String
        }
        else{
            id = self.productID as String
        }
        let parameters: Parameters =
        [
            "customer_id" : userID ?? "",
            "product_id" : id,
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
                            self.similarArray = (JSON["result"] as? NSArray)!
                            self.mSimilarProductsCollectionView.reloadData()
                            self.SimilarHeight.constant = 180
                            self.mSimilarView.isHidden = false
                        }
                        else
                        {
                            self.SimilarHeight.constant = 0
                            self.mSimilarView.isHidden = true
                            
                        }
                        self.contentHeight.constant = 250 + self.SimilarHeight.constant + self.descriptionHeight.constant
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
        if(collectionView == self.mBannerCollectionView)
        {
            return self.bannerArray.count
        }
        else if(collectionView == self.mSimilarProductsCollectionView)
        {
            return self.similarArray.count
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        var defaultCell : UICollectionViewCell!
        if(collectionView == self.mBannerCollectionView)
        {
            let cell: BannerCell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerCell", for: indexPath) as! BannerCell
            let dict = self.bannerArray[indexPath.row] as? NSDictionary
            var image = dict!["image"] as? String
            if(image != nil){
                image = image?.replacingOccurrences(of: " ", with: "%20")
                cell.mImageView.sd_setImage(with: URL(string: image!), placeholderImage: UIImage(named: "placeholder"))
            }
            let detaildict = self.detailarray[0] as! NSDictionary
            if(detaildict["wishlist_status"] as? Int == 1)
            {
                cell.wishListImage.image = UIImage(named: "Like")
            }
            else
            {
                cell.wishListImage.image = UIImage(named: "AddWishlist")
            }
            cell.mBgView.layer.shadowColor = UIColor.darkGray.cgColor
            cell.mBgView.layer.shadowOffset = CGSize(width: 1, height:3)
            cell.mBgView.layer.shadowOpacity = 0.6
            cell.mBgView.layer.shadowRadius = 3.0
            cell.mBgView.layer.cornerRadius = 5.0
            
            return cell
        }
        else if(collectionView == self.mSimilarProductsCollectionView)
        {
            let cell: HomeCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCell", for: indexPath) as! HomeCell
            
            cell.mBGView.layer.shadowColor = UIColor.darkGray.cgColor
            cell.mBGView.layer.shadowOffset = CGSize(width: 1, height:3)
            cell.mBGView.layer.shadowOpacity = 0.6
            cell.mBGView.layer.shadowRadius = 3.0
            cell.mBGView.layer.cornerRadius = 5.0
            
            let dict = self.similarArray[indexPath.row] as? NSDictionary
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
            if(dict!["Add_product_quantity_in_cart"] as? Int == 0  || dict!["Add_product_quantity_in_cart"] as? String == "0")
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
                        let priceSting = String(format : "%@",dict!["price"] as? String ?? "")
                        let priceDouble =  Double (priceSting)
                        if((priceDouble) != nil)
                        {
                            cell.mPriceLabel.text = String(format : "₹%.2f",priceDouble!)
                        }
                        
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
        
        return defaultCell!
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if(collectionView == self.mBannerCollectionView)
        {
            return CGSize(width: 150, height: collectionView.bounds.size.height)
        }
        else if(collectionView == self.mSimilarProductsCollectionView)
        {
            return CGSize(width: 140, height: 150)
        }
        return CGSize(width: 0, height: 0)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if(collectionView == self.mBannerCollectionView)
        {
            self.mDetailView.frame = self.view.frame
            self.view.addSubview(self.mDetailView)
            
            let dict = self.bannerArray[indexPath.row] as? NSDictionary
            var image = dict!["image"] as? String
            if(image != nil){
                image = image?.replacingOccurrences(of: " ", with: "%20")
                self.mDetailImageView.sd_setImage(with: URL(string: image!), placeholderImage: UIImage(named: "placeholder"))
            }
            self.mScrollView.minimumZoomScale = 1.0
            self.mScrollView.maximumZoomScale = 10.0
        }
        if(collectionView == self.mSimilarProductsCollectionView)
        {
            let dict = self.similarArray[indexPath.row] as? NSDictionary
            self.productID = dict![ "product_id"] as! NSString
            self.relatedID = dict![ "related_id"] as! NSString
            self.isSimilarProducts = true
            getOrderDetail()
        }
        
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        if(scrollView == self.mBannerCollectionView)
        {
            for cell in self.mBannerCollectionView.visibleCells  as! [BannerCell]    {
                let indexPath = self.mBannerCollectionView.indexPath(for: cell as UICollectionViewCell)
                self.slideCount = (indexPath?.item)!
                self.mPageCtrl.currentPage = self.slideCount!
            }
        }
    }
    
    @objc func productsCartBtnAction(_ sender: UIButton)
    {
        let tag = sender.tag
        let dict = self.similarArray[tag] as? NSDictionary
        let productID = dict!["product_id"] as! String
        let path = IndexPath(row: tag, section: 0)
        let cell = self.mSimilarProductsCollectionView.cellForItem(at: path) as! HomeCell?
        cell?.mAddView.isHidden = false
        cell?.mCartCountLabel.text = "1"
        
        SKActivityIndicator.show("Loading...")
        let Url =  String(format: "%@api/cart/add&api_token=%@",Constants.BASEURL,UserDefaults.standard.string(forKey: "api_token")!)
        print(Url)
        let userID =  UserDefaults.standard.string(forKey: "customer_id")
        let parameters: Parameters =
            [
                "customer_id" : userID ?? "",
                "product_id" : productID ,
                "quantity" : "1"
        ]
        
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
                            self.getsimilarProducts()
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
    @objc func productsPlusBtnAction(_ sender: UIButton)
    {
        let tag = sender.tag
        let dict = self.similarArray[tag] as? NSDictionary
        let productID = dict!["product_id"] as! String
        let path = IndexPath(row: tag, section: 0)
        let cell = self.mSimilarProductsCollectionView.cellForItem(at: path) as! HomeCell?
        cell?.mAddView.isHidden = false
        //cell?.mCartCountLabel.text = "1"
        let countStr = cell?.mCartCountLabel.text
        var count : Int = 0
        count = Int(countStr!)!
        count = count + 1
        cell?.mCartCountLabel.text = String(format:"%d",count)
        
        SKActivityIndicator.show("Loading...")
        let Url =  String(format: "%@api/cart/edit_new&api_token=%@",Constants.BASEURL,UserDefaults.standard.string(forKey: "api_token")!)
        print(Url)
        let userID =  UserDefaults.standard.string(forKey: "customer_id")
        let parameters: Parameters =
            [
                "customer_id" : userID ?? "",
                "product_id" : productID as String? ?? "",
                "quantity" : count
        ]
        
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
                            self.getsimilarProducts()
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
    @objc func productsMinusBtnAction(_ sender: UIButton)
    {
        let tag = sender.tag
        let dict = self.similarArray[tag] as? NSDictionary
        let productID = dict!["product_id"] as! String
        let path = IndexPath(row: tag, section: 0)
        let cell = self.mSimilarProductsCollectionView.cellForItem(at: path) as! HomeCell?
        cell?.mAddView.isHidden = false
        //cell?.mCartCountLabel.text = "1"
        let countStr = cell?.mCartCountLabel.text
        var count : Int = 0
        count = Int(countStr!)!
        count = count - 1
        if(count == 0)
        {
            cell?.mAddView.isHidden = true
        }
        
        cell?.mCartCountLabel.text = String(format:"%d",count)
        
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
        let parameters: Parameters =
            [
                "customer_id" : userID ?? "",
                "product_id" : productID as String? ?? "",
                "quantity" : count
        ]
        
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
                            self.getsimilarProducts()
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
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.mDetailImageView
    }
    
    //MARK: IQDropdown delegate
    func textField(_ textField: IQDropDownTextField, didSelectItem item: String?) {
        
        print ("Tag=\(textField.tag)")
        
            if(textField.tag >= 100)
            {
                collectionType = "Similar"
                textField.tag = textField.tag - 100
            }
            else{
                collectionType = "Product"
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
        
        if(collectionType == "Product")
        {
            dict = self.detailarray[0] as! NSDictionary
        }
        else if(collectionType == "Similar")
        {
            dict = self.similarArray[tag] as? NSDictionary
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
        if(collectionType == "Similar")
        {
            let cell = self.mSimilarProductsCollectionView.cellForItem(at: path) as! HomeCell?
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
        else
        {
            self.mPriceLabel.text = finalPrice
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: finalDiscount)
            attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            self.mDicountLabel.attributedText = attributeString
            if(cartValue == "0")
            {
                self.mCartView.isHidden = true
                self.mAddView.isHidden = false
                self.mCartBtn .setTitle("Add to Cart", for: .normal)
            }
            else
            {
                self.mCartView.isHidden = false
                self.mAddView.isHidden = true
                self.mCartCountLabel.text = String(format : "%@",cartValue)
                self.mCartBtn .setTitle("Added to Cart", for: .normal)
            }
        }
        
        
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
