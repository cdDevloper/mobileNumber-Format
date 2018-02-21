//
//  DeviceListProxy.swift
//  LYNKD
//
//  Created by Pro Retina on 29/12/17.
//  Copyright © 2017 Magneto IT solutions Pvt Ltd. All rights reserved.
//

import Foundation
import UIKit
import Alamofire


class DeviceListProxy: AbstractProxy {
    
    func getDeviceList(_ baseUrl: String,
                           postData: [String: AnyObject],
                           withSuccessHandler success: CompleteionHandler?,
                           withFailureHandlere failure: FailureHandler?) -> DataRequest? {
        
        self.completeionBlock = success
        self.failureBlock = failure
        
        return self.GET(baseUrl, postData: postData, requestName: RequestName.GetDeviceList)!
}
    
    override func successCallback(_ response: AnyObject, headers: [AnyHashable : Any], requestName: String) {
        
        if requestName == RequestName.GetDeviceList {
            if let responseDict =  response as? [String: AnyObject] {
                if responseDict["status"] as? String == "1" {
                    var invitedUsersList: [DeviceListModel] = []
                    invitedUsersList = DeviceListModel.getModelFromArray(responseDict["Device_list"] as! [AnyObject])
                    if let success = self.completeionBlock {
                        success(invitedUsersList)
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
    
}
