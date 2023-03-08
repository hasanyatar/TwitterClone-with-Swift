//
//  RegisterViewModel.swift
//  TwitterClone
//
//  Created by Hasan YATAR on 4.03.2023.
//

import Foundation
import Firebase
import GoogleSignIn
import Combine
final class AuthenticationViewViewModel: ObservableObject {
    @Published var email: String?
    @Published var password: String?
    @Published var isAuthenticationFormValid: Bool = false
    @Published var credential: AuthCredential?
    @Published var user: User?
    @Published var error: String?
    
    
    private var subscriptions: Set<AnyCancellable> = []
    
    func validateAuthenticationForm() {
        guard let email = email,
              let password = password else {
            isAuthenticationFormValid = false
            return
        }
        isAuthenticationFormValid = isValidEmail(email) && password.count >= 8
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func createUser() {
        guard let email = email ,
              let password = password else { return }
        AuthManager.shared.registerUser(with: email, password: password)
            .handleEvents(receiveOutput: { [weak self] user in
                self?.user = user
            })
            .sink { [weak self] completion in
                
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] user in
                self?.createRecord(for: user)
              
            }.store(in: &subscriptions)
    }
    
    
    func createRecord(for user: User) {
        DatabaseManager.shared.collectionUsers(add: user)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { state in
                print("Addink user record to database: \(state)")
            }.store(in: &subscriptions)
            
    }
    
    
    
    
    
    func loginUser() {
        guard let email = email ,
              let password = password else { return }
        AuthManager.shared.signInUser(with: email, password: password)
            .sink { [weak self] completion in
                
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
                
            } receiveValue: { [weak self] user in
                self?.user = user
            }.store(in: &subscriptions)
    }
    
    
    
    func googleSignIn(target vc:UIViewController) {
        googleSignInConfiguration(target: vc)
        self.$credential.sink {  credential in
            guard let credential else { return }
            AuthManager.shared.signInUser(with: credential)
                .handleEvents(receiveOutput: { [weak self] user in
                    self?.user = user
                })
                .sink { _ in
                } receiveValue: { [weak self] user in
                    self?.createRecord(for: user)
                }.store(in: &(self.subscriptions))
        }.store(in: &subscriptions)
     
    }
    
    private func googleSignInConfiguration(target vc:UIViewController) {
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return  }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
            GIDSignIn.sharedInstance.signIn(withPresenting: vc.self) { [weak self] result, error in
                guard error == nil else { return }
                
                guard let user = result?.user,
                      let idToken = user.idToken?.tokenString else { return  }
                
                self?.credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                               accessToken: user.accessToken.tokenString)
                
            }
        
        
       
    }
}
