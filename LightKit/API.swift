//
//  API.swift
//  Lights
//
//  Created by Nathan Borror on 5/12/15.
//  Copyright (c) 2015 Nathan Borror. All rights reserved.
//

import Foundation
import Alamofire

public enum APIErrorCode: Int {
    case IPFail = 100
    case Fail = 200
}

public class API: NSObject {

    let defaults = NSUserDefaults(suiteName: "group.com.nathanborror.Lights.Documents")

    public class var shared:API {
        struct Singleton {
            static let instance:API = API()
        }
        return Singleton.instance
    }

    override init() {
        super.init()
    }

    func request(method: Alamofire.Method, path: String, params: [String: AnyObject], error: ((code: APIErrorCode, description: String) -> Void)?) {
        if let ip = self.defaults?.objectForKey("ip") as? String {
            let domain = "http://\(ip)"

            Alamofire.request(method, "\(domain)\(path)", parameters: params, encoding: .JSON)
                .responseJSON { (request, response, json, err) in
                    if
                        let list = json as? [AnyObject],
                        let first = list.first as? [String: NSObject],
                        let errorObj = first["error"] as? [String: NSObject],
                        let description = errorObj["description"] as? String
                    {
                        error?(code: APIErrorCode.Fail, description: description)
                    }
            }
        } else {
            error?(code: APIErrorCode.IPFail, description: "IP not found")
        }
    }

    public func refresh(#error: ((APIErrorCode, String) -> Void)?) {
        let params = ["devicetype": "Lights App", "username": "newdeveloper"]
        self.request(.POST, path: "/api", params: params, error: error)
    }

    public func on(#error: ((APIErrorCode, String) -> Void)?) {
        let path = "/api/newdeveloper/groups/0/action"
        let params = ["on": true, "bri": 255]
        self.request(.PUT, path: path, params: params, error: error)
    }

    public func off(#error: ((APIErrorCode, String) -> Void)?) {
        let path = "/api/newdeveloper/groups/0/action"
        let params = ["on": false]
        self.request(.PUT, path: path, params: params, error: error)
    }

    public func setIP(ip: String) {
        self.defaults?.setObject(ip, forKey: "ip")
    }

}