//
//  SignUpProxy.swift
//  LYNKD
//
//  Created by Ashish Chaudhary on 11/29/17.
//  Copyright © 2017 Magneto IT solutions Pvt Ltd. All rights reserved.
//

import UIKit
import Alamofire

@objc protocol SignUpProxyDelegate {
    func signUpSuccessful(response: [String: AnyObject])
    func signUpFailed(error: String)
}

class SignUpProxy: AbstractProxy {
    
    weak var delegate: SignUpProxyDelegate?
    
    func signUpRequest(_ postData: [String: AnyObject],
                       isImageSelected:Bool,
                       image: UIImage,
                       withSuccessHandler success: CompleteionHandler?,
                       withFailureHandlere failure: FailureHandler?) {
        
        let fileName = "profile_pic"
        self.completeionBlock = success
        self.failureBlock = failure
        Print.Log.info("Input: \(postData)")
        print("URl\(URLConstant.BaseUrl + URLConstant.SignUp)")
        return self.requestPostURLForUploadImage(URLConstant.BaseUrl + URLConstant.SignUp, isImageSelect: isImageSelected, fileName: fileName, params: postData, image: image, successHandler: { (_, response) in
            
            if self.delegate != nil {
                self.delegate?.signUpSuccessful(response: response)
            }
            
        }, failureHandler: { (false, error) in
            self.delegate?.signUpFailed(error: error)
        })
        
    }
    
    func updatePortalAccInfoRequest(_ postData: [String: AnyObject],
                       isImageSelected:Bool,
                       image: UIImage,
                       withSuccessHandler success: CompleteionHandler?,
                       withFailureHandlere failure: FailureHandler?) {
        
        let fileName = "portal_account_image"
        self.completeionBlock = success
        self.failureBlock = failure
        Print.Log.info("Input: \(postData)")
        print("URl\(URLConstant.BaseUrl + URLConstant.PortalAccountInfo)")
        return self.requestPostURLForUploadImage(URLConstant.BaseUrl + URLConstant.PortalAccountInfo, isImageSelect: isImageSelected, fileName: fileName, params: postData, image: image, successHandler: { (_, response) in
            
            if self.delegate != nil {
                self.delegate?.signUpSuccessful(response: response)
            }
            
        }, failureHandler: { (false, error) in
            self.delegate?.signUpFailed(error: error)
        })
        
    }
    
    func getPlanDetails(_ baseUrl: String,
                        postData: [String: AnyObject],
                        withSuccessHandler success: CompleteionHandler?,
                        withFailureHandlere failure: FailureHandler?) -> DataRequest? {
        
        self.completeionBlock = success
        self.failureBlock = failure
        
        return self.GET(baseUrl, postData: postData, requestName: RequestName.GetPlanDetail)!
    }
    
    func getTimeZone(_ baseUrl: String,
                        postData: [String: AnyObject],
                        withSuccessHandler success: CompleteionHandler?,
                        withFailureHandlere failure: FailureHandler?) -> DataRequest? {
        
        self.completeionBlock = success
        self.failureBlock = failure
        
        return self.GET(baseUrl, postData: postData, requestName: RequestName.gettimezonelist)!
    }
    
    
    override func successCallback(_ response: AnyObject, headers: [AnyHashable : Any], requestName: String) {
        
        if requestName == RequestName.GetPlanDetail {
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
