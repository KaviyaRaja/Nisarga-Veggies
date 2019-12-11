//
//  SingletonClass.swift
//  Dhukan
//
//  Created by Suganya on 7/18/18.
//  Copyright © 2018 Suganya. All rights reserved.
//

import Foundation
import UIKit

class SingletonClass: NSObject {
    
    // MARK: Find height
    var mSessionId : String = ""
    
    static let sharedInstance:SingletonClass = {
        let instance = SingletonClass()
        return instance
    }()
    
    override init() {
        super.init()
    }
    func heightForLabel(text:String, font:UIFont, width:CGFloat) -> CGFloat
    {
        if(text == "")
        {
            return 21
        }
        
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        
        if(label.frame.height < 30)
        {
            return label.frame.height + 10
        }
        return label.frame.height
        
    }
    func generateSessionId(){
        let randstr = randomString(withLength: 24)
        
        let formatter = DateFormatter()
        let formatString = "yyyyMMddHHmmssSSS"
        formatter.dateFormat = formatString
        var datestr = formatter.string(from: Date())
        
        mSessionId = "\(randstr ?? "")_\(datestr)"
        print("self.mSessionId = \(mSessionId)")

         // UserDefaults.standard.string(forKey: "mSessionId")
         UserDefaults.standard.setValue(mSessionId as? String, forKey: "SessionId")
    }
    func randomString(withLength len: Int) -> String? {
        /*let alphabet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXZY0123456789"
        var s = String(repeating: "\0", count: 20)
        for i in 0..<20 {
            let r = UInt32(Int(arc4random()) % alphabet.count)
            let c = unichar(alphabet[alphabet.index(alphabet.startIndex, offsetBy:String.IndexDistance(UInt(r)))])
           // alphabet.startIndex, offsetBy: String.IndexDistance(UInt(r))
            s += "\(c)"
        }
        return s*/
        let letters : NSString = "0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< len {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
}

