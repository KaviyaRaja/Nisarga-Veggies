//
//  NotificationVC.swift
//  Nisarga
//
//  Created by Hari Krish on 05/08/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import SKActivityIndicatorView

class NotificationVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var mTableView: UITableView!
    var notificationArray : NSArray = []
    var refreshControl = UIRefreshControl()
   
    override func viewDidLoad() {
        super.viewDidLoad()
         self.mTableView.register(UINib(nibName: "NotificationCell", bundle: .main), forCellReuseIdentifier: "NotificationCell")
        getNotification()
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: UIControlEvents.valueChanged)
        self.mTableView.addSubview(refreshControl)

        // Do any additional setup after loading the view.
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
    @objc func refresh(_ sender: AnyObject) {
        // Code to refresh table view
        getNotification()
        self.refreshControl.endRefreshing()
    }
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.notificationArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:NotificationCell =  mTableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as!NotificationCell
        
        cell.mBgView.layer.shadowColor = UIColor.gray.cgColor
        cell.mBgView.layer.shadowOffset = CGSize (width: 0, height: 3)
        cell.mBgView.layer.shadowOpacity = 0.6
        cell.mBgView.layer.shadowRadius = 3.0
        cell.mBgView.layer.cornerRadius = 5.0
        
        let dict = self.notificationArray[indexPath.row] as? NSDictionary
        cell.mDescriptionLabel.text = dict!["title"] as? String
        cell.mDateLabel.text = dict!["body"] as? String
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "EEEE HH:mm a"
        
        let date: NSDate? = dateFormatterGet.date(from: (dict![ "date"] as? String)!)! as NSDate
        print(dateFormatterPrint.string(from: date! as Date))
        cell.mDayLabel.text = String(format :"%@",dateFormatterPrint.string(from: date! as Date))
        
        return cell
        
    }
    
    // MARK:- API
    func getNotification()
    {
        SKActivityIndicator.show("Loading...")
        let Url = String(format: "%@api/custom/notificationList",Constants.BASEURL)
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
                        self.notificationArray = (JSON["data"] as? NSArray)!
                        self.mTableView.reloadData()
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
