//
//  AppServerClient.swift
//  HomeWork
//
//  Created by Ajay Odedra on 04/04/19.
//  Copyright © 2019 Ajay Odedra. All rights reserved.
//

import Alamofire
import SwiftyJSON
// MARK: - AppServerClient
class AppServerClient {

    
    class var sharedInstance: AppServerClient {
        struct Static {
            static let instance: AppServerClient! = AppServerClient()
        }
        return Static.instance
    }
    
    func api(url:String, param:[String:Any]?,method:HTTPMethod, success: @escaping (JSON) -> Void, failure: ((NSError?) -> Void)?) -> Void {
        
        Alamofire.request(url, method: method, parameters: param, encoding: JSONEncoding.default)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    guard let json = response.result.value else {
                        return
                    }
                    let data = JSON(json)
                    success(data)
                case .failure(let error):
                    failure?(error as NSError)
                }
        }
    }
    
    
    
    
    
    
    
    
    
    
    // MARK: - GetFriends
    enum GetFailureReason: Int, Error {
        case unAuthorized = 401
        case notFound = 404
        case serverError = 500
    }

    
    typealias GetFriendsResult = Result<[Friend], GetFailureReason>
    typealias GetFriendsCompletion = (_ result: GetFriendsResult) -> Void

    func getFriends(completion: @escaping GetFriendsCompletion) {
        Alamofire.request("http://friendservice.herokuapp.com/listFriendss")
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    do {
                        guard let data = response.data else {
                            completion(.failure(nil))
                            return
                        }

                        let friends = try JSONDecoder().decode([Friend].self, from: data)
                        completion(.success(payload: friends))
                    } catch {
                        completion(.failure(nil))
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    if let statusCode = response.response?.statusCode,
                        let reason = GetFailureReason(rawValue: statusCode) {
                        completion(.failure(reason))
                    }
                    completion(.failure(nil))
                }
        }
    }

    
    //firstname: String, lastname: String, phonenumber: String
    //        let param = ["firstname": firstname,
    //                     "lastname": lastname,
    //                     "phonenumber": phonenumber]  "https://friendservice.herokuapp.com/addFriend"
    
    
//    typealias PostFriendResult = Result<JSON, GetFailureReason>
//    typealias FriendCompletion = (_ result: PostFriendResult) -> Void
    
    func apiCopy(url:String, param:[String:Any]?,method:HTTPMethod, success: @escaping (JSON) -> Void, failure: ((NSError?) -> Void)?) -> Void {

        Alamofire.request(url, method: method, parameters: param, encoding: JSONEncoding.default)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    guard let json = response.result.value else {
                        return
                    }
                    let data = JSON(json)
                    success(data)
                case .failure(let error):
                    failure?(error as NSError)
//                    if let statusCode = response.response?.statusCode,
//                        let reason = GetFailureReason(rawValue: statusCode) {
//                        completion(.failure(reason))
//                    }
//                    completion(.failure(nil))
                }
        }
    }
    
    


}
