//
//  CoreDataAccess.swift
//  LYNKD
//  Created by Pavan Jadhav on 29/11/17.
//  Copyright © 2017 Magneto IT solutions Pvt Ltd. All rights reserved.
//

import Foundation
import CoreData

class CoreDataAccess : NSObject{
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // MARK: Insert New_Lock_Device
    func  insert_Lock_Device_With(user_id:String,lock_Name:String,lock_Type:String,lock_Password:String,lock_UUID:String,lock_AutoUnLock:String,lock_AutoLockTime:String,batryLvel:String,lock_MacAddress:String,lock_FirmVersion:String) -> Bool{
        //Add Data
        let new_Lock_Device = NSEntityDescription.insertNewObject(forEntityName: "Lock_Device", into: context)
        new_Lock_Device.setValue(user_id, forKey: "user_id")
        new_Lock_Device.setValue(lock_Name, forKey: "lock_Name")
        new_Lock_Device.setValue(Int64(lock_Type), forKey: "lock_Type")
        new_Lock_Device.setValue(lock_Password, forKey: "lock_Password")
        new_Lock_Device.setValue(lock_UUID, forKey: "lock_UUID")
        new_Lock_Device.setValue(lock_AutoUnLock, forKey: "lock_AutoUnLock")
        new_Lock_Device.setValue(Int64(lock_AutoLockTime), forKey: "lock_AutoLockTime")
        new_Lock_Device.setValue(batryLvel, forKey: "lock_BatteryLvl")
        new_Lock_Device.setValue(batryLvel, forKey: "lock_BatteryLvl")
        new_Lock_Device.setValue(batryLvel, forKey: "lock_BatteryLvl")
        new_Lock_Device.setValue(lock_MacAddress, forKey: "lock_MacAddress")
        new_Lock_Device.setValue(lock_FirmVersion, forKey: "lock_Firmversion")
        //Save Context
        do{
            try context.save()
        }catch{
            return false
        }
        return true
    }
    
    // MARK: Fetch ALL_ Lock_Device
    func get_All_Lock_Devices() -> [Lock_Device]?
    {
        do{
            return  try context.fetch(Lock_Device.fetchRequest())
        }
        catch{
            return nil
        }
    }
    
    func get_All_Lock_DevicesOf(user_Id:String) -> [Lock_Device]?{
        var lock_Device:[Lock_Device] = []
        if let lock_Devices = self.get_All_Lock_Devices(){
            for i in 0..<lock_Devices.count{
                if lock_Devices[i].user_id! == user_Id
                {
                    lock_Device.append(lock_Devices[i])
                }
            }
            return lock_Device
        }else{
            print("Error to Fetch Data")
        }
        return nil
    }
    
    func getLockDevicesOf(lock_UUID:String,user_ID:String) -> [Any]{
        var arr:[Any] = []
        
        if let lock_Devices = self.get_All_Lock_Devices(){
            for i in 0..<lock_Devices.count{
                if lock_Devices[i].user_id! == user_ID
                {
                    if lock_Devices[i].lock_UUID! == lock_UUID
                    {
                        arr.append(lock_Devices[i])
                        return arr
                    }
                }
                
            }
        }
        return arr
    }
    
    // MARK: Get LockDeviceFrom UDIDString
    func getLockDeviceOF(UDID:String) -> Lock_Device?
    {
        //Fetch All_Lock_Devices
        if let lock_Devices = self.get_All_Lock_Devices(){
            for index in 0..<lock_Devices.count{
                if lock_Devices[index].lock_UUID == UDID{
                    return lock_Devices[index]
                }
            }
        }
        return nil
    }
    
    // MARK: Get LockDevice name From UDIDString
    func getLockDeviceName(user_Id:String,UDID:String) -> String
    {
        //Fetch All_Lock_Devices
        if let lock_Devices = self.get_All_Lock_Devices(){
            for index in 0..<lock_Devices.count{
                if lock_Devices[index].user_id! == user_Id && lock_Devices[index].lock_UUID == UDID{
                    return lock_Devices[index].lock_Name!
                }
            }
        }
        return ""
    }
    
    
    
    // MARK: Get LockDevice name From UDIDString
    func updateLockDeviceName(user_Id:String,UDID:String,name:String) -> Bool
    {
        //Fetch All_Lock_Devices
        if let lock_Devices = self.get_All_Lock_Devices(){
            for index in 0..<lock_Devices.count{
                if lock_Devices[index].user_id! == user_Id && lock_Devices[index].lock_UUID == UDID{
                    lock_Devices[index].lock_Name = name
                    return true
                }
            }
        }
        return false
    }
    
    
    // MARK: Get LockDevice name From UDIDString
    func updateLockDevicePassword(user_Id:String,UDID:String,password:String) -> Bool
    {
        //Fetch All_Lock_Devices
        if let lock_Devices = self.get_All_Lock_DevicesOf(user_Id:user_Id){
            for index in 0..<lock_Devices.count{
                if lock_Devices[index].user_id! == user_Id && lock_Devices[index].lock_UUID == UDID{
                    lock_Devices[index].lock_Password = password
                    return true
                }
            }
        }
        return false
    }
    
