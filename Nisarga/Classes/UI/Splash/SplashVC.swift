//
//  SplashVC.swift
//  Nisarga
//
//  Created by Hari Krish on 12/08/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import UIKit
import FLAnimatedImage

class SplashVC: UIViewController {

    @IBOutlet weak var gifView: FLAnimatedImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

         // Do any additional setup after loading the view.
        
        if let path =  Bundle.main.path(forResource: "NisargaLogo1", ofType: "gif") {
            if let data = NSData(contentsOfFile: path) {
                let gif = FLAnimatedImage(animatedGIFData: data as Data!)
                gifView.animatedImage = gif
                gifView.animationRepeatCount = 3
            }
        }
        let gifImage = UIImage.gifImageWithName("NisargaLogo")
        
        let imageView = UIImageView(image: gifImage)
        imageView.frame = CGRect(x: 0, y: 0, width: Constants.SCREEN_WIDTH, height: Constants.SCREEN_HEIGHT)
       // self.view.addSubview(imageView)
        perform(#selector(proceed), with: nil, afterDelay: 4.5)
    }
    @objc func proceed()
    {
         let isLoggedin =  UserDefaults.standard.string(forKey: "isLoggedin")
         if(isLoggedin == "1")
         {
            Constants.appDelegate?.moveToHome()
         }
         else{
            Constants.appDelegate?.moveToLogin()
         }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
