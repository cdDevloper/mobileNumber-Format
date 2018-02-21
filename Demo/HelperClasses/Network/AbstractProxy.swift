//
//  AbstractProxy.swift
//  LYNKD
//
//  Created by Ashish Chaudhary on 11/29/17.
//  Copyright © 2017 Magneto IT solutions Pvt Ltd. All rights reserved.
//

import UIKit
import Alamofire
import Log

typealias  CompleteionHandler   = ((_ responseObject:Any?) -> Void)
typealias  FailureHandler       = ((_ errorMessage: String) -> Void)

class AbstractProxy: NSObject {
    
    var completeionBlock: CompleteionHandler?
    var failureBlock: FailureHandler?
    
    // Declare Headers
    func setHeadersWithoutXAPIKey(_ mutableURLRequest: NSMutableURLRequest) {
        mutableURLRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        mutableURLRequest.addValue("application/json", forHTTPHeaderField: "Accept")
    }
    
    // Create Complete URL
    func getCompleteUrl(_ url: String) -> String {
        
        let baseUrl: String = URLConstant.BaseUrl
        
        var completedURL: String = ""
        let url1 = url
        
        if !url.isEmpty && !baseUrl.isEmpty {
            
            let imageURL = url[url.startIndex] == "/" ? String(url1.substring(from: url1.characters.index(after: url1.startIndex))) : url1
            completedURL = baseUrl[baseUrl.characters.index(before: baseUrl.endIndex)] != "/" ? String(baseUrl + "/") : baseUrl
            completedURL.append(imageURL)
            
        }
        return completedURL
    }
    
    // GET
    func GET(_ url: String,
             postData: [String: AnyObject],
             requestName: String) -> DataRequest? {
        
        var modifiedUrlString = ""
        if requestName == RequestName.GetPlanDetail {
            modifiedUrlString = getUrlFromDictionaryWithoutEqual(postData)
        } else {
            modifiedUrlString = getUrlFromDictionary(postData)
        }
        
        let finalUrl = url + modifiedUrlString
        print(finalUrl)
        let requestUrl = finalUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let mutableURLRequest: NSMutableURLRequest
        mutableURLRequest = NSMutableURLRequest(url: URL(string: requestUrl!)!)
        mutableURLRequest.httpMethod = "GET"
        self.setHeadersWithoutXAPIKey(mutableURLRequest)
        return self.callAPI(mutableURLRequest, requestName: requestName)
    }
    
    func GET_FROM_GOOGLE_API(_ requestUrl: String, requestName: String) -> DataRequest? {
        let mutableURLRequest = NSMutableURLRequest(url: URL(string: requestUrl)!)
        mutableURLRequest.httpMethod = "GET"
        self.setHeadersWithoutXAPIKey(mutableURLRequest)
        return self.callAPI(mutableURLRequest, requestName: requestName)
    }
    
    // POST
    func POST(_ requestUrl: String, postData: [String: AnyObject], requestName: String) -> DataRequest? {
        
        let mutableURLRequest = NSMutableURLRequest(url: URL(string: requestUrl)!)
        mutableURLRequest.httpMethod = "POST"
        self.setHeadersWithoutXAPIKey(mutableURLRequest)
        do {
            mutableURLRequest.httpBody = try JSONSerialization.data(withJSONObject: postData, options: .prettyPrinted)
        } catch {
            print(error)
            return nil
        }
        return self.callAPI(mutableURLRequest, requestName: requestName)
    }
    
    // PUT
    func PUT(_ requestUrl: String, postData: [String: AnyObject], requestName: String) -> DataRequest? {
        
        let mutableURLRequest = NSMutableURLRequest(url: URL(string: self.getCompleteUrl(requestUrl))!)
        mutableURLRequest.httpMethod = "PUT"
        self.setHeadersWithoutXAPIKey(mutableURLRequest)
        do {
            mutableURLRequest.httpBody = try JSONSerialization.data(withJSONObject: postData, options: .prettyPrinted)
        } catch {
            print(error)
            return nil
        }
        return self.callAPI(mutableURLRequest, requestName: requestName)
    }
    
    // DELETE
    func DELETE(_ requestUrl: String, deleteData: NSDictionary, requestName: String) -> DataRequest? {
        
        let mutableURLRequest = NSMutableURLRequest(url: URL(string: self.getCompleteUrl(requestUrl))!)
        mutableURLRequest.httpMethod = "DELETE"
        self.setHeadersWithoutXAPIKey(mutableURLRequest)
        do {
            mutableURLRequest.httpBody = try JSONSerialization.data(withJSONObject: deleteData, options: .prettyPrinted)
        } catch {
            print(error)
            return nil
        }
        return    self.callAPI(mutableURLRequest, requestName: requestName)
    }
    
    func callAPI(_ mutableURLRequest: NSMutableURLRequest, requestName: String) -> DataRequest {
        
        Print.Log.info("******** Headers: \(String(describing: mutableURLRequest.allHTTPHeaderFields))")
        
        return  Alamofire.request((mutableURLRequest as URLRequest) as URLRequestConvertible)
            
            .responseJSON { (response) -> Void in
                
                guard response.result.isSuccess else {
                    
                    Print.Log.info("Error: NOT SUCCESS \(String(describing: response.result.error))")
                    
                    self.failureCallback(response.result.error! as NSError, requestName: requestName)
                    
                    return
                }
                
                guard let value = response.result.value else {
                    
                    Print.Log.info("Error: \(String(describing: response.result.error))")
                    
                    self.failureCallback(response.result.error! as NSError, requestName: requestName)
                    
                    return
                }
                
                Print.Log.info("Response: \(value)")
                self.successCallback(value as AnyObject, headers: (response.response?.allHeaderFields)!, requestName: requestName)
        }
    }
    