    // MARK: Get LockDevice Index From UDIDString
    func getLockDeviceIndex(UDID:String) -> Int?
    {
        //Fetch All_Lock_Devices
        if let lock_Devices = self.get_All_Lock_Devices(){
            for index in 0..<lock_Devices.count{
                if lock_Devices[index].lock_UUID == UDID{
                    return index
                }
            }
        }
        return nil
    }
    
    // MARK: Delete Single_ Lock_Device
    func delete_Single_Lock_DeviceFrom(UDID:String) -> Bool
    {
        //Fetch All_Lock_Devices
        if let lock_Devices = self.get_All_Lock_Devices(){
            for index in 0..<lock_Devices.count{
                if lock_Devices[index].lock_UUID == UDID{
                    context.delete(lock_Devices[index])
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                    return true
                }
            }
        }
        return false
    }
    
    
    func delete_Single_Lock_DeviceFromUser(user_Id:String,lock_UUID:String) -> Bool {
        if let lock_Devices = self.get_All_Lock_Devices(){
            for index in 0..<lock_Devices.count{
                if lock_Devices[index].user_id! == user_Id && lock_Devices[index].lock_UUID! == lock_UUID   {
                    context.delete(lock_Devices[index])
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                    return true
                }
            }
        }
        return false
    }
    
    // if RFIDTags[index].user_id! == user_Id && RFIDTags[index].lock_UUID! == lock_UUID
    
    
    // MARK: Delete Single_ Lock_Device
    func deleteALLLockDeviceOF(user_ID:String)
    {
        //Fetch All_Lock_Devices
        if let lock_Devices = get_All_Lock_DevicesOf(user_Id:user_ID){
            for index in 0..<lock_Devices.count{
                context.delete(lock_Devices[index])
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
                
            }
        }
    }
    
    // MARK: Check UUID Present
    func checkUDIDPresentForUserID(UDID:String,user_ID:String)->Bool{
        if let lock_Devices = self.get_All_Lock_Devices(){
            for i in 0..<lock_Devices.count{
                if lock_Devices[i].user_id! == user_ID
                {
                    if lock_Devices[i].lock_UUID! == UDID
                    {
                        return true
                    }
                }
            }
        }else{
            print("Error to Fetch Data")
        }
        return false
    }
    
    func updateBatteryLvlFor(user_ID:String,UDID:String,batryLvl:String)->Bool{
        if let lock_Devices = self.get_All_Lock_Devices(){
            for i in 0..<lock_Devices.count{
                if lock_Devices[i].user_id! == user_ID
                {
                    if lock_Devices[i].lock_UUID! == UDID
                    {
                        lock_Devices[i].lock_BatteryLvl = batryLvl
                        return true
                    }
                }
                
            }
        }else{
            print("Error to Fetch Data")
        }
        return false
    }
    
    // MARK: Get UUID for perticular Index Present
    func getUDIDPresentForUserID(index:Int,user_ID:String)->String{
        if let lock_Devices = self.get_All_Lock_DevicesOf(user_Id:user_ID){
            for i in 0..<lock_Devices.count{
                if i == index
                {
                    return lock_Devices[i].lock_UUID!
                }
            }
        }else{
            return "0.0"
        }
        return "0.0"
    }
    
