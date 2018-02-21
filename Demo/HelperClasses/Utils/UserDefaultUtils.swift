//
//  UserDefaultUtils.swift
//  LYNKD
//
//  Created by Ashish Chaudhary on 11/29/17.
//  Copyright © 2017 Magneto IT solutions Pvt Ltd. All rights reserved.
//

import UIKit

class UserDefaultUtils: NSObject {
    
    class func saveBOOLValueForKey(_ value: Bool, key: String) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    class func retrieveBOOLValueForKey(_ key: String) -> Bool {
        
        let isAvailable = UserDefaults.standard.object(forKey: key)
        
        if isAvailable != nil {
            
            guard let value = UserDefaults.standard.object(forKey: key) as? Bool  else {
                fatalError("Unable to type cast")}
            return value
        }
        
        return false
    }
    
    class func saveIntValueForKey(_ value: Int, key: String) {
        
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    class func retrieveIntValueForKey(_ key: String) -> Int? {
        
        let isAvailable = UserDefaults.standard.object(forKey: key)
        
        if isAvailable != nil {
            guard let value = UserDefaults.standard.object(forKey: key) as? Int  else {
                fatalError("Unable to type cast")}
            return value
        }
        
        return nil
    }
    
    class func saveObjectForKey(_ object: AnyObject, key: String) {
        
        UserDefaults.standard.set(object, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    class func retriveObjectForKey(_ key: String) -> AnyObject? {
        
        if let value: AnyObject = UserDefaults.standard.object(forKey: key) as AnyObject? {
            return value
        }
        
        return nil
    }
    
    class func removeSavedObjectForKey(_ key: String) {
        
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
}
