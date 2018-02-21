//
//  AccessCodeProxy.swift
//  LYNKD
//
//  Created by Apple on 01/12/17.
//  Copyright © 2017 Magneto IT solutions Pvt Ltd. All rights reserved.
//

import Foundation

import UIKit
import Alamofire


class AccessCodeProxy: AbstractProxy {
    
    func accessCodeCheck(_ baseUrl: String,
                     postData: [String: AnyObject],
                     withSuccessHandler success: CompleteionHandler?,
                     withFailureHandlere failure: FailureHandler?) -> DataRequest? {
        
        self.completeionBlock = success
        self.failureBlock = failure
        
        return self.GET(baseUrl, postData: postData, requestName: RequestName.AccessCodeCheck)!
    }
    
    override func successCallback(_ response: AnyObject, headers: [AnyHashable : Any], requestName: String) {
        
        if requestName == RequestName.AccessCodeCheck {
            if let responseDict =  response as? [String: AnyObject] {
                if responseDict["status"] as? String == "1" {
                    if let success = self.completeionBlock {
                        var accessCodeModel: AccessCodeVerifyModel = AccessCodeVerifyModel.initializeAccessCodeVerifyModel()
                        accessCodeModel = AccessCodeVerifyModel.getModelFromDictionary(responseDict)
                        if let success = self.completeionBlock {
                            success(accessCodeModel)
                        }
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
