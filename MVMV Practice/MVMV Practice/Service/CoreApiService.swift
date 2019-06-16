//
//  CoreApiService.swift
//  MVMV Practice
//
//  Created by ACME_MAC_SSD on 10/16/18.
//  Copyright © 2018 Acmeuniverse. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

public final class CoreApiAccess {
    
    //  *******|| APPLICATION --  Whoop  -- API ||********
    
    func coreAPIResponse(url: String, params:[String:Any]?,method:HTTPMethod, headers:[String:String], success: @escaping (JSON) -> Void, failure: ((NSError?) -> Void)?) -> Void {
        
        Alamofire.request(url,method:method, parameters:params, encoding: JSONEncoding.default, headers: headers).responseJSON{
            response in
            print(response.request ?? "Request is null")  // original URL request
            print(response.response ?? "Response is null") // URL response
            print(response.data ?? "Data is Null")     // server data
            print(response.result)
            
            switch response.result {
            case .success:
                print("Validation Successful")
                guard let json = response.result.value else {
                    return
                }
                success(JSON(json))
            case .failure(let error):
                
                failure?(error as NSError)
            }
        }
    }
    
    
    public  func getAPIResponse(url: String,  success: @escaping (Any?) -> Void, failure: ((NSError?) -> Void)?) -> Void {
        
        let requestURL: String = "\(url)"
        Alamofire.request(requestURL).responseJSON { (response) in
            switch response.result {
            case .success:
                guard let json = response.result.value else {
                    return
                }
               success(json)
            case .failure(let error):
                failure?(error as NSError)
                //self.delegate?.dataReceived(data: nil, error: error as NSError)
            }
        }
        
    }
    
    public func postAPIResponse(url: URL, parameter: [String: Any]?, success:@escaping (Any) -> Void, failure: ((NSError?) -> Void)?) -> Void {
        
        
        Alamofire.request(url, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            
            switch response.result {
            case .success:
                guard let json = response.result.value else {
                    return
                }
               success(json)
            case .failure(let error):
                failure?(error as NSError)
            }
        }
        
    }
    /*
    func postImageWithParameter(id:String, endUrl: String, imageData: Data?,fileName:String,fileType:String, success: @escaping (Any?) -> Void, failure: ((NSError?) -> Void)?) -> Void {//onCompletion: ((JSON?) -> Void)? = nil, onError: ((Error?) -> Void)? = nil){
        
        let url = endUrl /* your API url */
        
        let headers: HTTPHeaders = [
            /* "Authorization": "your_access_token",  in case you need authorization header */
            "Content-type": "multipart/form-data"
        ]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            multipartFormData.append("\(id)".data(using: String.Encoding.utf8)!, withName: "id")
            if let data = imageData{
                multipartFormData.append(data, withName: fileName, fileName: "\(Date().timeIntervalSince1970).\(fileType)", mimeType: "image/\(fileType)")
                //                multipartFormData.append(data, withName: "uploaded_file1", fileName: "imageUser.jpg", mimeType: "image/jpg")
            }
            
        }, usingThreshold: UInt64.init(), to: url, method: .post, headers: headers) { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    if let err = response.error{
                        failure?(err as NSError)
                        return
                    }
                    // On Completion
                    guard let json = response.result.value else {
                        return
                    }
                    let data = JSON(json)
                    if let dailyArray = data.dictionary {
                        let responseCode = dailyArray["Response"]!["ResponseCode"]
                        let responseMessage = dailyArray["Response"]!["ResponseMessage"]
                        if responseCode.string == "200"{
                            success(json)
                        }else{
                            guard let code = responseCode.string, let message = responseMessage.string else{
                                return failure!(NSError(domain: ApiErrorDomain, code: 999, userInfo: [NSLocalizedDescriptionKey:"Unexpected response from server"]))
                            }
                            failure?(NSError(domain: ApiErrorDomain, code: Int(code) ?? 999, userInfo: [NSLocalizedDescriptionKey:message]))
                        }
                        
                    }
                }
            case .failure(let error):
                failure?(error as NSError)
            }
        }
    }*/
    
}
