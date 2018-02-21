//
//  UserProxy.swift
//  LYNKD
//
//  Created by Ashish Chaudhary on 11/30/17.
//  Copyright © 2017 Magneto IT solutions Pvt Ltd. All rights reserved.
//

import UIKit
import Alamofire

class UserProxy: AbstractProxy {
    
    func loginUser(_ baseUrl: String,
                   postData: [String: AnyObject],
                   withSuccessHandler success: CompleteionHandler?,
                   withFailureHandlere failure: FailureHandler?) -> DataRequest? {
        
        self.completeionBlock = success
        self.failureBlock = failure
        
        return self.GET(baseUrl, postData: postData, requestName: RequestName.LoginUser)!
    }
    
    override func successCallback(_ response: AnyObject, headers: [AnyHashable : Any], requestName: String) {
        
        if requestName == RequestName.LoginUser {
            if let responseDict =  response as? [String: AnyObject] {
                
                if responseDict["status"] as? String == "1" {
                    
                    var userModel: UserModel = UserModel.initializeUserModel()
                    userModel = UserModel.getModelFromDictionary(responseDict)
                    if let success = self.completeionBlock {
                        success(userModel)
                    }
                    
                } else {
                        let message  = responseDict["message"] as? String
                        if let failure = self.failureBlock {
                            failure(message!)
                        }
                }
            }
        }
    }

    override func failureCallback(_ error: NSError, requestName: String) {
        if let failure = self.failureBlock {
            failure(error.localizedDescription)
        }
    }
}
