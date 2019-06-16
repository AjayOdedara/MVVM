//
//  WebService.swift
//  MVMV Practice
//
//  Created by ACME_MAC_SSD on 10/16/18.
//  Copyright © 2018 Acmeuniverse. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol NetworkManagerDelegate {
    func weatherDataReceived(data: Any?, error: NSError?)
}

class NetworkManager {
    
    class var sharedInstance: NetworkManager {
        struct Static {
            static let instance: NetworkManager! = NetworkManager()
        }
        return Static.instance
    }
    
    lazy private var api:CoreApiAccess = {
        let theApi = CoreApiAccess()
        return theApi
    }()
    
    init() {
        print("Init the Singleton!")
    }
    
    var delegate: NetworkManagerDelegate?
  
    public func getList(param: String){
        
        guard let path = Bundle.main.path(forResource: "keys_template", ofType: "plist"),
            let keys = NSDictionary(contentsOfFile: path),
            let apiKey = keys["apiKey"] as? String else {
                print("Issue with keys.plist")
                return
        }
        api.coreAPIResponse(url: Constants.webService.forecast + apiKey + "/" + param, params: nil, method: .get, headers: [:], success: { (response) in
            let data = JSON(response)
            self.delegate?.weatherDataReceived(data: data, error: nil)
        }) { (error) in
            self.delegate?.weatherDataReceived(data: nil, error: error)
        }
        
    }
}

