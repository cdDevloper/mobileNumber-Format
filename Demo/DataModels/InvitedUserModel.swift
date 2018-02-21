//
//  InvitedUserModel.swift
//  LYNKD
//
//  Created by Ashish Chaudhary on 12/16/17.
//  Copyright © 2017 Magneto IT solutions Pvt Ltd. All rights reserved.
//

import UIKit

class InvitedUserModel: NSObject {
    var user_id: String?
    var user_name: String?
    var profile_pic: String?
    var Access_level: String?
    
    init(user_id: String?,
         user_name: String?,
         profile_pic: String,
         Access_level: String){
        self.user_id = user_id
        self.user_name = user_name
        self.profile_pic = profile_pic
        self.Access_level = Access_level
    }
    
    class func initializeInvitedUserModel() -> InvitedUserModel {
        let model = InvitedUserModel(user_id: "",
                                     user_name: "",
                                          profile_pic: "",
                                          Access_level: "" )
        return model
    }
    
    class func getDictionaryFromModel(_ model: InvitedUserModel) -> [String: AnyObject?] {
        return model.propertyDictionary()
    }
    
    class func getModelFromDictionary(_ dictionary: [String: AnyObject?]) -> InvitedUserModel {
        
        let model = initializeInvitedUserModel()
        model.user_id = dictionary["user_id"] as? String
        model.user_name = dictionary["user_name"] as? String
        model.profile_pic = dictionary["profile_pic"] as? String
        model.Access_level = dictionary["Access_level"] as? String
        return model as InvitedUserModel
    }
    
    class func getModelFromArray(_ array: [AnyObject]) -> [InvitedUserModel] {
        var modelArray: [InvitedUserModel] = [InvitedUserModel]()
        
        for dict in array {
            if let info =  dict as? [String: AnyObject] {
                let model = self.getModelFromDictionary(info)
                modelArray.append(model)
            }
        }
        return modelArray
    }
}
