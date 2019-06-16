//
//  WeatherViewModel.swift
//  swift-mvvm
//
//  Created by Taylor Guidon on 11/30/16.
//  Copyright © 2016 ISL. All rights reserved.
//

import Foundation
import SwiftyJSON

class WeatherViewModel {
    
    enum WeatherCellData {
        case normal(modelData: [WeatherData])
        case error(message: String)
    }
    
    let reuseIdentifier = "WeatherCell"
    let coordinateString: String = "38.914504,-77.021181"
    
    var onShowError: ((_ alert: SingleButtonAlert) -> Void)?
    let showLoadingHud: Bindable = Bindable(false)

    var responseData = Bindable([WeatherData]())
    
    // API INIT
    let appServerClient = AppServerClient.sharedInstance

    func getWeatherDataResponse() {
        
        showLoadingHud.value = true
        
        guard let path = Bundle.main.path(forResource: "keys_template", ofType: "plist"),
            let keys = NSDictionary(contentsOfFile: path),
            let apiKey = keys["apiKey"] as? String else {
                print("Issue with keys.plist")
                let alert = SingleButtonAlert(title: "Error", message: "Issue with keys.plist", action: AlertAction(buttonTitle: "Ok", handler: {
                    print("Alert action clicked")
                }))
                self.showLoadingHud.value = false
                self.onShowError?(alert)
                return
        }

        appServerClient.api(url: Constants.webService.forecast + apiKey + "/" + coordinateString , param: nil, method: .get, success: { (response) in
            self.showLoadingHud.value = false
            let json = JSON(response)
            self.responseData.value = Weather(json).weatherData
        }) { ( error) in
            let alert = SingleButtonAlert(title: "Error", message: error?.localizedDescription ??  "Loading failed, check network connection", action: AlertAction(buttonTitle: "Ok", handler: {
                print("Alert action clicked")
            }))
            self.onShowError?(alert)
        }
        
    }

    func cellInstance(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! WeatherTableViewCell
        cell.setup(self.responseData.value[indexPath.row])
        return cell
    }
    
    func tapCell(_ tableView: UITableView, indexPath: IndexPath) {
        print("Tapped a cell")
    }
}
