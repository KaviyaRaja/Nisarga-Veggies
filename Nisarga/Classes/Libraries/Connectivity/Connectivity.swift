//
//  Connectivity.swift
//  ORBIIT
//
//  Created by Suganya on 6/25/18.
//  Copyright © 2018 sidemenutest. All rights reserved.
//

import Foundation
import Alamofire

class Connectivity {
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
