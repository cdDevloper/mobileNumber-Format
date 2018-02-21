//
//  GetKeycodeProxy.swift
//  LYNKD
//
//  Created by Pavan Jadhav on 01/01/18.
//  Copyright © 2018 Magneto IT solutions Pvt Ltd. All rights reserved.
//

import Foundation
import Alamofire


class GetKeycodeProxy: AbstractProxy {
    
    func getKeycodeProxy(_ baseUrl: String,
                        postData: [String: AnyObject],
                        withSuccessHandler success: CompleteionHandler?,
                        withFailureHandlere failure: FailureHandler?) -> DataRequest? {
        
        self.completeionBlock = success
        self.failureBlock = failure
        
        return self.GET(baseUrl, postData: postData, requestName: RequestName.getKeycode)!
    }
    
    func getLedTimeOut(_ baseUrl: String,
                         postData: [String: AnyObject],
                         withSuccessHandler success: CompleteionHandler?,
                         withFailureHandlere failure: FailureHandler?) -> DataRequest? {
        
        self.completeionBlock = success
        self.failureBlock = failure
        
        return self.GET(baseUrl, postData: postData, requestName: RequestName.setLedTimeOut)!
    }
    
    func setAutoLockTime(_ baseUrl: String,
                         postData: [String: AnyObject],
                         withSuccessHandler success: CompleteionHandler?,
                         withFailureHandlere failure: FailureHandler?) -> DataRequest? {
        
        self.completeionBlock = success
        self.failureBlock = failure
        
        return self.GET(baseUrl, postData: postData, requestName: RequestName.setAutoLockTime)!
    }
    
    override func successCallback(_ response: AnyObject, headers: [AnyHashable : Any], requestName: String) {
        
            if let responseDict =  response as? [String: AnyObject] {
                if let success = self.completeionBlock {
                    success(responseDict)
                }
            }
    }
    
    override func failureCallback(_ error: NSError, requestName: String) {
        
        if let failure = self.failureBlock {
            failure(error.localizedDescription)
        }
    }
}
