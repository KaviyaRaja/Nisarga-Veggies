//
//  CategoriesVC.swift
//  ECommerce
//
//  Created by Apple on 11/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import SKActivityIndicatorView

class CategoriesVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var categoriesTableView: UITableView!
    
    var mExpandArray : NSMutableArray = []
    var namesArray : NSMutableArray = ["Green Leaves","Sprouts","English Item","Other Veggies"]
    var imagesArray : NSMutableArray = ["greenLeaves","sprouts","EnglishItem","OtherVeggiez"]
    var categoryArray : NSArray = []
    @IBOutlet weak var profileImage : UIImageView!
     @IBOutlet weak var mCartCountLabel : CustomFontLabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mCartCountLabel.layer.cornerRadius = self.mCartCountLabel.frame.size.width/2
        self.mCartCountLabel.layer.masksToBounds = true
        self.categoriesTableView.register(UINib(nibName: "CategoriesTableViewCell", bundle: nil), forCellReuseIdentifier: "CategoriesTableViewCell")
        getData()
        getCartCount()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
    // MARK: - API
    func getData()
    {
        SKActivityIndicator.show("Loading...")
        let Url = String(format: "%@api/productcategory/categoryinproduct",Constants.BASEURL)
        print(Url)
        let userID =  UserDefaults.standard.string(forKey: "customer_id")
        let headers: HTTPHeaders =
        [
            "Content-Type": "application/json"
        ]
        let parameters: Parameters =
        [
            "customer_id" : userID ?? "",
        ]
        print(parameters)
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
                        self.categoryArray = (JSON["result"] as? NSArray)!
                        self.categoriesTableView.reloadData()
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
   
    @IBAction func notificationBtnAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "NotificationVC") as? NotificationVC
        self.navigationController?.pushViewController(myVC!, animated: true)
    }
    
    // MARK: - TableView Delegates
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return self.categoryArray.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if mExpandArray.contains(section)
        {
            let dict = self.categoryArray[section] as? NSDictionary
            var subCategoryArray : NSArray = []
            if (dict!["product_data"] != nil) {
                subCategoryArray = (dict!["product_data"] as? NSArray)!
                return subCategoryArray.count
            }
            else{
                return 0
            }
        }
        else
        {
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let pcell = tableView.dequeueReusableCell(withIdentifier: "CategoriesTableViewCell", for: indexPath) as! CategoriesTableViewCell
        pcell.selectionStyle = .none
        let dict = self.categoryArray[indexPath.section] as? NSDictionary
        var subCategoryArray : NSArray = []
        if (dict!["product_data"] != nil) {
            subCategoryArray = (dict!["product_data"] as? NSArray)!
            let subCategoryDict = subCategoryArray[indexPath.row] as? NSDictionary
            pcell.CategoriesLabel.text = subCategoryDict!["product_name"] as? String
        }
        return pcell;
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerView = UIView(frame:CGRect (x: 0, y: 15, width:tableView.frame.size.width - 30, height:70))
        headerView.backgroundColor = UIColor.clear
        headerView.layer.cornerRadius = 5
        
        let dict = self.categoryArray[section] as! NSDictionary
        
        let bgLabel = UILabel(frame : CGRect (x: 5, y: 0, width:tableView.frame.size.width - 10, height:60))
        bgLabel.text = ""
        bgLabel.backgroundColor = UIColor.groupTableViewBackground
        headerView.addSubview(bgLabel)
        let  categoriesImages = UIImageView(frame : CGRect (x: 20, y: headerView.frame.size.height/2 - 10, width:20, height:20))
        var image = dict["category_image"] as? String
        if(image != nil){
            image = image?.replacingOccurrences(of: " ", with: "%20")
            categoriesImages.sd_setImage(with: URL(string: image!), placeholderImage: UIImage(named: "placeholder"))
        }
        //categoriesImages.image = UIImage(named: dict["category_image"] as! String)
        categoriesImages.contentMode = .scaleAspectFit
        headerView.addSubview(categoriesImages)
        
        
        let Label = CustomFontLabel(frame : CGRect (x: 70, y: 0, width:tableView.frame.size.width - 50, height:70))
        Label.text = dict["category_name"] as! String
        Label.font = UIFont (name: "Roboto", size: 15)
        headerView.addSubview(Label)
        
        let categoriesDropdownImages = UIImageView(frame : CGRect (x: headerView.frame.size.width - 15, y: 25, width:15, height:15))
        categoriesDropdownImages.image = UIImage(named: "down-arrow")
        headerView.addSubview(categoriesDropdownImages)
        categoriesDropdownImages.contentMode = .scaleAspectFit
        if mExpandArray.contains(section)
        {
            categoriesDropdownImages.image = UIImage(named : "up-arrow")
        }
        let button = UIButton(frame : CGRect (x: 0, y: 0, width:tableView.frame.size.width, height:60))
        
        button.setTitle("", for: [])
        button.tag = section
        button.addTarget(self, action:#selector(expandBtnAction(_:)), for: UIControlEvents.touchUpInside)
        headerView.addSubview(button)
        
        return headerView;
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 70
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 44
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        var mProductID : String!
        let dict = self.categoryArray[indexPath.section] as? NSDictionary
        var subCategoryArray : NSArray = []
        if (dict!["product_data"] != nil) {
            subCategoryArray = (dict!["product_data"] as? NSArray)!
            let subCategoryDict = subCategoryArray[indexPath.row] as? NSDictionary
            mProductID = subCategoryDict![ "product_id"] as? String
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "ProductDetailVC") as? ProductDetailVC
        myVC?.productID = mProductID! as NSString
        self.navigationController?.pushViewController(myVC!, animated: false)
    }
    
    @objc func expandBtnAction (_ sender: UIButton)
    {
        let tag : Int = sender.tag
        
        if self.mExpandArray .contains(tag)
        {
            self.mExpandArray .remove(tag)
        }
        else
        {
            self.mExpandArray.add(tag)
        }
        let range = NSRange(location: tag, length: 1)
        let section = NSIndexSet(indexesIn: range)
        self.categoriesTableView.reloadSections(section as IndexSet, with: .fade)
    }
}


