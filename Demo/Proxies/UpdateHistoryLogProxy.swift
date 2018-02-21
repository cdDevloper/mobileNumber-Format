//
//  UpdateHistoryLogProxy.swift
//  LYNKD
//
//  Created by Pavan Jadhav on 11/12/17.
//  Copyright © 2017 Magneto IT solutions Pvt Ltd. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

@objc protocol UpdateHistoryLogProxyDelegate {
    func UpdateHistoryLogSuccessfully(response: [String: AnyObject])
    func UpdateHistoryLogFailed(error: String)
}

class UpdateHistoryLogProxy: AbstractProxy {

    weak var delegate: UpdateHistoryLogProxyDelegate?

    func updateHistoryLogRequest(_ postData: [String: AnyObject],
                       isImageSelected:Bool,
                       image: UIImage,
                       withSuccessHandler success: CompleteionHandler?,
                       withFailureHandlere failure: FailureHandler?) {

        let fileName = "profile_pic"
        self.completeionBlock = success
        self.failureBlock = failure
        Print.Log.info("Input: \(postData)")
        print("HistoryURL:\(URLConstant.BaseUrl + URLConstant.UpdateHistoryLog)")
        return self.requestPostURLForUploadImage(URLConstant.BaseUrl + URLConstant.UpdateHistoryLog, isImageSelect: isImageSelected, fileName: fileName, params: postData, image: image, successHandler: { (_, response) in

            if self.delegate != nil {
                self.delegate?.UpdateHistoryLogSuccessfully(response:response )
            }

        }, failureHandler: { (false, error) in
            self.delegate?.UpdateHistoryLogFailed(error:error)
        })

    }
}



//class UpdateHistoryLogProxy: AbstractProxy {
//
//    func updateHistoryLogRequest(_ baseUrl: String,
//                       postData: [String: AnyObject],
//                       withSuccessHandler success: CompleteionHandler?,
//                       withFailureHandlere failure: FailureHandler?) -> DataRequest? {
//
//        self.completeionBlock = success
//        self.failureBlock = failure
//
//        return self.GET(baseUrl, postData: postData, requestName: RequestName.GetDeviceList)!
//    }
//
//    override func successCallback(_ response: AnyObject, headers: [AnyHashable : Any], requestName: String) {
//
//        if requestName == RequestName.GetDeviceList {
//            if let responseDict =  response as? [String: AnyObject] {
//                if responseDict["status"] as? String == "1" {
//                    var invitedUsersList: [DeviceListModel] = []
//                    invitedUsersList = DeviceListModel.getModelFromArray(responseDict["Device_list"] as! [AnyObject])
//                    if let success = self.completeionBlock {
//                        success(invitedUsersList)
//                    }
//                } else {
//                    let message  = responseDict["message"] as? String
//                    if let failure = self.failureBlock {
//                        failure(message!)
//                    }
//                }
//            }
//
//        }
//    }
//
//}

