//
//  AuthManageer.swift
//  KocYKS
//
//  Created by Fetih Tunay Yetişir on 19.12.2020.
//

import Foundation
import FirebaseAuth


public class FirebaseAuthManager {
    public static let shared = FirebaseAuthManager()

    public var auth = Auth.auth()

    // MARK: - Auth methods

    public func registerUserWith(email: String, password: String, completion: @escaping (_ result: AuthDataResult?, _ error: Error?) -> ()) {

        auth.createUser(withEmail: email, password: password, completion: { (result, error) in
            completion(result, error)
        })
    }

    public func loginWith(credential: AuthCredential, completion: @escaping (_ result: AuthDataResult?, _ error: Error?) -> ()) {

        auth.signInAndRetrieveData(with: credential) { result, error in
            completion(result, error)
        }
    }

    public func loginUser(email: String, password: String, completion: @escaping (_ result: AuthDataResult?, _ error: Error?) -> Void) {
        auth.signIn(withEmail: email, password: password) { (result, error) in
            completion(result, error)
        }
    }

    public func signOut(success: @escaping () -> Void, failure: ((NSError) -> Void)? = nil) {
        do {
            try auth.signOut()
            success()
        } catch let signOutError as NSError {
            failure?(signOutError)
        }
    }

    public func resetPassword(email: String, completion: @escaping (_ error: Error?) -> Void) {
        auth.sendPasswordReset(withEmail: email, completion: { (error) in
            completion(error)
        })
    }

    public func checkIfUserIsLoggedIn(success: @escaping () -> Void, failure: (() -> Void)? = nil) {
        auth.addStateDidChangeListener { auth, user in
            if let _ = user {
                // User is signed in
                success()
            } else {
                failure?()
            }
        }
    }
}








