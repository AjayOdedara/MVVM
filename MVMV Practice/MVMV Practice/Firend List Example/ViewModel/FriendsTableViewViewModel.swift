//
//  FriendsTableViewViewModel.swift
//  Friends
//
//  Created by Jussi Suojanen on 11/11/16.
//  Copyright © 2016 Jimmy. All rights reserved.
//

class FriendsTableViewViewModel {

    enum FriendTableViewCellType {
        case normal(cellViewModel: FriendCellViewModel)
        case error(message: String)
        case empty
    }

    var onShowError: ((_ alert: SingleButtonAlert) -> Void)?
    let showLoadingHud: Bindable = Bindable(false)

    let friendCells = Bindable([FriendTableViewCellType]())
    
    
    // API INIT
    let appServerClient: AppServerClient

    init(appServerClient: AppServerClient = AppServerClient()) {
        self.appServerClient = appServerClient
    }

    func getFriends() {
        showLoadingHud.value = true
        appServerClient.getFriends(completion: { [weak self] result in
            self?.showLoadingHud.value = false
            switch result {
            case .success(let friends):
                guard friends.count > 0 else {
                    self?.friendCells.value = [.empty]
                    return
                }
                self?.friendCells.value = friends.compactMap {
                    .normal(cellViewModel: $0 as FriendCellViewModel)
                }
            case .failure(let error):
                self?.friendCells.value = [.error(message: error?.localizedDescription ?? "Loading failed, check network connection")]
            }
        })
    }

    func getWeatherData() {
        showLoadingHud.value = true
    }
   
}