    func successCallback(_ response: AnyObject, headers: [AnyHashable : Any], requestName: String) {
    }
    
    func failureCallback(_ error: NSError, requestName: String) {
    }
    
    func failureCallbackWithSatusMessage(_ error: NSError, requestName: String, _ response: AnyObject) {
    }
    
    func callPostAPI(_ mutableURLRequest: NSMutableURLRequest, requestName: String) {
        
        Print.Log.info("******** Headers: \(String(describing: mutableURLRequest.allHTTPHeaderFields))")
        
        Alamofire.request((mutableURLRequest as URLRequest) as URLRequestConvertible)
            .responseString { response in
                Print.Log.info("Success: \(response.result.isSuccess)")
                Print.Log.info("Response String: \(String(describing: response.result.value))")
        }
        
    }
    
    func callResponseStringAPI(_ mutableURLRequest: NSMutableURLRequest, requestName: String) {
        
        guard let url = mutableURLRequest as? URLRequestConvertible else {fatalError("Cannot to convert to URLRequestConvertible")}
        
        Alamofire.request(url)
            
            .responseString { (response) -> Void in
                
                Print.Log.info("Response: \(response)")
        }
    }
    
    func requestPostURLForUploadImage(_ strURL : String,
                                      isImageSelect : Bool,
                                      fileName : String,
                                      params : [String : AnyObject]?,
                                      image : UIImage,
                                      successHandler: @escaping (Bool, [String: AnyObject]) -> Void,
                                      failureHandler: @escaping (Bool?, String) -> Void){
        var imgName = ""
        let timeStamp = NSNumber(value: Date().timeIntervalSince1970)
        imgName = fileName + "." +  String(describing: timeStamp) + ".png"
        Alamofire.upload(multipartFormData: { multipartFormData in
            if isImageSelect == true{
                let imgData = UIImageJPEGRepresentation(image, 0.2)!
                multipartFormData.append(imgData, withName: fileName,fileName:imgName, mimeType: "image/jpg")
            }
            for (key, value) in params! {
                multipartFormData.append(value.data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
        },
                         to:strURL)     { (result) in
                            switch result {
                            case .success(let upload, _ ,_ ):
                                upload.uploadProgress(closure: { (progress) in
                                    print("Upload Progress: \(progress.fractionCompleted)")
                                })
                                
                                upload.responseJSON { response in
                                    let resJson = response.result.value
                                    if resJson != nil{
                                        
                                        let res = resJson as! Dictionary<String, Any>
                                        
                                        if res.count > 0 {
                                            successHandler(true, (response.result.value as? [String: AnyObject])!)
                                        }
                                    }
                                }
                            case .failure(let error):
                                failureHandler(false, error as! String)
                            }
        }
    }
    
    func getUrlFromDictionary(_ dictionary: [String : AnyObject]) -> String {
        var strURL = ""
        for (key, value) in dictionary {
            strURL=strURL+"&"+key+"="+(value as! String)
        }
        strURL = String(strURL.dropFirst(1))
        return strURL
    }
    
    func getUrlFromDictionaryWithoutEqual(_ dictionary: [String : AnyObject]) -> String {
        var strURL = ""
        for (key, value) in dictionary {
            strURL=strURL+"&"+key+(value as! String)
        }
        strURL = String(strURL.dropFirst(1))
        return strURL
    }
    
    /*
     func postMultipartData(_ imageData: Data,
     mediaType: String?,
     successHandler: @escaping (Bool, [String: AnyObject]) -> Void,
     progressHandler: @escaping (Float?) -> Void,
     failureHandler: @escaping (Bool?, String) -> Void) {
     
     let imageUrlString = URLConstant.BaseUrl + URLConstant.Files
     var headers: HTTPHeaders?
     if SESSIONDATA.authToken != nil && SESSIONDATA.authToken.length > 0 {
     let apiSessionKeyValue: String = SESSIONDATA.authToken
     headers = HTTPHeaders.init(dictionaryLiteral: ("Authorization", apiSessionKeyValue))
     }
     
     Alamofire.upload(multipartFormData: { (multipartFormData) in
     if mediaType == MediaType.Image {
     multipartFormData.append(imageData, withName: "file", fileName: "file", mimeType: "image/jpeg")
     } else if mediaType == MediaType.Video {
     multipartFormData.append(imageData, withName: "file", fileName: "file", mimeType: "video/mp4")
     }
     
     }, to: imageUrlString,
     headers:headers,
     encodingCompletion: { (result) in
     
     switch result {
     
     case .success(let upload, _, _):
     
     upload.responseJSON { (response) -> Void in
     
     guard response.result.isSuccess else {
     failureHandler(false, (response.result.error?.localizedDescription)!)
     return
     }
     
     Print.Log.info("File uploading completed / ", response.result)
     
     successHandler(true, (response.result.value as? [String: AnyObject])!)
     }
     
     upload.uploadProgress(closure: { (progress) in
     Print.Log.info("Total Size: \(progress.totalUnitCount), Upload Progress: \(progress.fractionCompleted)")
     progressHandler(Float(progress.fractionCompleted))
     })
     
     case .failure(let encodingError):
     
     failureHandler(false, "Error")
     Print.Log.info("File uploading failed: \(encodingError)")
     }
     })
     }*/
}