    // MARK: Get Password for perticular Index
    func getPassword(user_Id:String,lock_UUID:String)->String{
        if let lock_Devices =  self.get_All_Lock_DevicesOf(user_Id:user_Id){
            for i in 0..<lock_Devices.count{
                if lock_UUID == lock_Devices[i].lock_UUID
                {
                    return lock_Devices[i].lock_Password!
                }
            }
        }else{
            return "0.0"
        }
        return "0.0"
    }
    
    
    // MARK: Get Password for perticular Index using MacAddress
    func getPassword(user_Id:String,lock_MacAddress:String)->String{
        if let lock_Devices =  self.get_All_Lock_DevicesOf(user_Id:user_Id){
            for i in 0..<lock_Devices.count{
                if lock_MacAddress == lock_Devices[i].lock_MacAddress
                {
                    return lock_Devices[i].lock_Password!
                }
            }
        }else{
            return "0.0"
        }
        return "0.0"
    }
    //MARK:  Insert RFID Tag
    func insert_RFIF_Tag_With(user_id:String,tag_Type:String,tag_IMEI:String,tag_UserName:String,tag_Lock_Type:String, tag_LockMacAddress:String,lock_UUID:String) -> Bool{
        //Add Data
        let new_RFIDTag = NSEntityDescription.insertNewObject(forEntityName: "RFID_TAG", into: context)
        new_RFIDTag.setValue(user_id, forKey: "user_id")
        new_RFIDTag.setValue(tag_Type, forKey: "tag_Type")
        new_RFIDTag.setValue(tag_IMEI, forKey: "tag_IMEI")
        new_RFIDTag.setValue(tag_UserName, forKey: "tag_UserName")
        new_RFIDTag.setValue(tag_Lock_Type, forKey: "tag_LockType")
        new_RFIDTag.setValue(tag_LockMacAddress, forKey: "tag_LockMacAddress")
        new_RFIDTag.setValue(lock_UUID, forKey: "lock_UUID")
        //Save Context
        do{
            try context.save()
        }catch{
            return false
        }
        return true
    }
    
    // MARK: Fetch ALL_ RFIDTags
    func get_All_RFIDTags() -> [RFID_TAG]?
    {
        do{
            return  try context.fetch(RFID_TAG.fetchRequest())
        }
        catch{
            return nil
        }
    }
    
    func get_All_RFIDTagsOf(user_Id:String) -> [RFID_TAG]?{
        var rfidTag:[RFID_TAG] = []
        if let rfidTags = self.get_All_RFIDTags(){
            for i in 0..<rfidTags.count {
                if rfidTags[i].user_id! == user_Id
                {
                    rfidTag.append(rfidTags[i])
                }
            }
            return rfidTag
        }else{
            print("Error to Fetch Data")
        }
        return nil
    }
    
    func get_All_RFIDTagsOf(user_Id:String,lock_UUID:String) -> [RFID_TAG]?{
        var rfidTag:[RFID_TAG] = []
        if let rfidTags = self.get_All_RFIDTags(){
            for i in 0..<rfidTags.count {
                if rfidTags[i].user_id! == user_Id && rfidTags[i].lock_UUID! == lock_UUID
                {
                    rfidTag.append(rfidTags[i])
                }
            }
            return rfidTag
        }else{
            print("Error to Fetch Data")
        }
        return nil
    }
    
    
    // MARK: Delete Single_RFIDTag
    func delete_Single_RFIDTag(user_Id:String,lock_UUID:String,tag_RFID:String) -> Bool {
        //Fetch All_Lock_Devices
        if let RFIDTags = self.get_All_RFIDTags(){
            for index in 0..<RFIDTags.count{
                
                if RFIDTags[index].user_id! == user_Id && RFIDTags[index].lock_UUID! == lock_UUID
                {
                    if tag_RFID == RFIDTags[index].tag_IMEI
                    {
                        context.delete(RFIDTags[index])
                        (UIApplication.shared.delegate as! AppDelegate).saveContext()
                        return true
                    }
                }
            }
        }
        return false
    }
    
    // MARK: Insert_HistoryLog
    func insertLockHistoryLog(lock_Type: String, lock_Device: String, lock_Time: String, isOpenLock: String,lock_TimeNotFormated:String){
        let historyLog = NSEntityDescription.insertNewObject(forEntityName: "History_Log", into: context)
        historyLog.setValue(lock_Type, forKey: "lock_Type")
        historyLog.setValue(lock_Device, forKey: "lock_Device")
        historyLog.setValue(lock_Time, forKey: "lock_Time")
        historyLog.setValue(isOpenLock, forKey: "isOpenLock")
        historyLog.setValue(lock_TimeNotFormated, forKey: "lock_TimeNotFormated")
    }
    
    // MARK: Fetch ALL_ HistoryLog
    func get_All_HistoryLog() -> [History_Log]?
    {
        let fetchRequest = NSFetchRequest<History_Log>(entityName: "History_Log")
        let sort = NSSortDescriptor(key: #keyPath(History_Log.lock_Time), ascending: false)
        fetchRequest.sortDescriptors = [sort]
        do{
            return  try context.fetch(fetchRequest)
        }
        catch{
            return nil
        }
    }
    
    // MARK: Fetch ALL_ HistoryLog
    func delete_All_HistoryLog() -> Bool   {
        /*
         //Fetch All_Lock_Devices
         if let HistoryLog = self.get_All_HistoryLog(){
         for index in 0..<HistoryLog.count{
         context.delete(HistoryLog[index])
         (UIApplication.shared.delegate as! AppDelegate).saveContext()
         return true
         
         }
         }*/
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "History_Log")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
            return true
        } catch {
            return false
            print ("There was an error")
        }
        return false
    }
}


