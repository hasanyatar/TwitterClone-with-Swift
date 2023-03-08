//
//  DatabaseManager.swift
//  TwitterClone
//
//  Created by Hasan YATAR on 7.03.2023.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseFirestoreCombineSwift
import Combine

class DatabaseManager {
    static let shared = DatabaseManager()
    
    let db = Firestore.firestore()
    let usersPath: String = "users"
    
    func collectionUsers(add user: User) -> AnyPublisher<Bool,Error> {
        let twitterUser = TwitterUser(from: user)
        return db.collection(usersPath).document(twitterUser.id).getDocument()
            .tryMap { snapshot in
                if !snapshot.exists {
                   try snapshot.reference.setData(from: twitterUser){ error in
                       if let error { print(error.localizedDescription)}
                    }}
                return true
            }.eraseToAnyPublisher()
    }
    
    
    func collectionUsers(retreive id:String) -> AnyPublisher<TwitterUser, Error> {
        db.collection(usersPath).document(id).getDocument()
            .tryMap { try $0.data(as: TwitterUser.self) }
            .eraseToAnyPublisher()
    }
    
   
    

}
