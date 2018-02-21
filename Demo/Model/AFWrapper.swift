//
//  AFWrapper.swift
//  AFSwiftDemo
//
//  Created by Ashish on 10/4/16.
//  Copyright © 2016 Ashish Kakkad.All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class AFWrapper: NSObject {
    
    class func requestGETURL(_ strURL: String, success:@escaping (Dictionary<String,Any>) -> Void, failure:@escaping (Error) -> Void) {
        Alamofire.request(strURL).responseJSON { (responseObject) -> Void in
            
            print(responseObject)
            print(strURL)
            if responseObject.result.isSuccess {
                let resJson = responseObject.result.value!
                success(resJson as! Dictionary)
            }
            if responseObject.result.isFailure {
                let error : Error = responseObject.result.error!
                failure(error)
            }
        }
    }
    
    class func requestPOSTURL(_ strURL : String, params : [String : AnyObject]?, headers : [String : String]?, success:@escaping (Dictionary<String,Any>) -> Void, failure:@escaping (Error) -> Void){
        
        Alamofire.request(strURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in
            print(strURL)
            print(responseObject)
            if responseObject.result.isSuccess {
                let resJson = responseObject.result.value!
                success(resJson as! Dictionary<String, Any>)
            }
            if responseObject.result.isFailure {
                let error : Error = responseObject.result.error!
                failure(error)
            }
        }
    }
    
    class func requestPostURLForUploadImage(_ strURL : String,isImageSelect : Bool,fileName : String, params : [String : AnyObject]?,image : UIImage, success:@escaping (Dictionary<String,Any>) -> Void, failure:@escaping (Error) -> Void){
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
                            success(resJson as! Dictionary<String, Any>)
                        }
                    }
                }
            case .failure(let error):
                failure(error)
            }
        }
    }
 
    func parseDataWithPost(params : Dictionary<String, String>, urlString: String)
    {
        if Validation1.isConnectedToNetwork()
        {
            
            Alamofire.upload(
                multipartFormData: { multipartFormData in
                    
                    for (key, value) in params
                    {
                        multipartFormData.append((value.data(using: .utf8))!, withName: key)
                    }
            },
                to: urlString,
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.responseJSON { response in
                            
                            //Success
                            if (response.result.value as? [String:Any]) != nil
                            {
                                //self.delegate?.success(WithResponse: response.result.value!)
                            }
                            else
                            {
                               // self.delegate?.someThingWentWrong()
                            }
                        }
                        upload.uploadProgress(queue: DispatchQueue(label: "uploadQueue"), closure: { (progress) in
                            
                            
                        })
                        
                    case .failure( _):
                        break 
                       // self.delegate?.someThingWentWrong()
                    }
            }
                
            )
            
        }
        else
        {
            //self.delegate?.noInternetConnection()
        }
    }
}
/*success(resJson as! Dictionary<String, Any>)
   failure(error)*/
