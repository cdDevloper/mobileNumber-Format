//
//  QuickLockDeviceManger.swift
//  LYNKD
//
//  Created by Ashish Chaudhary on 12/2/17.
//  Copyright © 2017 Magneto IT solutions Pvt Ltd. All rights reserved.



import UIKit
import CoreBluetooth
import Foundation

@objc protocol DeviceLockManagerDelegate {
    @objc optional func deviceLockManagerDeviceConnected(periPheralName: String)
    @objc optional func deviceLockManagerUnlockPasswordResult(isValidPassword: Bool)
    @objc optional func deviceLockManagerUpdateStateError(message: String)
    @objc optional func deviceLockManagerDeviceNotFound()
    @objc optional func deviceLockManagerGetVersionAndDate(version:String,date:String)
    @objc optional func addRFIDStatusResponse(strMsg: Int)
    @objc optional func getRFIDFromDevice(rfid: String)
    @objc optional func deviceLockManagerSelectedDeviceConnected()
    @objc optional func deviceLockManagerDidWriteCompleted(charactristicString: String)
    @objc optional func deviceLockManagerGetBatteryLevel(batteryLvl:Int)
    @objc optional func deviceLockManagerGetHistoryLog(devType:Int,IDOrName:String,logDate:Date,isOpenLock:Bool)
    @objc optional func deviceLockManagerGetWifiList(num_Of_Netwrk:Int,mac_Address:String,SSID:String,signal_Strength:String,auth_Mode:String)
    @objc optional func deviceLockManagerGetWifiPasswordRslt(Connected:Bool)
    @objc optional func deviceLockManagerLynkedPeripheralReConnected()
    @objc optional func deviceLockManagerGetMacAddress(macAddress:String)
    @objc optional func deviceLockManagerrLoadDevicestableview()
    @objc optional func rfidAdded(Added:Bool)
    @objc optional func deviceLockManagerOTAFileDownloaded(value:Int)
    @objc optional func deviceLockManagerGetSerialNumber(serialNumber:String)
    @objc optional func stopLoading(flg:String) //flg="Add" //Stop Loading At the time of AddBulkRFID
                                                //flg="Delete" //Stop Loading At the time of DeleteRFID
    
    @objc optional func deviceLockManagerGetAESIV(strAESIV:String)
    
}

private let sharedDeviceLockManger = DeviceLockManager()

class DeviceLockManager: NSObject {
    
    var bleManager: BLEManager!
    
    var delegate: DeviceLockManagerDelegate?
    var isWifiEnableDevice:Bool = false
    var isLynkdDeviceConnected: Bool = false
    var countForWifi = 0
    var WiFiSSID = ""
    var peripheralServices: [CBService] = []
    var scannedPeripherals: [CBPeripheral] = []
    var serviceCharacteristics: [CBCharacteristic] = []
    
    let dataScanner: DataScanner = DataScanner()
    var flgAESIV = "0"  //0: NotGetAESIV 1:GetAESIV
    
    var countHistory = 0
    
    class func shared() -> DeviceLockManager {
        return sharedDeviceLockManger
    }
    
    func isValidLYNKPeripheralDevice(deviceName: String) -> Bool {  //"Gunbox",
        
        // let LYNKDeviceNames = ["Padlock", "Padlock!", "Quicklock Padlock", "Doorlock", "Doorlock!", "Quicklock Doorlock","Gunbox 2.0", "Echo", "Gunbox Echo", "Gunbox SK-1","SK-1","BigBertha","Big Bertha","Quicklock Deadbolt","Deadbolt","RF WRITER","Gunbox 3.0","Gunbox 3.0 Echo","LYNKD","Gunbox","RF Writer"]
        //let LYNKDeviceNames = ["Gunbox 2.0","Gunbox 3.0","Gunbox 3.0 Echo", "Gunbox SK-1", "BigBertha","Echo","Gunbox", "Quicklock Padlock","Deadbolt","Deadbolt!","Alertlock","Doorlock","Doorlock!","SK1", "SK-1", "Big Bertha","LYNKD", "LoxxBoxx"]
        
        
        let LYNKDeviceNames = ["Padlock","Padlock!","Quicklock Padlock","Doorlock","Doorlock!","Quicklock Doorlock", "Echo","Gunbox Echo","Gunbox","SK1","Big Bertha!", "BigBertha", "BigBertha!","Sentinel","Gunbox SK-1", "SK-1","Deadbolt","Deadbolt!","Gunbox 3.0","Gunbox 3.0 Echo","Alert Lock","LoxxBoxx"]
        
        
        
        return LYNKDeviceNames.contains(deviceName)
    }
    
    
    func initiateCbControlManagerDevice() {
        print("xpc Found..?")
        self.bleManager = BLEManager(delegate: self)
    }
    
    func reconnectToConnectedLynkedPeripheral() {
        bleManager.reconnectToConnectedLynkedPeripheral()
    }
    
    func getServiceFromArray(strService: String) -> CBService? {
        var service: CBService? = nil
        for serviceObj in self.peripheralServices {
            if serviceObj.uuid.uuidString == strService {
                service = serviceObj
            }
        }
        return service
    }
    
    
    func cancelConnection(){
        
        if self.bleManager != nil {
            self.bleManager.cancelConnection()
        }
        
    }
    
    func checkConnection(){
        self.bleManager.readDataWithCharacteristic(characteristic: self.getCharacteristicFromArray(StrCharacteristic: Characteristics.GetWifiStatusConnUUID))
    }
    
    func setUserName(){
        self.bleManager.writeDataWithCharacteristic(writeData:dataScanner.bd_setUserName(UserDefaultUtils.retriveObjectForKey(userDefaults.userName) as! String), characteristic: self.getCharacteristicFromArray(StrCharacteristic: Characteristics.GetUserNameUUID))
        
    }
    
