//
//  DeviceListModel.swift
//  LYNKD
//
//  Created by Pro Retina on 29/12/17.
//  Copyright © 2017 Magneto IT solutions Pvt Ltd. All rights reserved.
//

import UIKit

/*
 
 "lock_address": "AB8103FEFF84BEC4",
 "lock_UUID": "B7A07BAC-C8C4-F35F-5B20-13CC673C7C8E",
 "lock_username": "Shard up",
 "lock_password": "12345678",
 "lock_type": "4",
 "lock_name": "Echo",
 "lock_version": "0027",
 "lock_autounLock": "",
 "lock_autolocktime": "",
 "led_time": "30",
 "sure_set": "60",
 "passcode": "",
 "passcode_enable": "0"
 
 */



class DeviceListModel: NSObject {
    var lock_address: String?
    var lock_UUID: String?
    var lock_username: String?
    var lock_password: String?
    var lock_type: String?
    var lock_name: String?
    var lock_version: String?
    var lock_autounLock: String?
    var led_time: String?
    var sure_set: String?
    var passcode: String?
    var passcode_enable: String?
    var battery_level: String?
    
    init(lock_address: String?,
         lock_UUID: String?,
         lock_username: String?,
         lock_password: String?,
         lock_type: String?,
         lock_name: String?,
         lock_version: String?,
         lock_autounLock: String?,
         led_time: String?,
         sure_set: String?,
         passcode: String?,
         passcode_enable: String?,battery_level:String?){
        self.lock_UUID = lock_UUID
        self.lock_address = lock_address
        self.lock_username = lock_username
        self.lock_password = lock_password
        self.lock_type = lock_type
        self.lock_name = lock_name
        self.lock_version = lock_version
        self.lock_autounLock = lock_autounLock
        self.led_time = led_time
        self.sure_set = sure_set
        self.passcode = passcode
        self.passcode_enable = passcode_enable
        self.battery_level = battery_level
    }
    
    class func initializeDeviceListModel() -> DeviceListModel {
        let model = DeviceListModel(lock_address: "",
                                     lock_UUID: "",
                                     lock_username: "",
                                     lock_password: "",
                                     lock_type: "",
                                     lock_name: "",
                                     lock_version: "",
                                     lock_autounLock: "",
                                     led_time: "",
                                     sure_set: "",
                                     passcode: "",
                                     passcode_enable: "",battery_level:"")
        return model
    }
    
    class func getDictionaryFromModel(_ model: DeviceListModel) -> [String: AnyObject?] {
        return model.propertyDictionary()
    }
    
    class func getModelFromDictionary(_ dictionary: [String: AnyObject?]) -> DeviceListModel {
        
        let model = initializeDeviceListModel()
        model.lock_address = dictionary["lock_address"] as? String
        model.lock_UUID = dictionary["lock_UUID"] as? String
        model.lock_username = dictionary["lock_username"] as? String
        model.lock_password = dictionary["lock_password"] as? String
        model.lock_type = dictionary["lock_type"] as? String
        model.lock_name = dictionary["lock_name"] as? String
        model.lock_version = dictionary["lock_version"] as? String
        model.lock_autounLock = dictionary["lock_autounLock"] as? String
        model.led_time = dictionary["led_time"] as? String
        model.sure_set = dictionary["sure_set"] as? String
        model.passcode = dictionary["passcode"] as? String
        model.passcode_enable = dictionary["passcode_enable"] as? String
        model.battery_level   = dictionary["battery_level"] as? String
        return model as DeviceListModel
    }
    
    class func getModelFromArray(_ array: [AnyObject]) -> [DeviceListModel] {
        var modelArray: [DeviceListModel] = [DeviceListModel]()
        
        for dict in array {
            if let info =  dict as? [String: AnyObject] {
                let model = self.getModelFromDictionary(info)
                modelArray.append(model)
            }
        }
        return modelArray
    }
}
