//
//  WishListVC.swift
//  ECommerce
//
//  Created by Apple on 11/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import SKActivityIndicatorView
class WishListVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var wishlistTableview: UITableView!
    @IBOutlet weak var mProductsCountLabel : UILabel!
    
    var wishlistArray : NSArray = []
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

     wishlistTableview.register(UINib(nibName: "WishListCell", bundle: .main), forCellReuseIdentifier: "WishListCell")
        
         getWishList()
       refreshControl.addTarget(self, action: #selector(refresh(_:)), for: UIControlEvents.valueChanged)
         
        self.wishlistTableview.addSubview(refreshControl)
    }
    @IBAction func faqAction(_ sender: UIButton)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FAQSVC") as! FAQSVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func notificationBtnAction(_ sender: UIButton)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "NotificationVC") as? NotificationVC
        self.navigationController?.pushViewController(myVC!, animated: true)
    }
    @IBAction func backBtnAction(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func refresh(_ sender: AnyObject) {
        // Code to refresh table view
        getWishList()
        self.refreshControl.endRefreshing()
    }
    func getWishList()
    {
        SKActivityIndicator.show("Loading...")
        let Url = String(format: "%@account/wishlist/wishListProducts",Constants.BASEURL)
        print(Url)
        let userID =  UserDefaults.standard.string(forKey: "customer_id")
        let parameters: Parameters =
        [
            "customer_id" : userID ?? ""
        ]
       
        print (parameters)
        let headers: HTTPHeaders =
        [
            "Content-Type": "application/json"
        ]
        Alamofire.request(Url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
             SKActivityIndicator.dismiss()
            print(response)
            switch(response.result) {
                
            case .success:
                if let json = response.result.value
                {
                    let JSON = json as! NSDictionary
                    print(JSON)
                    if(JSON["status"] as? String == "success")
                    {
                        let result = JSON["result"] as? AnyObject
                        if(result as? String == "null")
                        {
                            return
                        }
                    self.wishlistArray = (JSON["result"] as? NSArray)!
                    self.wishlistTableview.reloadData()
                    self.mProductsCountLabel.text = String(format: "%d items",self.wishlistArray.count)
                    }
                    else
                    {
                        self.wishlistArray = []
                        self.wishlistTableview.reloadData()
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
         return wishlistArray.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:WishListCell =  wishlistTableview.dequeueReusableCell(withIdentifier: "WishListCell", for: indexPath) as! WishListCell
        cell.selectionStyle = .none
        cell.mBgView.layer.shadowColor = UIColor.darkGray.cgColor
        cell.mBgView.layer.shadowOffset = CGSize(width: 1, height:3)
        cell.mBgView.layer.shadowOpacity = 0.6
        cell.mBgView.layer.shadowRadius = 3.0
        cell.mBgView.layer.cornerRadius = 5.0
        let dict = self.wishlistArray[indexPath.row] as? NSDictionary
        var image = dict!["image"] as? String
        image = image?.replacingOccurrences(of: " ", with: "%20")
        cell.wishProductLabel.text = dict![ "name"] as? String
        cell.wishkgLabel.text = dict![ "quantity"] as? String
        cell.wishlistImage.sd_setImage(with: URL(string: image ?? "" ), placeholderImage:nil)
        
        let priceSting = String(format : "%@",dict!["price"] as? String ?? "")
        let priceDouble =  Double (priceSting)
        cell.wishPriceLable.text = String(format : "₹%.2f",priceDouble!)
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
                cell.wishattributeLabel.attributedText = attributeString
            }
        }
        cell.removeBtn.tag = indexPath.row
        cell.removeBtn.addTarget(self, action:#selector(removeBtnAction(_:)), for: UIControlEvents.touchUpInside)
        cell.moveCartBtn.tag = indexPath.row
        cell.moveCartBtn.addTarget(self, action:#selector(moveBtnAction(_:)), for: UIControlEvents.touchUpInside)
        
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let dict = self.wishlistArray[indexPath.row] as? NSDictionary
        let productID = dict![ "product_id"] as? String
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "ProductDetailVC") as? ProductDetailVC
        myVC?.productID = productID! as NSString
        self.navigationController?.pushViewController(myVC!, animated: false)
    }
    @objc func removeBtnAction (_ sender: UIButton)
    {
        let dict = self.wishlistArray[sender.tag] as? NSDictionary
        let productID = dict!["product_id"] as! String
        SKActivityIndicator.show("Loading...")
        let Url = String(format: "%@account/wishlist/removeWishList",Constants.BASEURL)
        
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
                            self.getWishList()
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
    @objc func moveBtnAction (_ sender: UIButton)
    {
        let dict = self.wishlistArray[sender.tag] as? NSDictionary
        let productID = dict!["product_id"] as! String
        SKActivityIndicator.show("Loading...")
        let Url = String(format: "%@account/wishlist/insertWishListToCart",Constants.BASEURL)
        
        print(Url)
        let userID =  UserDefaults.standard.string(forKey: "customer_id")
        let sessionID =  UserDefaults.standard.string(forKey: "api_token")
        let parameters: Parameters =
            [
                "customer_id" : userID ?? "",
                "product_id" : productID,
                "session_id" : sessionID ?? ""
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
                            self.getWishList()
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}




