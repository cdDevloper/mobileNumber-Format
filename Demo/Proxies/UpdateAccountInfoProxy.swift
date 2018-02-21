//
//  UpdateAccountInfoProxy.swift
//  LYNKD
//
//  Created by Pavan Jadhav on 19/12/17.
//  Copyright © 2017 Magneto IT solutions Pvt Ltd. All rights reserved.
//

import Foundation
import Alamofire

@objc protocol UpdateAccountInfoProxyDelegate {
    func UpdateAccountInfoSuccessful(response: [String: AnyObject])
    func UpdateAccountInfoFailed(error: String)
}

class UpdateAccountInfoProxy: AbstractProxy {
    
    weak var delegate: UpdateAccountInfoProxyDelegate?
    
    func updateAccountInfo(_ postData: [String: AnyObject],
                       isImageSelected:Bool,
                       image: UIImage,
                       withSuccessHandler success: CompleteionHandler?,
                       withFailureHandlere failure: FailureHandler?) {
        
        let fileName = "account_image"
        self.completeionBlock = success
        self.failureBlock = failure
        Print.Log.info("Input: \(postData)")
        return self.requestPostURLForUploadImage(URLConstant.BaseUrl + URLConstant.UpdateAccountInfo, isImageSelect: isImageSelected, fileName: fileName, params: postData, image: image, successHandler: { (_, response) in
            
            if self.delegate != nil {
                self.delegate?.UpdateAccountInfoSuccessful(response: response)
            }
            
        }, failureHandler: { (false, error) in
            self.delegate?.UpdateAccountInfoFailed(error: error)
        })
        
    }
}
