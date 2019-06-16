//
//  Constants.swift
//  GreenBox POS
//
//  Created by Ahmad Ishfaq on 12/19/17.
//  Copyright © 2017 Ahmad Ishfaq. All rights reserved.
//

import UIKit

public struct Constants {
  
   public static let WeatherAppBaseURL = "https://api.darksky.net/"
   public static let liveURL = "http://vehiclesafety.co.in/whoopmehappy/V1.1/admin/public/"
  
    
   public struct webService {
    
//    #if DEMOAPP
//    public static let url = Constants.demoURL
//    #else
    public static let url = Constants.WeatherAppBaseURL
//    #endif
    
    // User Withdraw
    public static let forecast = Constants.webService.url +  "forecast/"
    
    }
    
    public struct API_Keys {
     
        //Address Search https://craftyclicks.co.uk/docs/global/#basic-configuration-options
        public static let AddressSearchKey = "a5d88-580fa-f7ff0-02703"
        
        //ipstack
        public static let FreeGeoIpStackKey = "01338f7e9d42c81ee7bfeb1a347ce3cd"
        
    }
}

