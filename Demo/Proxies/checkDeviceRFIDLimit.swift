//
//  checkDeviceRFIDLimit.swift
//  LYNKD
//
//  Created by Pavan Jadhav on 21/02/18.
//  Copyright © 2018 Magneto IT solutions Pvt Ltd. All rights reserved.
//

import Foundation
import Foundation
import UIKit
import Alamofire


class CheckDeviceRFIDLimit: AbstractProxy {
    
    func checkDeviceRFIDLimit(_ baseUrl: String,
                                 postData: [String: AnyObject],
                                 withSuccessHandler success: CompleteionHandler?,
                                 withFailureHandlere failure: FailureHandler?) -> DataRequest? {
        
        self.completeionBlock = success
        self.failureBlock = failure
        
        return self.GET(baseUrl, postData: postData, requestName: RequestName.getmasterdevices)!
    }
    
    override func successCallback(_ response: AnyObject, headers: [AnyHashable : Any], requestName: String) {
        
        if requestName == RequestName.getmasterdevices {
            if let responseDict =  response as? [String: AnyObject] {
                if responseDict["status"] as? String == "1" {
                    if let success = self.completeionBlock {
                        success(responseDict)
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
