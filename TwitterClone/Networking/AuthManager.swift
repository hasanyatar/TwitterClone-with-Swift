//
//  AuthManager.swift
//  TwitterClone
//
//  Created by Hasan YATAR on 5.03.2023.
//

import Foundation
import Firebase
import FirebaseAuthCombineSwift
import GoogleSignIn
import Combine

class AuthManager {
    static let shared = AuthManager()
    func registerUser(with email:String, password: String) -> AnyPublisher<User, Error> {
        return Auth.auth().createUser(withEmail: email, password: password)
            .map(\.user)
            .eraseToAnyPublisher()
    }
    
    
   
    
    func signInUser(with credential:AuthCredential) -> AnyPublisher<User,Error> {
        return Auth.auth().signIn(with: credential)
            .map(\.user)
            .eraseToAnyPublisher()
    }
    
    func signInUser(with email: String, password: String) -> AnyPublisher<User,Error> {
        return Auth.auth().signIn(withEmail: email, password: password)
            .map(\.user)
            .eraseToAnyPublisher()
    }
    
}
