//
//  FacebookSignInController.swift
//  FacebookSignInKit
//
//  Created by Carlos Grossi on 24/01/17.
//  Copyright © 2017 Carlos Grossi. All rights reserved.
//

import Foundation
import FBSDKLoginKit

protocol FacebookSignInControllerDelegate {
    func facebookSignInController(_ controller:FacebookSignInController, willSignInWithButton signInButton: FBSDKLoginButton) -> Bool
    func facebookSignInController(_ controller:FacebookSignInController, signInButton:FBSDKLoginButton, didCompleteWith result:FBSDKLoginManagerLoginResult, withError error:Error?)
    func facebookSignInController(_ controller:FacebookSignInController, didLogoutWithButton signOutButton: FBSDKLoginButton)
}

public class FacebookSignInController: NSObject {
    public static let sharedSignIn = FacebookSignInController()
    fileprivate var loginManager = FBSDKLoginManager()
    
    var delegate:FacebookSignInControllerDelegate?
}

// MARK: -
extension FacebookSignInController {
    
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    public func handle(_ application: UIApplication, url:URL, sourceApplication:String?, annotation:Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    public func currentAccessToken() -> FacebookAccessToken? {
        return FacebookAccessToken.accessToken(withAccessToken: FBSDKAccessToken.current())
    }
    
}

// MARK: - Sign In / Sign Out
extension FacebookSignInController {
    
    public func signIn(from viewController:UIViewController, withReadPermissions readPermissions:[Any], completition:((FacebookLoginResult?, Error?)->())?) {
        loginManager.logIn(withReadPermissions: readPermissions, from: viewController) { (result, error) in
			completition?(FacebookLoginResult.facebookLoginResult(withLoginResult: result), error)
        }
    }
    
    public func signIn(fom viewController:UIViewController, withPublishPermissions publishPermissions:[Any], completition:((FacebookLoginResult?, Error?)->())?) {
        loginManager.logIn(withPublishPermissions: publishPermissions, from: viewController) { (result, error) in
            completition?(FacebookLoginResult.facebookLoginResult(withLoginResult: result), error)
        }
        
    }
    
    public func signOut() {
        loginManager.logOut()
    }
}

// MARK: - GraphRequest
extension FacebookSignInController {
	
	public func graphRequest(at graphPath: String = "me", parameters: [AnyHashable:Any], completion: @escaping ((Any?, Error?) -> ())) {
		FBSDKGraphRequest(graphPath: graphPath, parameters: parameters).start { (_, result, error) in
			completion(result, error)
		}
	}
}


// MARK: -
extension FacebookSignInController {
    
    func addFacebookSignInButton(asSubviewOfView view:UIView, withReadPermissions readPermissions:[Any]) -> UIView {
        let signInButton = FBSDKLoginButton(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        signInButton.readPermissions = readPermissions
        signInButton.delegate = self
        view.addSubview(signInButton)
        
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: signInButton, attribute: .leading, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: signInButton, attribute: .trailing, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: signInButton, attribute: .top, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: signInButton, attribute: .bottom, multiplier: 1, constant: 0))
        
        return view
    }
    
}

// MARK: - FBSDKLoginButtonDelegate
extension FacebookSignInController: FBSDKLoginButtonDelegate {
    
    public func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        guard let delegate = delegate else { return false }
        return delegate.facebookSignInController(self, willSignInWithButton: loginButton)
    }
    
    public func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        delegate?.facebookSignInController(self, signInButton: loginButton, didCompleteWith: result, withError: error)
    }
    
    public func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        delegate?.facebookSignInController(self, didLogoutWithButton: loginButton)
    }
    
}
