//
//  FriendTableViewCell.swift
//  HomeWork
//
//  Created by Ajay Odedra on 03/04/19.
//  Copyright © 2019 Ajay Odedra. All rights reserved.
//

import UIKit

class FriendTableViewCell: UITableViewCell {

    @IBOutlet weak var labelFullName: UILabel!
    @IBOutlet weak var labelPhoneNumber: UILabel!

    var viewModel: FriendCellViewModel? {
        didSet {
            bindViewModel()
        }
    }

    private func bindViewModel() {
        labelFullName?.text = viewModel?.fullName
        labelPhoneNumber?.text = viewModel?.phonenumberText
    }
}