    func getCharacteristicFromArray(StrCharacteristic: String) -> CBCharacteristic {
        var characteristic: CBCharacteristic? = nil
        for characteristicsObj in self.serviceCharacteristics {
            if characteristicsObj.uuid == CBUUID(string:  StrCharacteristic) {
                characteristic = characteristicsObj
            }
        }
        return characteristic!
    }
    
    func initiateServicesAndCharacteristicsOperation(characteristic: String, strService: String) {
        
        if let service = self.getServiceFromArray(strService: strService)
        {
            self.bleManager.discoverCharacteristicForService(service: service, characteristic: characteristic)
        } else {
            if (delegate != nil) {
                // delegate?.deviceLockManagerUpdateStateError?(message: Messages.somethingWentWrong)
            }
        }
    }
    
    func setShareCodeWithTime() {
        DeviceLockManager.shared().isLynkdDeviceConnected = false
        
        self.bleManager.writeDataWithCharacteristic(writeData: dataScanner.addSharecodeTimeBase(SessionDataManager.shared().shareCode, share_Code_Start_Time: SessionDataManager.shared().share_Code_Start_Time, share_Code_End_Time: SessionDataManager.shared().share_Code_End_Time, share_Code_Start_Time_minutes: Int32(SessionDataManager.shared().share_Code_Start_Time_minutes), share_Code_End_Time_minutes: Int32(SessionDataManager.shared().share_Code_End_Time_minutes), share_Code_DATE_Time_FLAG: Int32(SessionDataManager.shared().share_Code_DATE_Time_FLAG)), characteristic: self.getCharacteristicFromArray(StrCharacteristic: Characteristics.shareCodeTime))
    }
    
    
    func setShareCodeWithCount() {
        DeviceLockManager.shared().isLynkdDeviceConnected = false
        //addSharecode
        self.bleManager.writeDataWithCharacteristic(writeData: dataScanner.addSharecode(SessionDataManager.shared().shareCode, shareCodeCount: SessionDataManager.shared().share_Code_Count), characteristic: self.getCharacteristicFromArray(StrCharacteristic: Characteristics.shareCodeCount))
    }
    
