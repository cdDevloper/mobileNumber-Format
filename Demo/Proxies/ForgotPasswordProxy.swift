//
//  ForgotPasswordProxy.swift
//  LYNKD
//
//  Created by Pavan Jadhav on 26/12/17.
//  Copyright © 2017 Magneto IT solutions Pvt Ltd. All rights reserved.
//

import Foundation
import Alamofire


class ForgotPasswordProxy: AbstractProxy {
    
    func forgotPassword(_ baseUrl: String,
                            postData: [String: AnyObject],
                            withSuccessHandler success: CompleteionHandler?,
                            withFailureHandlere failure: FailureHandler?) -> DataRequest? {
        
        self.completeionBlock = success
        self.failureBlock = failure
        
        return self.GET(baseUrl, postData: postData, requestName: RequestName.ForgotPassword)!
    }
    
    override func successCallback(_ response: AnyObject, headers: [AnyHashable : Any], requestName: String) {
        
        if requestName == RequestName.ForgotPassword {
            if let responseDict =  response as? [String: AnyObject] {
                if let success = self.completeionBlock {
                    success(responseDict)
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
