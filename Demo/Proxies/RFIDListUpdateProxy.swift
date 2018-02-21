//
//  RFIDListUpdateProxy.swift
//  LYNKD
//
//  Created by Apple on 10/12/17.
//  Copyright © 2017 Magneto IT solutions Pvt Ltd. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

@objc protocol RFIDListUpdateProxyDelegate {
    func RFIDUpdateSuccess(response: [String: AnyObject])
    func RFIDUpdateFailed(error: String)
}


class RFIDListUpdateProxy: AbstractProxy {
    
    weak var delegate: RFIDListUpdateProxyDelegate?
    
    func updateRFIDList(_ postData: [String: AnyObject],
                       isImageSelected:Bool,
                       image: UIImage,
                       withSuccessHandler success: CompleteionHandler?,
                       withFailureHandlere failure: FailureHandler?) {
        
        let fileName = "profile_pic"
        self.completeionBlock = success
        self.failureBlock = failure
        Print.Log.info("Input: \(postData)")
        return self.requestPostURLForUploadImage(URLConstant.BaseUrl + URLConstant.UpdateRFIDList, isImageSelect: isImageSelected, fileName: fileName, params: postData, image: image, successHandler: { (_, response) in
            
            if self.delegate != nil {
                self.delegate?.RFIDUpdateSuccess(response: response)
            }
            
        }, failureHandler: { (false, error) in
            self.delegate?.RFIDUpdateFailed(error: error)
        })
        
    }
}

/*

class RFIDListUpdateProxy: AbstractProxy {
    
    func updateRFIDList(_ baseUrl: String,
                           postData: [String: AnyObject],
                           withSuccessHandler success: CompleteionHandler?,
                           withFailureHandlere failure: FailureHandler?) -> DataRequest? {
        
        self.completeionBlock = success
        self.failureBlock = failure
        return self.GET(baseUrl, postData: postData, requestName: RequestName.UpdateRFIDList)!
    }
    
    override func successCallback(_ response: AnyObject, headers: [AnyHashable : Any], requestName: String) {
        
        if requestName == RequestName.UpdateRFIDList {
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
*/
