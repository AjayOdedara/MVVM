//
//  FriendsTableViewController.swift
//  Friends
//
//  Created by Jussi Suojanen on 07/11/16.
//  Copyright © 2016 Jimmy. All rights reserved.
//

import UIKit
import PKHUD

public class FriendsTableViewController: UITableViewController {

    let viewModel: FriendsTableViewViewModel = FriendsTableViewViewModel()

    public override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        viewModel.getFriends()
    }

    func bindViewModel() {
        print("bindAndFire Start")
        viewModel.friendCells.bindAndFire() { [weak self] _ in
            
            print("bindAndFire Compelete")
            self?.tableView?.reloadData()
            
        }

        print("onShowError Start")
        viewModel.onShowError = { [weak self] alert in
            print("onShowError Compelete")
            self?.presentSingleButtonDialog(alert: alert)
        }

        print("showLoadingHud Start")
        viewModel.showLoadingHud.bind() { [weak self] visible in
            if let `self` = self {
                print("showLoadingHud Compelete and HUD is \(visible)")
                PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView()
                visible ? PKHUD.sharedHUD.show(onView: self.view) : PKHUD.sharedHUD.hide()
            }
        }
    }

    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        

    }
}

// MARK: - UITableViewDelegate
extension FriendsTableViewController {

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.friendCells.value.count
    }

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch viewModel.friendCells.value[indexPath.row] {
        case .normal(let viewModel):
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell") as? FriendTableViewCell else {
                return UITableViewCell()
            }
            
            cell.viewModel = viewModel
            return cell
        case .error(let message):
            let cell = UITableViewCell()
            cell.isUserInteractionEnabled = false
            cell.textLabel?.text = message
            return cell
        case .empty:
            let cell = UITableViewCell()
            cell.isUserInteractionEnabled = false
            cell.textLabel?.text = "No data available"
            return cell
        }
    }

    public override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

   
}

extension FriendsTableViewController: SingleButtonDialogPresenter {
    
   
}
