//
//  ViewController.swift
//  MVMV Practice
//
//  Created by ACME_MAC_SSD on 10/15/18.
//  Copyright © 2018 Acmeuniverse. All rights reserved.
//

import UIKit
import SwiftyJSON
import PKHUD

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var locationLabel: UILabel!
    
    
    // New Implementation
    let viewModel: WeatherViewModel = WeatherViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        locationLabel.text = "Weather for \(viewModel.coordinateString)"
        
        bindViewModel()
        viewModel.getWeatherDataResponse()
        
    }
    func bindViewModel() {
        
        
        viewModel.responseData.bindAndFire() { [weak self] _ in
            self?.tableView?.reloadData()
        }
        
        viewModel.onShowError = { [weak self] alert in
            self?.presentSingleButtonDialog(alert: alert)
        }
        
        viewModel.showLoadingHud.bind() { [weak self] visible in
            if let `self` = self {
                PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView()
                visible ? PKHUD.sharedHUD.show(onView: self.view) : PKHUD.sharedHUD.hide()
            }
        }
        
       
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "shareWithFriend",
            let destinationViewController = segue.destination as? RegisterViewController {
            destinationViewController.viewModel = RegisterUserViewModel()
            destinationViewController.updateList = { [weak self] in
                self?.tableView.reloadData()
//                self?.viewModel.getFriends()
            }
        }
    }
 
}

extension ViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.responseData.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewModel.cellInstance(tableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.tapCell(tableView, indexPath: indexPath)
    }
}

extension ViewController: SingleButtonDialogPresenter {
    
    
}


