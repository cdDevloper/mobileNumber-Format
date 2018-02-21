//
//  AccessCodeVerifyModel.swift
//  LYNKD
//
//  Created by Apple on 01/12/17.
//  Copyright © 2017 Magneto IT solutions Pvt Ltd. All rights reserved.
//

import UIKit

class AccessCodeVerifyModel: NSObject {
    var access_code: String?
    var message: String?
    var validity: String?
    var accessCodeId:String?
    var planAssigned:String?
    var plan:String?

    init(access_code: String?,
         message: String,
         validity: String,accessCodeId: String,planAssigned:String,plan:String){
        self.access_code = access_code
        self.message = message
        self.validity = validity
        self.accessCodeId = accessCodeId
    }
    
    class func initializeAccessCodeVerifyModel() -> AccessCodeVerifyModel {
        let model = AccessCodeVerifyModel(access_code: "",
                                          message: "",
                                          validity: "", accessCodeId:"",planAssigned:"",plan:"")
        return model
    }
    
    class func getDictionaryFromModel(_ model: AccessCodeVerifyModel) -> [String: AnyObject?] {
        return model.propertyDictionary()
    }
    
    class func getModelFromDictionary(_ dictionary: [String: AnyObject?]) -> AccessCodeVerifyModel {
        
        let model = initializeAccessCodeVerifyModel()
        model.access_code = dictionary["access_code"] as? String
        model.message = dictionary["message"] as? String
        model.validity = dictionary["validity"] as? String
        model.accessCodeId = dictionary["accessCodeId"] as? String
        model.planAssigned  = dictionary["planAssigned"] as? String
        model.plan  = dictionary["plan"] as? String
    
        return model as AccessCodeVerifyModel
    }
    
}
