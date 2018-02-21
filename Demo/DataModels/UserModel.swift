//
//  LoginModel.swift
//  LYNKD
//
//  Created by Ashish Chaudhary on 11/29/17.
//  Copyright © 2017 Magneto IT solutions Pvt Ltd. All rights reserved.
//

import UIKit

class UserModel: NSObject {
    
    var user_id: String?
    var private_key: String?
    var portal_account_id: String?
    var email: String?
    var first_name: String?
    var last_name: String?
    var message: String?
    var profile_pic: String?
    var status: String?
    var Access_Level:String?
    var plan:String?
    var my_accounts:[Any]?
    
    init(user_id: String?,
         private_key: String,
         portal_account_id: String,
         email: String,
         first_name: String,
         last_name: String,
         message: String,
         profile_pic: String,
         status: String,Access_Level:String,plan:String,my_accounts:[Any]) {
        
        self.user_id = user_id
        self.private_key = private_key
        self.portal_account_id = portal_account_id
        self.email = email
        self.first_name = first_name
        self.last_name = last_name
        self.message = message
        self.profile_pic = profile_pic
        self.status = status
        self.Access_Level = Access_Level
        self.plan = plan
        self.my_accounts = my_accounts
    }
    
    class func initializeUserModel() -> UserModel {
        let model = UserModel(user_id: "",
                              private_key: "",
                              portal_account_id: "",
                              email: "",
                              first_name: "",
                              last_name: "",
                              message: "",
                              profile_pic: "",
                              status: "",
                              Access_Level:"",
                              plan:"",my_accounts:[])
        return model
    }
    
    class func getDictionaryFromModel(_ model: UserModel) -> [String: AnyObject?] {
        return model.propertyDictionary()
    }
    
    class func getModelFromDictionary(_ dictionary: [String: AnyObject?]) -> UserModel {
        
        let model = initializeUserModel()
        model.user_id = dictionary["user_id"] as? String
        model.private_key = dictionary["private_key"] as? String
        model.portal_account_id = dictionary["portal_account_id"] as? String
        model.email = dictionary["email"] as? String
        model.first_name = dictionary["first_name"] as? String
        model.last_name = dictionary["last_name"] as? String
        model.message = dictionary["message"] as? String
        model.profile_pic = dictionary["profile_pic"] as? String
        model.status = dictionary["status"] as? String
        model.Access_Level = dictionary["Access_Level"] as? String
        model.plan         = dictionary["Access_Level"] as? String
        model.my_accounts  = dictionary["my_accounts"] as? [Any]
        
        /*
        let mapping = model.propertyDictionary()
        for attribute in mapping.keys {
            if var attributeValue = dictionary[attribute] {
                if !(attributeValue is NSNull) {
                    Print.Log.info(">>> \(attribute ), \(String(describing: attributeValue))")
                    
                    if attributeValue == nil {
                        attributeValue = "" as AnyObject?
                    }
                    model.setValue(attributeValue, forKey: attribute)
                }
            }
        }*/
        
        return model as UserModel
    }
}
