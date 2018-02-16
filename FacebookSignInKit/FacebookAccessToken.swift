//
//  FacebookAccessToken.swift
//  FacebookSignInKit
//
//  Created by Carlos Grossi on 24/01/17.
//  Copyright © 2017 Carlos Grossi. All rights reserved.
//

import Foundation
import FBSDKLoginKit

public struct FacebookAccessToken {
    fileprivate var accessToken:FBSDKAccessToken
    public var string:String {
        get {
            return accessToken.tokenString
        }
    }
    
    fileprivate init(accessToken:FBSDKAccessToken) {
        self.accessToken = accessToken
    }
    
    static func accessToken(withAccessToken accessToken:FBSDKAccessToken?) -> FacebookAccessToken? {
        guard let accessToken = accessToken else { return nil }
        return FacebookAccessToken(accessToken: accessToken)
    }

}
