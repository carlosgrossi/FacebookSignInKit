//
//  FacebookLoginResult.swift
//  FacebookSignInKit
//
//  Created by Carlos Grossi on 24/01/17.
//  Copyright © 2017 Carlos Grossi. All rights reserved.
//

import Foundation
import FBSDKLoginKit

public struct FacebookLoginResult {
    fileprivate var loginResult:FBSDKLoginManagerLoginResult
    
    fileprivate init(loginResult:FBSDKLoginManagerLoginResult) {
        self.loginResult = loginResult
    }
    
    static func facebookLoginResult(withLoginResult loginResult:FBSDKLoginManagerLoginResult?) -> FacebookLoginResult? {
        guard let loginResult = loginResult else { return nil }
        return FacebookLoginResult(loginResult: loginResult)
    }
    
}

// MARK: -
extension FacebookLoginResult {
    
    public func accessToken() -> String? {
		FBSDKProfile.current()
        return FBSDKAccessToken.current()?.tokenString
    }
    
}
