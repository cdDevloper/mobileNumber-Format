//
//  AlertModel.swift
//  LYNKD
//
//  Created by Ashish Chaudhary on 12/16/17.
//  Copyright © 2017 Magneto IT solutions Pvt Ltd. All rights reserved.
//

import UIKit

class AlertModel: NSObject {
    var status: String?
    var text: String?
    var push: String?
    
    init(status: String?,
         text: String?,
         push: String){
        self.status = status
        self.text = text
        self.push = push
    }
    
    class func initializeAlertModel() -> AlertModel {
        let model = AlertModel(status: "",
                               text: "",
                               push: "")
        return model
    }
    
    class func getDictionaryFromModel(_ model: AlertModel) -> [String: AnyObject?] {
        return model.propertyDictionary()
    }
    
    class func getModelFromDictionary(_ dictionary: [String: AnyObject?]) -> AlertModel {
        
        let model = initializeAlertModel()
        model.status = dictionary["status"] as? String
        model.text = dictionary["text"] as? String
        model.push = dictionary["push"] as? String
        return model as AlertModel
    }
}
