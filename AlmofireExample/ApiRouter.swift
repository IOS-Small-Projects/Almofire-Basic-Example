//
//  ApiRouter.swift
//  AlmofireExample
//
//  Created by Rohit on 05/10/16.
//  Copyright © 2016 Introp. All rights reserved.
//

import Foundation
import Alamofire

class User{
    let name: String
    let number: Int
    
    init(name: String,number: Int){
        self.name = name
        self.number = number
    }
}

// MARK: Router for each separate functionality

enum Router: URLRequestConvertible {
    case createUser(parameters: User)
    case readUser(username: String)
    case updateUser(username: String, parameters: User)
    case destroyUser(username: String)
    
    static let baseURLString = "https://httpbin.org/"
    
    var method: Alamofire.Method {
        switch self {
        case .createUser:
            return .POST
        case .readUser:
            return .GET
        case .updateUser:
            return .PUT
        case .destroyUser:
            return .DELETE
        }
    }
    
    var path: String {
        switch self {
        case .createUser:
            return "/get"
        case .readUser(let username):
            return "/users/\(username)"
        case .updateUser(let username, _):
            return "/users/\(username)"
        case .destroyUser(let username):
            return "/users/\(username)"
        }
    }
    
    var URLRequest: NSMutableURLRequest {
        let result: (path: String, method: Alamofire.Method, parameters: [String: AnyObject]) = {
            switch self {
            case .readUser:
                return (path, method, [String: AnyObject]())
//            case .Tags(let contentID):
//                let params = [ "content" : contentID ]
//                return ("/tagging", .GET, params)
//            case .Colors(let contentID):
//                let params = [ "content" : contentID, "extract_object_colors" : NSNumber(int: 0) ]
//                return ("/colors", .GET, params)
           default:
                return (path, method, [String: AnyObject]())
            }
        }()
        
        let URL = NSURL(string: Router.baseURLString)!
        let URLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(result.path))
        URLRequest.HTTPMethod = result.method.rawValue
//        URLRequest.setValue(ImaggaRouter.authenticationToken, forHTTPHeaderField: "Authorization")
        URLRequest.timeoutInterval = NSTimeInterval(10 * 1000)
        
        let encoding = Alamofire.ParameterEncoding.URL
        
        return encoding.encode(URLRequest, parameters: result.parameters).0
    }
}

// MARK: Using router
//Alamofire.request(readUser).validate().responseJSON { response in
//    switch response.result {
//    case .success:
//        print("Validation Successful")
//    case .failure(let error):
//        print(error)
//    }
//}
