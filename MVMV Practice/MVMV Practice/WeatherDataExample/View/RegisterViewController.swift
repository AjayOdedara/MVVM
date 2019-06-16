//
//  RegisterViewController.swift
//  MVMV Practice
//
//  Created by ACME_MAC_SSD on 10/27/18.
//  Copyright © 2018 Acmeuniverse. All rights reserved.
//

import UIKit
import PKHUD

class RegisterViewController: UIViewController {

    @IBOutlet var textFiledFirstname: UITextField!{
        didSet{
            textFiledFirstname.delegate = self
            textFiledFirstname.addTarget(self, action:
                #selector(firstnameTextFieldDidChange),
                                         for: .editingChanged)
        }
    }
    @IBOutlet var textFiledLastname: UITextField!
        {
        didSet{
            textFiledLastname.delegate = self
            textFiledLastname.addTarget(self, action:
                #selector(lastnameTextFieldDidChange),
                                        for: .editingChanged)
        }
    }
    @IBOutlet var textFieldEmail: UITextField!
        {
        didSet{
            textFieldEmail.delegate = self
            textFieldEmail.addTarget(self, action:
                #selector(emailAddressTextFieldDidChange),
                                        for: .editingChanged)
        }
    }
    @IBOutlet var textFiledPhonenumber: UITextField!
        {
        didSet{
            textFiledPhonenumber.delegate = self
            textFiledPhonenumber.addTarget(self, action:
                #selector(phoneNumberTextFieldDidChange),
                                        for: .editingChanged)
        }
    }
    @IBOutlet weak var buttonSubmit: UIButton!
    
    var updateList: (() -> Void)?
    var viewModel: RegisterViewModel?
    
    fileprivate var activeTextField: UITextField?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
        // Do any additional setup after loading the view.
    }
    
    @objc
    func firstnameTextFieldDidChange(textField: UITextField){
        viewModel?.firstname = textField.text ?? ""
    }
    
    @objc
    func lastnameTextFieldDidChange(textField: UITextField){
        viewModel?.lastname = textField.text ?? ""
    }
    
    @objc
    func phoneNumberTextFieldDidChange(textField: UITextField){
        viewModel?.phonenumber = textField.text ?? ""
    }
    
    @objc
    func emailAddressTextFieldDidChange(textField: UITextField){
        viewModel?.email = textField.text ?? ""
    }
    
    func bindViewModel() {
        title = viewModel?.title
        textFiledFirstname.text = viewModel?.firstname
        textFieldEmail.text = viewModel?.email
        textFiledLastname.text = viewModel?.lastname
        textFiledPhonenumber.text = viewModel?.phonenumber
        
        viewModel?.showLoadingHud.bind({ [weak self] visible in
            if let `self` = self{
                PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView()
                visible ? PKHUD.sharedHUD.show(onView: self.view) : PKHUD.sharedHUD.hide()
            }
        })
        
        viewModel?.updateSubmitButtonState = { [weak self] state in
            self?.buttonSubmit.isEnabled = state
        }
        
        viewModel?.navigateBack = {[weak self] in
            self?.updateList?()
            let _ = self?.navigationController?.popViewController(animated: true)
        }
        
        viewModel?.onShowError = { [weak self] alert in
            self?.presentSingleButtonDialog(alert: alert)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

// MARK: - Actions
extension RegisterViewController {
    @IBAction func rootViewTapped(_ sender: Any) {
        activeTextField?.resignFirstResponder()
    }
    @IBAction func submitButtonTapped(_ sender: Any) {
        viewModel?.submitUser()
    }
}


// MARK: - UITextFieldDelegate
extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField = nil
    }
}

extension RegisterViewController: SingleButtonDialogPresenter { }
