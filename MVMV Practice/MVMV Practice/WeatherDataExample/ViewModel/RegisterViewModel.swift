//
//  RegisterViewModel.swift
//  MVMV Practice
//
//  Created by ACME_MAC_SSD on 10/27/18.
//  Copyright © 2018 Acmeuniverse. All rights reserved.
//

import Foundation

protocol RegisterViewModel{
    
    var title: String{ get }
    var firstname: String? { get set }
    var lastname: String? { get set }
    var phonenumber: String? { get set }
    var email: String? { get set }
    
    var showLoadingHud: Bindable<Bool> { get }
    var updateSubmitButtonState: ((Bool) -> ())? { get set }
    var navigateBack: (() -> ())?  { get set }
    var onShowError: ((_ alert: SingleButtonAlert) -> Void)?  { get set }
    func submitUser()
    
}

final class RegisterUserViewModel: RegisterViewModel {
    
    var title: String{
        return "Register User"
    }
    var firstname: String? {
        didSet {
            validateInput()
        }
    }
    var lastname: String? {
        didSet {
            validateInput()
        }
    }
    var phonenumber: String? {
        didSet {
            validateInput()
        }
    }
    var email: String? {
        didSet {
            validateInput()
        }
    }
    
    var updateSubmitButtonState: ((Bool) -> ())?
    
    var navigateBack: (() -> ())?
    var onShowError: ((_ alert: SingleButtonAlert) -> Void)?
    let showLoadingHud: Bindable = Bindable(false)

    
    private var validInputData: Bool = false {
        didSet {
            if oldValue != validInputData {
                updateSubmitButtonState?(validInputData)
            }
        }
    }
    //Web Call
    func submitUser() {
        
        guard let firstname = firstname,
            let lastname = lastname,
            let phonenumber = phonenumber,
            let email = email else {
                let okAlert = SingleButtonAlert(
                    title: "Could not connect to server. Check your network and try again later.",
                    message: "Could not Register User.",
                    action: AlertAction(buttonTitle: "OK", handler: { print("Ok pressed!") })
                )
                self.onShowError?(okAlert)
                return
        }

        updateSubmitButtonState?(false)
        showLoadingHud.value = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {[weak self] in
            self?.showLoadingHud.value = false
            self?.updateSubmitButtonState?(true)
            self?.navigateBack?()
            
        })
        
        print("\(firstname) \(lastname) \n\(phonenumber)\n Added User")
    }
    
    // Validations
    func validateInput() {
        let validData = [firstname, lastname, phonenumber, email].filter {
            ($0?.count ?? 0) < 1
        }
        validInputData = (validData.count == 0) ? true : false
    }

}