    func setLockUnlockDevice(_ isLockOpen: Bool) {
        //DeviceLockManager.shared().isLynkdDeviceConnected = false
        self.bleManager.writeDataWithCharacteristic(writeData:dataScanner.setLockControlisLockOpen(), characteristic: self.getCharacteristicFromArray(StrCharacteristic: Characteristics.CustomerUnlockPasswordUUID))
        
//        DeviceLockManager.shared().cancelConnection()
//        SessionDataManager.shared().CbControlManager?.stopScan()
    }
    
    
    func setAlarm() {
        
        let type:UInt8 = 1
        let time:UInt8 = 0
        self.bleManager.writeDataWithCharacteristic(writeData:dataScanner.setAlarm(type, delay: time), characteristic: self.getCharacteristicFromArray(StrCharacteristic: Characteristics.setAlarm))
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.bleManager.readDataWithCharacteristic(characteristic: self.getCharacteristicFromArray(StrCharacteristic: Characteristics.setAlarm))
        }
        
        
    }
    
    func writeOTAFile(){
        
        let fileName = UserDefaultUtils.retriveObjectForKey(userDefaults.newVersion) as! String
        
        let hexStr = self.dataScanner.string(toHex: "AT#OTA=54.186.214.225:80,/lynkd-superadmin/backend/web/firmware-versions/\(fileName)")
        let data = hexStr?.hexadecimal()
        
        
        self.bleManager.writeDataWithCharacteristic(writeData:data!, characteristic: self.getCharacteristicFromArray(StrCharacteristic: Characteristics.addOTAFile))
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.bleManager.readDataWithCharacteristic(characteristic: self.getCharacteristicFromArray(StrCharacteristic: Characteristics.addOTAFile))
        }
        
    }
    
    func writeKeycode(){
        self.bleManager.writeDataWithCharacteristic(writeData:dataScanner.setPassCode(SessionDataManager.shared().keyCode), characteristic: self.getCharacteristicFromArray(StrCharacteristic: Characteristics.setKeycode))
    }
    
    func writeLedTimeOut(){
        self.bleManager.writeDataWithCharacteristic(writeData:dataScanner.setLedTimeOut(Int32(SessionDataManager.shared().ledTimeOut)), characteristic: self.getCharacteristicFromArray(StrCharacteristic: Characteristics.setLedTimeOut))
    }
    
    func writeAutoLockTime(){
        self.bleManager.writeDataWithCharacteristic(writeData:dataScanner.setLockOpenTime(Int32(SessionDataManager.shared().autoLockTime)), characteristic: self.getCharacteristicFromArray(StrCharacteristic: Characteristics.setAutoLockTime))
    }
    
    func setRFIDIntoDevice() {
        
        bleManager.writeDataWithCharacteristic(writeData:dataScanner.addRFIDIntoDevice(), characteristic: self.getCharacteristicFromArray(StrCharacteristic: Characteristics.RFIDAddCharactesticsUUID))
    }
    
    func setVerifyPasswordForDevice() {
        if SessionDataManager.shared().isSetNewPassword {
            bleManager.writeDataWithCharacteristic(writeData:dataScanner.changePasssword(UserDefaultUtils.retriveObjectForKey(userDefaults.newPass) as! String, oldPassword:UserDefaultUtils.retriveObjectForKey(userDefaults.oldPass) as! String), characteristic: self.getCharacteristicFromArray(StrCharacteristic: Characteristics.CustomerUnlockVerifyPasswordUUID))
        }else{
            bleManager.writeDataWithCharacteristic(writeData:dataScanner.verifyPassword(UserDefaultUtils.retriveObjectForKey(userDefaults.password) as! String), characteristic: self.getCharacteristicFromArray(StrCharacteristic: Characteristics.CustomerUnlockVerifyPasswordUUID))
        }
    }
    
    func setNotifyPasswordResultForDevice() {
        bleManager.setNotifyWithCharacteristic(characteristic: self.getCharacteristicFromArray(StrCharacteristic: Characteristics.CustomerUnlockPasswordResultUUID))
    }
    
    func setNotifyRFIDAddToDevice(){
        bleManager.setNotifyWithCharacteristic(characteristic: self.getCharacteristicFromArray(StrCharacteristic: Characteristics.RFIDAddCharactesticsUUID))
    }
    
    func setNotifyForRFIDList(){
        bleManager.setNotifyWithCharacteristic(characteristic: self.getCharacteristicFromArray(StrCharacteristic: Characteristics.GetRFIDListUUID))
    }
    
    func setNotifyForRFIDDeleteFromTheDevice(){
        bleManager.setNotifyWithCharacteristic(characteristic: self.getCharacteristicFromArray(StrCharacteristic: Characteristics.RFIDDeleteUDID))
    }
    
    func setRFIDTogetRfIDFromDevice(){
        bleManager.writeDataWithCharacteristic(writeData:dataScanner.addRFIDIntoDevice(), characteristic: self.getCharacteristicFromArray(StrCharacteristic: Characteristics.GetRFIDListUUID))
    }
    
    //-(NSData*)deleteRFIDFromTheDevice:(NSString *)rfifTag
    func setRFIDToDeleteRfIDFromDevice()  {
        
        for i in 0..<SessionDataManager.shared().selectedRFIDTagForDeleteting.count{
            if SessionDataManager.shared().selectedRFIDTagForDeleteting[i].count == 14{
               bleManager.writeDataWithCharacteristic(writeData:dataScanner.deleteRFID(fromTheDevice: SessionDataManager.shared().selectedRFIDTagForDeleteting[i]), characteristic: self.getCharacteristicFromArray(StrCharacteristic: Characteristics.RFIDDeleteUDID))
    
            }
            
//            if i == SessionDataManager.shared().selectedRFIDTagForDeleteting.count - 1{
//                self.delegate?.stopLoading?(flg: "Delete")
//            }
            
        }
    }
    func setNotifyForHistory(){
        bleManager.setNotifyWithCharacteristic(characteristic: self.getCharacteristicFromArray(StrCharacteristic: Characteristics.GetHistorylUUID))
    }
    
    func addBulkRFID() {
        
        for i in 0..<SessionDataManager.shared().selectedRFIDToAdd.count{
            if SessionDataManager.shared().selectedRFIDToAdd[i].count == 14{
                bleManager.writeDataWithCharacteristic(writeData:dataScanner.getRFIDAdd(inBulk:SessionDataManager.shared().selectedRFIDToAdd[i]), characteristic: self.getCharacteristicFromArray(StrCharacteristic: Characteristics.AddBulkRFID))
            }
            
//            if i == SessionDataManager.shared().selectedRFIDToAdd.count - 1{
//                self.delegate?.stopLoading?(flg: "Add")
//            }
        }
        
    }
    
    func setNotifyForBulkRFID(){
        bleManager.setNotifyWithCharacteristic(characteristic: self.getCharacteristicFromArray(StrCharacteristic: Characteristics.AddBulkRFID))
        
    }
    
    func setListOfWifiForDevice() {
        // bleManager.setNotifyWithCharacteristic(characteristic: self.getCharacteristicFromArray(StrCharacteristic: Characteristics.GetWifiUUID))
        bleManager.writeDataWithCharacteristic(writeData:dataScanner.setWiFiListforDevice(), characteristic: self.getCharacteristicFromArray(StrCharacteristic: Characteristics.GetWifiUUID))
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.bleManager.readDataWithCharacteristic(characteristic: self.getCharacteristicFromArray(StrCharacteristic: Characteristics.GetWifiUUID))
        }
    }
    
    func getMacAddress(){
        bleManager.readDataWithCharacteristic(characteristic: self.getCharacteristicFromArray(StrCharacteristic: Characteristics.GetMacAddressUUID))
    }
    
    func getAESIV(){
        flgAESIV = "0"
        bleManager.readDataWithCharacteristic(characteristic: self.getCharacteristicFromArray(StrCharacteristic: Characteristics.CustomerUnlockVerifyPasswordUUID))
    }
    
    func setWifiPassword(){
        
        //let firstStr = "0D"
        let firstData = dataScanner.getWifiFisrtData()//firstStr.data(using: .utf8)
        
        bleManager.writeDataWithCharacteristic(writeData:firstData!, characteristic: self.getCharacteristicFromArray(StrCharacteristic: Characteristics.GetWifiPasswordWriteUUID))
        
        let SSID = UserDefaultUtils.retriveObjectForKey(userDefaults.wifiSSID)
        let password = UserDefaultUtils.retriveObjectForKey(userDefaults.wifiPassword)//Magneto_jio,skype-call
        var finalStr = "\(SSID!),\(password!)"
        finalStr = finalStr.replacingOccurrences(of: "\0", with: "")
        let hexStr = self.dataScanner.string(toHex: "AT#WCAP=\(finalStr),7")
        let data = hexStr?.hexadecimal()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.bleManager.writeDataWithCharacteristic(writeData:data!, characteristic: self.getCharacteristicFromArray(StrCharacteristic: Characteristics.GetWifiPasswordWriteUUID))
        }
        
        let data11 = self.dataScanner.getWifiFisrtData()//hexStr.data(using: .utf8)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.bleManager.writeDataWithCharacteristic(writeData:data11!, characteristic: self.getCharacteristicFromArray(StrCharacteristic: Characteristics.GetWifiPasswordWriteUUID))
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.bleManager.readDataWithCharacteristic(characteristic: self.getCharacteristicFromArray(StrCharacteristic: Characteristics.GetWifiPasswordWriteUUID))
                
            }
        }
        
    }
    func writeNotificationSetting(){
        
        let data = "0001".dataWithHexString()
        bleManager.writeDataWithCharacteristic(writeData:data, characteristic: self.getCharacteristicFromArray(StrCharacteristic: Characteristics.notificationSetting))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.bleManager.readDataWithCharacteristic(characteristic: self.getCharacteristicFromArray(StrCharacteristic: Characteristics.notificationSetting))
        }
    }
    
    func setHistoryFromDevice(){
        bleManager.writeDataWithCharacteristic(writeData:dataScanner.getHistoryDataForDevcice(), characteristic: self.getCharacteristicFromArray(StrCharacteristic: Characteristics.GetHistoryWrite))
    }
    
    func setFirmwareVersionFromDevice(){
        bleManager.readDataWithCharacteristic(characteristic: self.getCharacteristicFromArray(StrCharacteristic: Characteristics.Get_Firmware_lock_versionUUID))
    }
    
    func  getSerialNumber(){
        bleManager.readDataWithCharacteristic(characteristic: self.getCharacteristicFromArray(StrCharacteristic: Characteristics.GetSerialNumber))
    }
    
    func setBatteryLevelFromDevice(){
        bleManager.readDataWithCharacteristic(characteristic: self.getCharacteristicFromArray(StrCharacteristic: Characteristics.GetBatteryLevelUUID))
    }
    
    func setUpdateTimeNotify(){
        bleManager.setNotifyWithCharacteristic(characteristic: self.getCharacteristicFromArray(StrCharacteristic: Characteristics.setCurrentTimeUUID))
    }
    
    func setCurrentTime(){
        bleManager.writeDataWithCharacteristic(writeData:dataScanner.bd_setCurrentTime(), characteristic: self.getCharacteristicFromArray(StrCharacteristic: Characteristics.setCurrentTimeUUID))
    }
    
    func getCurrentTime(){
        bleManager.readDataWithCharacteristic(characteristic: self.getCharacteristicFromArray(StrCharacteristic: Characteristics.setCurrentTimeUUID))
    }
    
    func readUnlockPasswordResultCharacteristic(characteristic: CBCharacteristic) {
        let value = characteristic.value
        let dataLength = value?.count
        var dataArray = [UInt8](repeating:0, count:dataLength!)
        value?.copyBytes(to: &dataArray, count: dataLength!)
        let isPasswordCorrect: Int = Int(dataArray[0])
        
        if SessionDataManager.shared().isSetNewPassword {
            SessionDataManager.shared().isSetNewPassword = false
            if isPasswordCorrect == 0x03 {
                if self.delegate != nil {
                    self.delegate?.deviceLockManagerUnlockPasswordResult?(isValidPassword: true)
                }
            } else{
                if self.delegate != nil {
                    self.delegate?.deviceLockManagerUnlockPasswordResult?(isValidPassword: false)
                }
            }
        }else{
            if isPasswordCorrect == 0x01 {
                if self.delegate != nil {
                    self.delegate?.deviceLockManagerUnlockPasswordResult?(isValidPassword: true)
                }
            } else{
                if self.delegate != nil {
                    self.delegate?.deviceLockManagerUnlockPasswordResult?(isValidPassword: false)
                }
            }
        }
        
    }
    
    func addRFIDStatus(characteristic: CBCharacteristic) {
        let value = characteristic.value
        let dataLength = value?.count
        var dataArray = [UInt8](repeating:0, count:dataLength!)
        value?.copyBytes(to: &dataArray, count: dataLength!)
        let isReadStatus: Int = Int(dataArray[0])
        if isReadStatus != 0 {
            if self.delegate != nil {
                self.delegate?.addRFIDStatusResponse?(strMsg:isReadStatus )
            }
        }else{
            self.delegate?.addRFIDStatusResponse?(strMsg:0 )
        }
    }
    
    func readRFIDList(characteristic: CBCharacteristic) {
        // Get RFID RFID list
        let value = characteristic.value
        let dataLength = value?.count
        var dataArray = [UInt8](repeating:0, count:dataLength!)
        value?.copyBytes(to: &dataArray, count: dataLength!)
        
        var rfid = ""
        for i in 0...6 {
            rfid += String(format: "%.2X", dataArray[i])
        }
        
        print("rfid===\(rfid) count==\(dataArray.count)")
        
        if self.delegate != nil {
            self.delegate?.getRFIDFromDevice?(rfid: rfid)
        }
    }
    
    func deleteRFIDStatusFromTheDevice(characteristic: CBCharacteristic) {
    }
    
    func readFirmwarelockversion(characterstic:CBCharacteristic){
        
        if let data = characterstic.value {
            let dataLength = data.count
            var dataArray = [UInt8](repeating:0, count:dataLength)
            data.copyBytes(to: &dataArray, count: dataLength)
            // get the value of
            var firmwareRevision = ""
            var revisionDate = ""
            firmwareRevision = String(format: "%.2X%.2X", dataArray[0], dataArray[1])
            print("firmwareRevision===\(firmwareRevision)")
            revisionDate = String(format: "20%.2X-%.2X-%.2X %.2X:%.2X:00", dataArray[2], dataArray[3], dataArray[4], dataArray[5], dataArray[6])
            print("revisionDate====\(revisionDate)")
            
            self.delegate?.deviceLockManagerGetVersionAndDate?(version:firmwareRevision, date:revisionDate)
        }
    }
    
    func readBatteryLevel(characterstic:CBCharacteristic){
        if let data =  characterstic.value{
            let dataLength = data.count
            if dataLength<1{
                return
            }
            var dataArray = [UInt8](repeating:0, count:dataLength)
            data.copyBytes(to: &dataArray, count: dataLength)
            let level = data[0]
            
            delegate?.deviceLockManagerGetBatteryLevel?(batteryLvl:Int(level))
        }
    }
    
    func readHistoryLog(characterstic:CBCharacteristic){
        
        //        //TODO:ReMove Only Outer IF and Else Statement and countHistory
        //        if countHistory < 8{
        //            countHistory += 1
        if let data = characterstic.value {
            
            let dataLength = data.count
            //TODO: Need To Check What Is the Issue for WifiDevice
            if dataLength >= 8{
                var dataArray = [UInt8](repeating:0, count:dataLength)
                data.copyBytes(to: &dataArray, count: dataLength)
                var devType: Int = 0
                var i: Int = 0
                var n: Int = 0
                var dID = ""
                var date: Date?
                var isOpenLock = false
                // Return E0E0E0E0E0E0E0E0 end record or no record
                if (dataArray[0] == 0xe0) && (dataArray[1] == 0xe0) && (dataArray[2] == 0xe0) && (dataArray[3] == 0xe0) && (dataArray[4] == 0xe0) && (dataArray[5] == 0xe0) && (dataArray[6] == 0xe0) && (dataArray[7] == 0xe0) {
                    print("No Record ")
                    delegate?.deviceLockManagerGetHistoryLog?(devType: 011, IDOrName: "", logDate: Date(), isOpenLock: true)
                }
                
                //NFC historical information end or end Iphone historical information, do nothing
                if (dataArray[0] == 0xf0) && (dataArray[1] == 0xf0) && (dataArray[2] == 0xf0) && (dataArray[3] == 0xf0) && (dataArray[4] == 0xf0) && (dataArray[5] == 0xf0) && (dataArray[6] == 0xf0) && (dataArray[7] == 0xf0) || (dataArray[0] == 0xe0) && (dataArray[1] == 0xe0) && (dataArray[2] == 0xe0) && (dataArray[3] == 0xe0) && (dataArray[4] == 0xe0) && (dataArray[5] == 0xe0) && (dataArray[6] == 0xe0) && (dataArray[7] == 0xe0) {
                    return
                }
                
                if dataArray[7] == 0xe0 {
                    //Device type is NFC
                    devType = 0
                    //Resolve ID
                    dID = ""
                    for i in 0..<7 {
                        dID =  String(format: "%@%02X", dID, dataArray[i])
                    }
                    //Resolution Time
                    date = dataScanner.getBytesToDate(dataArray[8], b1: dataArray[9], b2: dataArray[10], b3: dataArray[11])
                    
                    //Lock or shut (0x00: unlock; 0x01: unlock; 0x02: Off Lock)
                    if dataArray[19] != 0x02 {
                        isOpenLock = true
                    }
                    else {
                        isOpenLock = false
                    }
                    
                    delegate?.deviceLockManagerGetHistoryLog?(devType: devType, IDOrName: dID, logDate: date!, isOpenLock: isOpenLock)
                }
                else {
                    
                    devType = 1
                    //Analytical Phone name
                    n = Int(dataArray[0])
                    dID = ""
                    if (n > 0) && (n < QuickLock_TI_KEYFOB_HISTORY_PHONE_ID_LENGTH) {
                        for i in 1...n {
                            dID = String(format: "%@%c", dID, dataArray[i])
                        }
                    }
                    
                    
                    //Resolution Time
                    date = dataScanner.getBytesToDate(dataArray[15], b1: dataArray[16], b2: dataArray[17], b3: dataArray[18])
                    //Lock or shut (0x00: unlock; 0x03: unlock; 0x04: Off Lock)
                    if dataArray[19] != 0x04 {
                        isOpenLock = true
                    }
                    else {
                        isOpenLock = false
                    }
                    
                    delegate?.deviceLockManagerGetHistoryLog?(devType: devType, IDOrName: dID, logDate: date!, isOpenLock: isOpenLock)
                }
            }else{
                delegate?.deviceLockManagerGetHistoryLog?(devType: 011, IDOrName: "", logDate: Date(), isOpenLock: true)
            }
        }
        
        //        }else{
        //            delegate?.deviceLockManagerGetHistoryLog?(devType: 011, IDOrName: "", logDate: Date(), isOpenLock: true)
        //        }
        
    }
    
    func readCurrentTimeUpdate(characterstic: CBCharacteristic){
        if let data = characterstic.value {
            let dataLength = data.count
            var bAddress = [UInt8](repeating:0, count:dataLength)
            data.copyBytes(to: &bAddress, count: dataLength)
            
            
            if dataLength < QuickLock_TI_KEYFOB_TIME_LENGTH {
                return
            }
            
            var n: Int = 0
            var da: Date?
            var date2000: Date?
            var fm: DateFormatter?
            fm = DateFormatter()
            fm?.dateFormat = "yyyy-MM-dd hh:mm:ss"
            date2000 = fm?.date(from: "2000-01-01 00:00:00")
            var b1: Int = 0
            var b2: Int = 0
            var b3: Int = 0
            var b4: Int = 0
            b1 = Int(bAddress[0])
            b2 = Int(bAddress[1])
            b3 = Int(bAddress[2])
            b4 = Int(bAddress[3])
            n = b1 | (b2 << 8) | (b3 << 16) | (b4 << 24)
            da = Date(timeInterval: n as? TimeInterval ?? 0.0, since: date2000!)
            
            print(da)
        }
    }
    
    func readWifiList(characteristic: CBCharacteristic) {
        let value = characteristic.value
        let dataLength = value?.count
        var dataArray = [UInt8](repeating:0, count:dataLength!)
        value?.copyBytes(to: &dataArray, count: dataLength!)
        var SSID = ""
        if dataArray.count != 0{
            if WiFiSSID == ""{
                countForWifi = Int(dataArray[0] + dataArray[1])
            }
            for i in 0...dataArray.count-1{
                SSID = SSID + String(format: "%02X", dataArray[i])
            }
            print("---------------------------------------")
            print(SSID)
            WiFiSSID = WiFiSSID + SSID
            
            bleManager.readDataWithCharacteristic(characteristic: self.getCharacteristicFromArray(StrCharacteristic: Characteristics.GetWifiUUID))
            
        }else{
            print("Wifi Scan End")
            if WiFiSSID != ""{
                self.parseWifiList(WiFiSSID1:WiFiSSID)
            }else{
                //Set SSID to 0 to know WifiList is equal to 0
                self.delegate?.deviceLockManagerGetWifiList?(num_Of_Netwrk: 0, mac_Address: "", SSID: "0", signal_Strength: "", auth_Mode: "")
            }
        }
        
    }
    
    func parseWifiList(WiFiSSID1:String){
        var WiFiSSID = String(WiFiSSID1.dropFirst(4))
        
        for _ in 0..<countForWifi{
            //Get MacAddress
            var macAddress     = String(WiFiSSID.prefix(12))
            //get HexString to Byte Array and Convert it to Int
            if let macAddressbyteArr = macAddress.stringToBytes(){
                var value11 : UInt32 = 0
                let data = NSData(bytes: macAddressbyteArr, length: macAddressbyteArr.count)
                data.getBytes(&value11, length: macAddressbyteArr.count)
                value11 = UInt32(bigEndian: value11)
            }
            print("MacAddress==\(macAddress)\n\n")
            WiFiSSID       = String(WiFiSSID.dropFirst(12))
            print(WiFiSSID)
            
            //Get SSID
            var SSID           = String(WiFiSSID.prefix(66))
            //get HexString to actual String
            SSID = SSID.stringWithHexString()
            print("SSID==\(SSID)\n\n")
            WiFiSSID       = String(WiFiSSID.dropFirst(66))
            print(WiFiSSID)
            
            //Get SignalStrength
            var signalStrength = String(WiFiSSID.prefix(2))
            let data = signalStrength.dataWithHexString()
            var dataArray11 = [UInt8](repeating:0, count:1)
            data.copyBytes(to: &dataArray11, count: 1)
            signalStrength = String(dataArray11[0])
            print(dataArray11[0])
            print("signalStrength==\(signalStrength)\n\n")
            WiFiSSID       = String(WiFiSSID.dropFirst(2))
            print(WiFiSSID)
            
            //Get AuthMode
            let authMode       = String(WiFiSSID.prefix(2))
            
            print("authMode===\(authMode)\n\n")
            WiFiSSID           = String(WiFiSSID.dropFirst(2))
            print(WiFiSSID)
            
            self.delegate?.deviceLockManagerGetWifiList?(num_Of_Netwrk: countForWifi, mac_Address: macAddress, SSID: SSID, signal_Strength: signalStrength, auth_Mode: authMode)
        }
        //Set SSID to nil to know WifiList Done So we can reload tblOfWifiList
        self.delegate?.deviceLockManagerGetWifiList?(num_Of_Netwrk: 0, mac_Address: "", SSID: "nil", signal_Strength: "", auth_Mode: "")
    }
    
    func getBytesToDate(_ b0: UInt8, b1: UInt8, b2: UInt8, b3: UInt8) -> Date {
        var n: Int
        var da: Date?
        var date2000: Date?
        var fm: DateFormatter?
        fm = DateFormatter()
        fm?.dateFormat = "yyyy-MM-dd hh:mm:ss"
        date2000 = fm?.date(from: "2000-01-01 00:00:00")
        n = Int(b0 | (b1 << 8) | (b2 << 16) | (b3 << 24))
        da = Date(timeInterval: n as? TimeInterval ?? 0.0, since: date2000!)
        return da!
    }
    
    func readWifiPassword(characteristic: CBCharacteristic) {
        let value = characteristic.value
        let dataLength = value?.count
        var dataArray = [UInt8](repeating:0, count:dataLength!)
        value?.copyBytes(to: &dataArray, count: dataLength!)
        print(dataArray)//[105, 116, 97, 122, 0, 32, 1, 0, 1, 0, 0]itaz
        var strValue = ""
        if dataArray.count != 0{
            for i in 0...dataArray.count-1{
                strValue = strValue + String(format: "%02X", dataArray[i])
            }
            print("---------------------------------------")
            
            //strValue =  strValue.stringWithHexString()
            print("strValue==\(strValue)\n\n")
            //            if strValue == "6974617A00200100010000"{
            //                self.delegate?.deviceLockManagerGetWifiPasswordRslt?(Connected: true)
            //            }else{
            //                self.delegate?.deviceLockManagerGetWifiPasswordRslt?(Connected: false)
            //            }
            self.bleManager.readDataWithCharacteristic(characteristic: self.getCharacteristicFromArray(StrCharacteristic: Characteristics.GetWifiStatusConnUUID))
        }else{
            
        }
    }
    
    func readWifiConnected(characteristic: CBCharacteristic) {
        let value = characteristic.value
        let dataLength = value?.count
        var dataArray = [UInt8](repeating:0, count:dataLength!)
        value?.copyBytes(to: &dataArray, count: dataLength!)
        print(dataArray)
        if dataArray[0] == 0x00{
            //self.delegate?.deviceLockManagerGetWifiPasswordRslt?(Connected: false)
            self.bleManager.readDataWithCharacteristic(characteristic: self.getCharacteristicFromArray(StrCharacteristic: Characteristics.GetWifiStrgrngthToCheckConnect))
        }else{
            self.bleManager.readDataWithCharacteristic(characteristic: self.getCharacteristicFromArray(StrCharacteristic: Characteristics.GetWifiStrgrngthToCheckConnect))
            
            // self.delegate?.deviceLockManagerGetWifiPasswordRslt?(Connected:true)
        }
    }
    
    func readWifiConnectedUsingRSSI(characteristic: CBCharacteristic){
        let value = characteristic.value
        let dataLength = value?.count
        var dataArray = [UInt8](repeating:0, count:dataLength!)
        value?.copyBytes(to: &dataArray, count: dataLength!)
        print(dataArray)
        if dataArray[0] == 0x00{
            self.delegate?.deviceLockManagerGetWifiPasswordRslt?(Connected: true)
        }else{
            self.delegate?.deviceLockManagerGetWifiPasswordRslt?(Connected:false)
        }
    }
    
    func readUserName(characteristic: CBCharacteristic){
        
    }
    
    func readMacAddress(characteristic: CBCharacteristic){
        let value = characteristic.value
        let dataLength = value?.count
        var dataArray = [UInt8](repeating:0, count:dataLength!)
        value?.copyBytes(to: &dataArray, count: dataLength!)
        print(dataArray)//[105, 116, 97, 122, 0, 32, 1, 0, 1, 0, 0]itaz
        var strValue = ""
        if dataArray.count != 0{
            for i in 0...dataArray.count-1{
                strValue = strValue + String(format: "%02X", dataArray[i])
            }
            print("---------------------------------------")
            print("Mac==\(strValue)\n\n")
            self.delegate?.deviceLockManagerGetMacAddress?(macAddress:strValue)
        }
        
    }
    
    func readSerialNumber(characteristic: CBCharacteristic){
        let value = characteristic.value
        let dataLength = value?.count
        var dataArray = [UInt8](repeating:0, count:dataLength!)
        value?.copyBytes(to: &dataArray, count: dataLength!)
        print(dataArray)//[105, 116, 97, 122, 0, 32, 1, 0, 1, 0, 0]itaz
        var strValue = ""
        if dataArray.count != 0{
            for i in 0...dataArray.count-1{
                strValue = strValue + String(format: "%02X", dataArray[i])
            }
            print("---------------------------------------")
            print("SerialNumber==\(strValue)\n\n")
            self.delegate?.deviceLockManagerGetSerialNumber?(serialNumber:strValue)
        }
        
    }
    
    func CheckRFIDAadded(characteristic: CBCharacteristic){
        let value = characteristic.value
        let dataLength = value?.count
        var dataArray = [UInt8](repeating:0, count:dataLength!)
        value?.copyBytes(to: &dataArray, count: dataLength!)
        print(dataArray)
        if dataArray[0] == 0xFF{
            self.delegate?.rfidAdded!(Added: false)
        }else if dataArray[0] == 0x00 {
            self.delegate?.rfidAdded!(Added: false)
        }else if dataArray[0] == 0x01 {
            self.delegate?.rfidAdded!(Added: true)
        }else{
            self.delegate?.rfidAdded!(Added: false)
        }
    }
    
    
    func readAlarm(characteristic: CBCharacteristic){
        let value = characteristic.value
        let dataLength = value?.count
        var dataArray = [UInt8](repeating:0, count:dataLength!)
        value?.copyBytes(to: &dataArray, count: dataLength!)
        print(dataArray[0])
        
        DeviceLockManager.shared().initiateServicesAndCharacteristicsOperation(characteristic: Characteristics.notificationSetting, strService: Services.WifiServiceUUID)
    
    }
    
    func readOTAFileWriteSuccess(characteristic: CBCharacteristic){
        let value = characteristic.value
        let dataLength = value?.count
        var dataArray = [UInt8](repeating:0, count:dataLength!)
        value?.copyBytes(to: &dataArray, count: dataLength!)
        print(dataArray[0])
        if dataArray[0] == 0x00{
            print("Failed")
            self.delegate?.deviceLockManagerOTAFileDownloaded?(value:0)
        }else if dataArray[0] == 0x01{
            print("Progress")
            self.delegate?.deviceLockManagerOTAFileDownloaded?(value:1)
            self.bleManager.readDataWithCharacteristic(characteristic: self.getCharacteristicFromArray(StrCharacteristic: Characteristics.addOTAFile))
        }else if dataArray[0] == 0x02{
            self.delegate?.deviceLockManagerOTAFileDownloaded?(value:2)
            print("Suucess")
        }
    }
    
    func checkNotificationSetting(characteristic: CBCharacteristic){
        let value = characteristic.value
        let dataLength = value?.count
        var dataArray = [UInt8](repeating:0, count:dataLength!)
        value?.copyBytes(to: &dataArray, count: dataLength!)
        print(dataArray)
        if dataArray[0] == 0xFF{
            
        }else if dataArray[0] == 0x00 {
            
        }else if dataArray[0] == 0x01 {
            
        }else{
            
        }
    }
    
    
    func readAESIV(characteristic: CBCharacteristic){
        flgAESIV = "0"
        let value = characteristic.value
        let dataLength = value?.count
        var dataArray = [UInt8](repeating:0, count:dataLength!)
        value?.copyBytes(to: &dataArray, count: dataLength!)
        print(dataArray)
        var strValue = ""
        if dataArray.count != 0{
            for i in 0...dataArray.count-1{
                strValue = strValue + String(format: "%02X", dataArray[i])
            }
            print("---------------------------------------")
            print("strAESIV==\(strValue)\n\n")
             self.delegate?.deviceLockManagerGetAESIV?(strAESIV: strValue)
        }
      
    }
    
}

