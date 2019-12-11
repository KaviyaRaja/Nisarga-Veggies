//
//  SearchVC.swift
//  Nisagra
//
//  Created by Hari Krish on 28/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import SKActivityIndicatorView

class SearchVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var mProfileImage: UIImageView!
    @IBOutlet weak var mTableView : UITableView!
    @IBOutlet weak var mSearchTF : UITextField!
    @IBOutlet weak var mEmptyView : UIView!
    var mSearchArray : NSArray = []
    
    var mProductID : String!
    override func viewDidLoad() {
        super.viewDidLoad()
        mTableView.register(UINib(nibName: "SearchCell", bundle: .main), forCellReuseIdentifier: "SearchCell")
        mEmptyView.isHidden = true
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        var dataDict : NSDictionary = [:]
        var data = UserDefaults.standard.object(forKey: "UserData") as? Data
        if let aData = data {
            dataDict = NSKeyedUnarchiver.unarchiveObject(with: aData) as! NSDictionary
            var image = dataDict["image"] as? String
            if(image != nil){
                if(image == "0")
                {
                    image = "http://3.213.33.73/Ecommerce/upload/image/backend/profile.png"
                }
                else
                {
                    image = image?.replacingOccurrences(of: " ", with: "%20")
                }
                self.mProfileImage.sd_setImage(with: URL(string: image!), placeholderImage: UIImage(named: "Rectangle"))
                self.mProfileImage.layer.cornerRadius = self.mProfileImage.frame.size.width/2
                self.mProfileImage.layer.masksToBounds = true
            }
        }
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
    @IBAction func notificationBtnAction(_ sender: UIButton)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "NotificationVC") as? NotificationVC
        self.navigationController?.pushViewController(myVC!, animated: true)
    }
    @IBAction func profileBtnAction(_ sender: UIButton)
    {
        
    }
    @IBAction func cartBtnAction(_ sender: UIButton)
    {
        
    }
    @IBAction func editingChanged(_ sender: Any)
    {
        getData()
    }
    
    // MARK: - TableView View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.mSearchArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:SearchCell =   self.mTableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! SearchCell
         let dict = self.mSearchArray[indexPath.row] as? NSDictionary
        var image = dict!["image"] as? String
        image = image?.replacingOccurrences(of: " ", with: "%20")
        cell.mTitleLabel.text = dict![ "name"] as? String
        cell.mImageView.sd_setImage(with: URL(string: image ?? "" ), placeholderImage:nil)
        
        return cell;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let dict = self.mSearchArray[indexPath.row] as? NSDictionary
        self.mProductID = dict![ "product_id"] as? String
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "ProductDetailVC") as? ProductDetailVC
        myVC?.productID = self.mProductID! as NSString
        self.navigationController?.pushViewController(myVC!, animated: false)
    }
    
    // MARK: - API
    func getData()
    {
        SKActivityIndicator.show("Loading...")
        let Url = String(format: "%@api/productsearch/productsearchIos",Constants.BASEURL)
        print(Url)
        let userID =  UserDefaults.standard.string(forKey: "customer_id")
        let parameters: Parameters =
        [
            "s" : mSearchTF .text ?? "",
            "customer_id" : "225"
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
                        self.mEmptyView.isHidden = true
                        self.mSearchArray = (JSON["result"] as? NSArray)!
                        self.mTableView.reloadData()
                    }
                    else
                    {
                        self.mEmptyView.isHidden = false
                    }
                }
                break
                
            case .failure(let error):
                print(error)
                break
                
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
