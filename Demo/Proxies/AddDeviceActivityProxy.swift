//
//  AddDeviceActivityProxy.swift
//  LYNKD
//
//  Created by Pavan Jadhav on 08/12/17.
//  Copyright © 2017 Magneto IT solutions Pvt Ltd. All rights reserved.
//

import Foundation
import UIKit
import Alamofire


class AddDeviceActivityProxy: AbstractProxy {
    
    func addDeviceActivity(_ baseUrl: String,
                           postData: [String: AnyObject],
                           withSuccessHandler success: CompleteionHandler?,
                           withFailureHandlere failure: FailureHandler?) -> DataRequest? {
        
        self.completeionBlock = success
        self.failureBlock = failure
        
        return self.GET(baseUrl, postData: postData, requestName: RequestName.AddDeviceActivity)!
    }
    
    // Update WIFi Device Name
    func updateWifiDeviceName(_ baseUrl: String,
                              postData: [String: AnyObject],
                              withSuccessHandler success: CompleteionHandler?,
                              withFailureHandlere failure: FailureHandler?) -> DataRequest? {
        
        self.completeionBlock = success
        self.failureBlock = failure
        
        return self.GET(baseUrl, postData: postData, requestName: RequestName.UpdateDeviceName)!
    }
    
    //  Update Wifi Connection status API:
    func updateWifiConnectionStatus(_ baseUrl: String,
                                    postData: [String: AnyObject],
                                    withSuccessHandler success: CompleteionHandler?,
                                    withFailureHandlere failure: FailureHandler?) -> DataRequest? {
        self.completeionBlock = success
        self.failureBlock = failure
        return self.GET(baseUrl, postData: postData, requestName: RequestName.UpdateWifiConnectionStatus)!
    }
    
    //Update Key_code API:
    func updateKeyCode(_ baseUrl: String,
                                    postData: [String: AnyObject],
                                    withSuccessHandler success: CompleteionHandler?,
                                    withFailureHandlere failure: FailureHandler?) -> DataRequest? {
        self.completeionBlock = success
        self.failureBlock = failure
        return self.GET(baseUrl, postData: postData, requestName: RequestName.updateKeyCode)!
    }
   
    //Update Check_In_Interval API:
    func updateCheckInInterval(_ baseUrl: String,
                        postData: [String: AnyObject],
                        withSuccessHandler success: CompleteionHandler?,
                        withFailureHandlere failure: FailureHandler?) -> DataRequest? {
        self.completeionBlock = success
        self.failureBlock = failure
        return self.GET(baseUrl, postData: postData, requestName: RequestName.updateCheckininterval)!
    }
    
    func updateUserAccessLevel(_ baseUrl: String,
                               postData: [String: AnyObject],
                               withSuccessHandler success: CompleteionHandler?,
                               withFailureHandlere failure: FailureHandler?) -> DataRequest? {
        
        self.completeionBlock = success
        self.failureBlock = failure
        
        return self.GET(baseUrl, postData: postData, requestName: RequestName.UpdateUserAccessLevel)!
    }
    
    func updateAlarmSetting(_ baseUrl: String,
                            postData: [String: AnyObject],
                            withSuccessHandler success: CompleteionHandler?,
                            withFailureHandlere failure: FailureHandler?) -> DataRequest? {
        
        self.completeionBlock = success
        self.failureBlock = failure
        
        return self.POST(baseUrl, postData: postData, requestName: RequestName.UpdateAlarmSettings)!
    }
    
    func getListOfInviteUser(_ baseUrl: String,
                             postData: [String: AnyObject],
                             withSuccessHandler success: CompleteionHandler?,
                             withFailureHandlere failure: FailureHandler?) -> DataRequest? {
        
        self.completeionBlock = success
        self.failureBlock = failure
        
        return self.GET(baseUrl, postData: postData, requestName: RequestName.GetListOfInvitedUsers)!
    }
    
    override func successCallback(_ response: AnyObject, headers: [AnyHashable : Any], requestName: String) {
        
        if requestName == RequestName.GetListOfInvitedUsers {
            
            if let responseDict =  response as? [String: AnyObject] {
                if responseDict["status"] as? String == "1" {
                    
                    var invitedUsersList: [InvitedUserModel] = []
                    invitedUsersList = InvitedUserModel.getModelFromArray(responseDict["List"] as! [AnyObject])
                    
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
            
        } else if let responseDict =  response as? [String: AnyObject] {
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
    
    override func failureCallback(_ error: NSError, requestName: String) {
        
        if let failure = self.failureBlock {
            failure(error.localizedDescription)
        }
    }
}