extension DeviceLockManager: BLEManagerDelegate
{
    func bleManagerDeviceConnected(peripheral: CBPeripheral) {
        if self.delegate != nil {
            self.delegate?.deviceLockManagerDeviceConnected?(periPheralName: peripheral.name!)
        }
    }
    
    func bleManagerGetCharacteristicCompleted(selectedCharacteristic: String) {
        switch selectedCharacteristic {
        case Characteristics.CustomerUnlockVerifyPasswordUUID:
            if flgAESIV == "1"
            {
                self.getAESIV()
            }else{
                self.setVerifyPasswordForDevice()
            }
            
            break
        case Characteristics.CustomerUnlockPasswordUUID:
            self.setLockUnlockDevice(true)
            break
        case Characteristics.RFIDAddCharactesticsUUID:
            self.setNotifyRFIDAddToDevice()
            self.setRFIDIntoDevice()
            break
        case Characteristics.CustomerUnlockPasswordResultUUID:
            self.setNotifyPasswordResultForDevice()
            break
        case Characteristics.GetWifiUUID:
            self.setListOfWifiForDevice()
            break
        case Characteristics.GetWifiPasswordWriteUUID:
            self.setWifiPassword()
            break
        case Characteristics.GetRFIDListUUID:
            self.setNotifyForRFIDList()
            self.setRFIDTogetRfIDFromDevice()
        case Characteristics.GetHistorylUUID:
            self.setNotifyForHistory()
            self.setHistoryFromDevice()
            break
        case Characteristics.GetUserNameUUID:
            self.setNotifyForHistory()
            self.setHistoryFromDevice()
            break
        case Characteristics.Get_Firmware_lock_versionUUID:
            self.setFirmwareVersionFromDevice()
            break
        case Characteristics.GetBatteryLevelUUID:
            self.setBatteryLevelFromDevice()
            break
        case Characteristics.RFIDDeleteUDID:
            self.setNotifyForRFIDDeleteFromTheDevice()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.setRFIDToDeleteRfIDFromDevice()
            }
            
            break
        case Characteristics.setCurrentTimeUUID:
            self.setUpdateTimeNotify()
            self.setCurrentTime()
            self.getCurrentTime()
            break
        case Characteristics.GetMacAddressUUID:
            self.getMacAddress()
            break
        case Characteristics.AddBulkRFID:
            setNotifyForBulkRFID()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.addBulkRFID()
            }
            break
        case Characteristics.shareCodeTime:
            self.setShareCodeWithTime()
            break
        case Characteristics.shareCodeCount:
            self.setShareCodeWithCount()
            break
        case Characteristics.setAlarm:
            self.setAlarm()
            break
        case Characteristics.addOTAFile:
            self.writeOTAFile()
            break
        case Characteristics.setKeycode:
            self.writeKeycode()
            break
        case Characteristics.GetSerialNumber:
            self.getSerialNumber()
            break
        case Characteristics.notificationSetting:
            self.writeNotificationSetting()
            break
        case Characteristics.setLedTimeOut:
            self.writeLedTimeOut()
            break
        case Characteristics.setAutoLockTime:
            self.writeAutoLockTime()
            break
        default:
            break
        }
    }
    
    func bleManagerDidUpdateValueForCharacteristic(characteristic: CBCharacteristic) {
        switch characteristic.uuid.uuidString {
        case Characteristics.CustomerUnlockVerifyPasswordUUID:
            self.readAESIV(characteristic: characteristic)
        case Characteristics.CustomerUnlockPasswordResultUUID:
             self.readUnlockPasswordResultCharacteristic(characteristic: characteristic)
            break
        case Characteristics.RFIDAddCharactesticsUUID:
            self.addRFIDStatus(characteristic: characteristic)
            break
        case Characteristics.GetRFIDListUUID:
            self.readRFIDList(characteristic: characteristic)
            break
        case Characteristics.RFIDDeleteUDID:
            self.deleteRFIDStatusFromTheDevice(characteristic: characteristic)
        case Characteristics.GetWifiUUID:
            self.readWifiList(characteristic: characteristic)
            break
        case Characteristics.GetWifiPasswordWriteUUID:
            self.readWifiPassword(characteristic: characteristic)
            break
        case Characteristics.GetWifiStatusConnUUID:
            self.readWifiConnected(characteristic: characteristic)
            break
        case Characteristics.GetHistorylUUID:
            self.readHistoryLog(characterstic: characteristic)
            break
        case Characteristics.Get_Firmware_lock_versionUUID:
            self.readFirmwarelockversion(characterstic: characteristic)
            break
        case Characteristics.GetBatteryLevelUUID:
            self.readBatteryLevel(characterstic: characteristic)
            break
        case Characteristics.setCurrentTimeUUID:
            self.readCurrentTimeUpdate(characterstic: characteristic)
            break
        case Characteristics.GetMacAddressUUID:
            self.readMacAddress(characteristic: characteristic)
            break
        case Characteristics.AddBulkRFID:
            self.CheckRFIDAadded(characteristic: characteristic)
            break
        case Characteristics.shareCodeCount:
            self.CheckRFIDAadded(characteristic: characteristic)
            break
        case Characteristics.shareCodeTime:
            self.CheckRFIDAadded(characteristic: characteristic)
            break
        case Characteristics.setAlarm:
            self.readAlarm(characteristic: characteristic)
            break
        case Characteristics.addOTAFile:
            self.readOTAFileWriteSuccess(characteristic: characteristic)
            break
        case Characteristics.GetWifiStrgrngthToCheckConnect:
            self.readWifiConnectedUsingRSSI(characteristic: characteristic)
            break
        case Characteristics.GetSerialNumber:
            self.readSerialNumber(characteristic: characteristic)
            break
        case Characteristics.notificationSetting:
            self.checkNotificationSetting(characteristic: characteristic)
            break
        default:
            break
        }
    }
    
    func bleManagerDidWriteValueForCharacteristic(characteristic: String) {
        switch characteristic {
        case Characteristics.setLedTimeOut:
            self.delegate?.deviceLockManagerDidWriteCompleted?(charactristicString: Characteristics.setLedTimeOut)
            break
        case Characteristics.setAutoLockTime:
            self.delegate?.deviceLockManagerDidWriteCompleted?(charactristicString: Characteristics.setAutoLockTime)
            break
        default:
            break
        }
    }
    
    func bleManagerDidUpdateStateError(message: String) {
        delegate?.deviceLockManagerUpdateStateError?(message: message)
    }
    
    func bleManagerDeviceNotFound() {
        delegate?.deviceLockManagerDeviceNotFound?()
    }
    
    func bleManagerSelectedDeviceConnected() {
        self.delegate?.deviceLockManagerSelectedDeviceConnected?()
    }
    
    func bleManagerLynkedPeripheralReConnected() {
        self.delegate?.deviceLockManagerLynkedPeripheralReConnected?()
    }
    
    func bleManagerLoadDevicestableview() {
        delegate?.deviceLockManagerrLoadDevicestableview?()
    }
}
