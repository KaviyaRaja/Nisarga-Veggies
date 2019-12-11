//
//  ListVC.swift
//  ECommerce
//
//  Created by Apple on 19/06/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import SKActivityIndicatorView
class ListVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource,IQDropDownTextFieldDelegate
{
    @IBOutlet weak var mGridImageView: UIImageView!
    @IBOutlet weak var listcollectionview: UICollectionView!
    @IBOutlet weak var mTableView : UITableView!
    @IBOutlet weak var mProductsCountLabel : UILabel!
    @IBOutlet weak var profileImage : UIImageView!
    var itemsArray : NSArray = []
    var isGrid : Bool = true
    var isFilterData : Bool = false
     @IBOutlet weak var mCartCountLabel : CustomFontLabel!
    var typeID : String!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mCartCountLabel.layer.cornerRadius = self.mCartCountLabel.frame.size.width/2
        self.mCartCountLabel.layer.masksToBounds = true
        isGrid = true
        listcollectionview.isHidden = false
        mTableView.isHidden = true
        profileImage.layer.masksToBounds = true
        profileImage.layer.cornerRadius = profileImage.frame.size.width/2;
        listcollectionview.register(UINib(nibName: "ProductListCell", bundle: .main), forCellWithReuseIdentifier: "ProductListCell")
        mTableView.register(UINib(nibName: "ListViewTableViewCell", bundle: .main), forCellReuseIdentifier: "ListViewTableViewCell")
        // Do any additional setup after loading the view.
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getData()
        getCartCount()
        
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
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshData), name: NSNotification.Name("FilteredData"), object: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func refreshData()
    {
        var dataArray : NSArray = []
        var data = UserDefaults.standard.object(forKey: "FilterData") as? Data
        if let aData = data {
            dataArray = NSKeyedUnarchiver.unarchiveObject(with: aData) as! NSArray
            print(dataArray)
            self.isFilterData = true
            self.itemsArray = dataArray
            self.mTableView.reloadData()
            self.listcollectionview.reloadData()
        }
    }
    // MARK: - API
    
    func getData()
    {
        SKActivityIndicator.show("Loading...")
        let Url = String(format: "%@api/custom/products/",Constants.BASEURL)
        print(Url)
            let userID =  UserDefaults.standard.string(forKey: "customer_id")
            let parameters: Parameters =
                [
                    "customer_id" : userID ?? "",
                    "data_id" : self.typeID ?? ""
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
                            let result = JSON["result"] as? AnyObject
                            if(result == nil || result as? String == "null")
                            {
                            }
                            else
                            {
                        self.itemsArray = (JSON["result"] as? NSArray)!
                        self.mProductsCountLabel.text = String(format: "%d Products found",self.itemsArray.count)
                        self.listcollectionview.reloadData()
                        self.mTableView.reloadData()
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
    // MARK: - Colletion View
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.itemsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ProductListCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductListCell", for: indexPath) as! ProductListCell
        
        let dict = self.itemsArray[indexPath.row] as? NSDictionary
        var image = dict!["image"] as? String
        image = image?.replacingOccurrences(of: " ", with: "%20")
        cell.productListImage.sd_setImage(with: URL(string: image ?? "" ), placeholderImage:nil)
        cell.productNameLabel.text = dict!["name"] as? String
        
        cell.productlistView.layer.shadowColor = UIColor.darkGray.cgColor
        cell.productlistView.layer.shadowOffset = CGSize(width: 1, height:3)
        cell.productlistView.layer.shadowOpacity = 0.6
        cell.productlistView.layer.shadowRadius = 3.0
        cell.productlistView.layer.cornerRadius = 5.0
        
        let priceSting = String(format : "%@",dict!["price"] as? String ?? "")
        let priceDouble =  Double (priceSting)
        if((priceDouble) != nil)
        {
            cell.productCostLabel.text = String(format : "₹%.2f",priceDouble!)
        }
        
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
                cell.attributeLabel.attributedText = attributeString
            }
            
        }
        if(dict!["Add_product_quantity_in_cart"] as? Int == 0 || dict!["Add_product_quantity_in_cart"] as? String == "0" )
        {
            cell.mCartBtn.isHidden = false
            cell.mCartView.isHidden = true
        }
        else
        {
            cell.mCartBtn.isHidden = true
            cell.mCartView.isHidden = false
            cell.mCartCountLabel.text = String(format : "%@",(dict!["Add_product_quantity_in_cart"] as? String)!)
        }
        if(dict!["wishlist_status"] as? Int == 1)
        {
            cell.wishListImage.image = UIImage(named: "Like")
        }
        else
        {
            cell.wishListImage.image = UIImage(named: "AddWishlist")
        }
        
        cell.mGramTF.delegate = self as? IQDropDownTextFieldDelegate
        cell.mGramTF.tag = indexPath.row
        cell.mGramTF.itemList = ["1 Piece"]
        let weights = dict!["weight_classes"] as? AnyObject
        let options = dict!["options"] as? AnyObject
        if(weights as? String == "null" && options as? String == "null")
        {
            cell.mGramTF.selectedItem = "1 Piece"
            cell.mGramTF.isUserInteractionEnabled = false
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
                        cell.productCostLabel.text = String(format : "₹%@",priceSting)
                        let doubleSting = String(format : "%d",optDict!["discount_price"] as? Int ?? "")
                        let discount = String(format : "₹%@",doubleSting)
                        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: discount)
                        attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                        cell.attributeLabel.attributedText = attributeString
                        
                        if(optDict!["cart_count"] as? Int == 0 || optDict!["cart_count"] as? String == "0" )
                        {
                            cell.mCartBtn.isHidden = false
                            cell.mCartView.isHidden = true
                        }
                        else
                        {
                            cell.mCartBtn.isHidden = true
                            cell.mCartView.isHidden = false
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
                    cell.productCostLabel.text = String(format : "₹%@",priceSting)
                    let doubleSting = String(format : "%d",weighDict!["discount_price"] as? Int ?? "")
                    let discount = String(format : "₹%@",doubleSting)
                    let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: discount)
                    attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                    cell.attributeLabel.attributedText = attributeString
                    
                    if(weighDict!["cart_count"] as? Int == 0 || weighDict!["cart_count"] as? String == "0" )
                    {
                        cell.mCartBtn.isHidden = false
                        cell.mCartView.isHidden = true
                    }
                    else
                    {
                        cell.mCartBtn.isHidden = true
                        cell.mCartView.isHidden = false
                        cell.mCartCountLabel.text = String(format : "%@",(weighDict!["cart_count"] as? String)!)
                    }
                }
            }
        }
        cell.mWishListBtn.tag = indexPath.row
        cell.mWishListBtn.addTarget(self, action:#selector(wishListBtnAction(_:)), for: UIControlEvents.touchUpInside)
        cell.mCartBtn.tag = indexPath.row
        cell.mCartBtn.addTarget(self, action:#selector(addBtnAction(_:)), for: UIControlEvents.touchUpInside)
        cell.mPlusBtn.tag = indexPath.row
        cell.mPlusBtn.addTarget(self, action:#selector(plusBtnAction(_:)), for: UIControlEvents.touchUpInside)
        cell.mMinusBtn.tag = indexPath.row
        cell.mMinusBtn.addTarget(self, action:#selector(minusBtnAction(_:)), for: UIControlEvents.touchUpInside)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: self.view.frame.size.width/2, height: self.listcollectionview.bounds.size.height)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
        let dict = self.itemsArray[indexPath.row] as? NSDictionary
        let productID = dict![ "product_id"] as? String
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "ProductDetailVC") as? ProductDetailVC
        myVC?.productID = productID! as NSString
        self.navigationController?.pushViewController(myVC!, animated: false)
    }
    // MARK: - TableView View
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return itemsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ListViewTableViewCell =  mTableView.dequeueReusableCell(withIdentifier: "ListViewTableViewCell", for: indexPath) as! ListViewTableViewCell
        cell.selectionStyle = .none
        let dict = self.itemsArray[indexPath.row] as? NSDictionary
        var image = dict!["image"] as? String
        image = image?.replacingOccurrences(of: " ", with: "%20")
        cell.listviewImage.sd_setImage(with: URL(string: image ?? "" ), placeholderImage:nil)
        cell.listNameLabel.text = dict!["name"] as? String
        
        let priceSting = String(format : "%@",dict!["price"] as? String ?? "")
        let priceDouble =  Double (priceSting)
        if((priceDouble) != nil)
        {
            cell.priceLabel.text = String(format : "₹%.2f",priceDouble!)
        }
        
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
                cell.listattributeLabel.attributedText = attributeString
            }
            
        }
        
        if(dict!["wishlist_status"] as? Int == 1)
        {
            cell.wishListImage.image = UIImage(named: "Like")
        }
        else
        {
            cell.wishListImage.image = UIImage(named: "AddWishlist")
        }
        if(dict!["Add_product_quantity_in_cart"] as? Int == 0 || dict!["Add_product_quantity_in_cart"] as? String == "0")
        {
            cell.mAddView.isHidden = false
            cell.mCartView.isHidden = true
        }
        else
        {
            cell.mAddView.isHidden = true
            cell.mCartView.isHidden = false
            cell.mCartCountLabel.text = String(format : "%@",(dict!["Add_product_quantity_in_cart"] as? String)!)
        }
        
        cell.mGramTF.delegate = self as? IQDropDownTextFieldDelegate
        cell.mGramTF.tag = indexPath.row
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
                        cell.priceLabel.text = String(format : "₹%@",priceSting)
                        let doubleSting = String(format : "%d",optDict!["discount_price"] as? Int ?? "")
                        let discount = String(format : "₹%@",doubleSting)
                        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: discount)
                        attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                        cell.listattributeLabel.attributedText = attributeString
                        
                        if(optDict!["cart_count"] as? Int == 0 || optDict!["cart_count"] as? String == "0")
                        {
                            cell.mAddView.isHidden = false
                            cell.mCartView.isHidden = true
                        }
                        else
                        {
                            cell.mAddView.isHidden = true
                            cell.mCartView.isHidden = false
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
                    cell.priceLabel.text = String(format : "₹%@",priceSting)
                    let doubleSting = String(format : "%d",weighDict!["discount_price"] as? Int ?? "")
                    let discount = String(format : "₹%@",doubleSting)
                    let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: discount)
                    attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                    cell.listattributeLabel.attributedText = attributeString
                    
                    if(weighDict!["cart_count"] as? Int == 0 || weighDict!["cart_count"] as? String == "0")
                    {
                        cell.mAddView.isHidden = false
                        cell.mCartView.isHidden = true
                    }
                    else
                    {
                        cell.mAddView.isHidden = true
                        cell.mCartView.isHidden = false
                        cell.mCartCountLabel.text = String(format : "%@",(weighDict!["cart_count"] as? String)!)
                    }
                }
            }
        }
        cell.mWishListBtn.tag = indexPath.row
        cell.mWishListBtn.addTarget(self, action:#selector(wishListBtnAction(_:)), for: UIControlEvents.touchUpInside)
        cell.mAddBtn.tag = indexPath.row
        cell.mAddBtn.addTarget(self, action:#selector(listAddBtnAction(_:)), for: UIControlEvents.touchUpInside)
        cell.mPlusBtn.tag = indexPath.row
        cell.mPlusBtn.addTarget(self, action:#selector(listPlusBtnAction(_:)), for: UIControlEvents.touchUpInside)
        cell.mMinusBtn.tag = indexPath.row
        cell.mMinusBtn.addTarget(self, action:#selector(listMinusBtnAction(_:)), for: UIControlEvents.touchUpInside)
        return cell;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let dict = self.itemsArray[indexPath.row] as? NSDictionary
        let productID = dict![ "product_id"] as? String
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "ProductDetailVC") as? ProductDetailVC
        myVC?.productID = productID! as NSString
        self.navigationController?.pushViewController(myVC!, animated: false)
    }
    
    // MARK: - Btn Actions

    @objc func wishListBtnAction(_ sender: UIButton)
    {
        let dict = self.itemsArray[sender.tag] as? NSDictionary
        let productID = dict!["product_id"] as! String
        SKActivityIndicator.show("Loading...")
        var Url =  ""
        if(dict!["wishlist_status"] as? Int == 1)
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
            "product_id" : productID
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
                        self.getData()
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
    @IBAction func listviewBtnAction(_ sender: UIButton)
    {
        if(isGrid == true)
        {
            isGrid = false
            listcollectionview.isHidden = true
            mTableView.isHidden = false
            self.mGridImageView.image = UIImage(named: "gridView")
        }
        else
        {
            isGrid = true
            listcollectionview.isHidden = false
            mTableView.isHidden = true
            self.mGridImageView.image = UIImage(named: "Listview")
        }
        if(isFilterData == false)
        {
            getData()
        }
    }
    @IBAction func cartBtnAction(_ sender: UIButton)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MyCartVC") as! MyCartVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func notificationBtnAction(_ sender: UIButton)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "NotificationVC") as? NotificationVC
        self.navigationController?.pushViewController(myVC!, animated: true)
    }
    @IBAction func filterBtnAction(_ sender: UIButton)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FilterVC") as! FilterVC
        self.navigationController?.pushViewController(vc, animated: true)
    }   
    @IBAction func searchBtnAction(_ sender: UIButton)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func addBtnAction(_ sender: UIButton)
    {
        let tag = sender.tag
        let dict = self.itemsArray[tag] as? NSDictionary
        let productID = dict!["product_id"] as! String
        let path = IndexPath(row: tag, section: 0)
        let cell = self.listcollectionview.cellForItem(at: path) as! ProductListCell?
        cell?.mCartView.isHidden = false
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
        let dict = self.itemsArray[tag] as? NSDictionary
        let productID = dict!["product_id"] as! String
        let path = IndexPath(row: tag, section: 0)
        let cell = self.listcollectionview.cellForItem(at: path) as! ProductListCell?
        cell?.mCartView.isHidden = false
        
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
    @objc func minusBtnAction(_ sender: UIButton)
    {
        let tag = sender.tag
        let dict = self.itemsArray[tag] as? NSDictionary
        let productID = dict!["product_id"] as! String
        let path = IndexPath(row: tag, section: 0)
        let cell = self.listcollectionview.cellForItem(at: path) as! ProductListCell?
        cell?.mCartView.isHidden = false
        //cell?.mCartCountLabel.text = "1"
        let countStr = cell?.mCartCountLabel.text
        var count : Int = 0
        count = Int(countStr!)!
        count = count - 1
        if(count == 0)
        {
            cell?.mCartView.isHidden = true
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
    @objc func listAddBtnAction(_ sender: UIButton)
    {
        let tag = sender.tag
        let dict = self.itemsArray[tag] as? NSDictionary
        let productID = dict!["product_id"] as! String
        let path = IndexPath(row: tag, section: 0)
        let cell = self.mTableView.cellForRow(at: path) as! ListViewTableViewCell?
        cell?.mCartView.isHidden = false
        cell?.mCartCountLabel.text = "1"
        cell?.mAddView.isHidden = true
        
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
    @objc func listPlusBtnAction(_ sender: UIButton)
    {
        let tag = sender.tag
        let dict = self.itemsArray[tag] as? NSDictionary
        let productID = dict!["product_id"] as! String
        let path = IndexPath(row: tag, section: 0)
        let cell = self.mTableView.cellForRow(at: path) as! ListViewTableViewCell?
        cell?.mCartView.isHidden = false
        cell?.mAddView.isHidden = true
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
    @objc func listMinusBtnAction(_ sender: UIButton)
    {
        let tag = sender.tag
        let dict = self.itemsArray[tag] as? NSDictionary
        let productID = dict!["product_id"] as! String
        let path = IndexPath(row: tag, section: 0)
        let cell = self.mTableView.cellForRow(at: path) as! ListViewTableViewCell?
        cell?.mCartView.isHidden = false
        cell?.mAddView.isHidden = true
        //cell?.mCartCountLabel.text = "1"
        let countStr = cell?.mCartCountLabel.text
        var count : Int = 0
        count = Int(countStr!)!
        count = count - 1
        if(count == 0)
        {
            cell?.mCartView.isHidden = true
            cell?.mAddView.isHidden = false
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
        let dict = self.itemsArray[tag] as? NSDictionary
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
        if(isGrid == true)
        {
            let cell = self.listcollectionview.cellForItem(at: path) as! ProductListCell?
             cell?.productCostLabel.text = finalPrice
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: finalDiscount)
            attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            cell?.attributeLabel.attributedText = attributeString
            
            if(cartValue == "0" )
            {
                cell?.mCartBtn.isHidden = false
                cell?.mCartView.isHidden = true
            }
            else
            {
                cell?.mCartBtn.isHidden = true
                cell?.mCartView.isHidden = false
                cell?.mCartCountLabel.text = String(format : "%@",cartValue)
            }
        }
        else{
            let cell = self.mTableView.cellForRow(at: path) as! ListViewTableViewCell?
            cell?.priceLabel.text = finalPrice
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: finalDiscount)
            attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            cell?.listattributeLabel.attributedText = attributeString
            
            if(cartValue == "0" )
            {
                cell?.mAddView.isHidden = false
                cell?.mCartView.isHidden = true
            }
            else
            {
                cell?.mAddView.isHidden = true
                cell?.mCartView.isHidden = false
                cell?.mCartCountLabel.text = String(format : "%@",cartValue)
            }
        }
        
    }
}





