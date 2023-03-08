//
//  OnboardingViewController.swift
//  TwitterClone
//
//  Created by Hasan YATAR on 4.03.2023.
//

import UIKit
import Firebase
import GoogleSignIn
import Combine

class OnboardingViewController: UIViewController {
    

    private var viewModel = AuthenticationViewViewModel()
    private var subscriptions: Set<AnyCancellable> = []
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = """
        See what's
        happening in the
        world right now.
        """
        label.font = .systemFont(ofSize: 32,weight: .heavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .label
        return label
    }()
    
 
    private let googleAccountButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.cornerStyle = .fixed
        
        configuration.baseBackgroundColor = .systemBackground
        
      
        
        configuration.cornerStyle = .capsule
        let attributes:AttributeContainer = AttributeContainer(
                                            [ NSAttributedString.Key.foregroundColor: UIColor.label,
                                              NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .bold) ])
        configuration.attributedTitle = AttributedString("Continue with Google",attributes: attributes)
        configuration.image = UIImage(named: "google_logo")
        configuration.imagePlacement = .leading
        configuration.imagePadding = 14
        
        let button = UIButton(type:.system)
        button.configuration = configuration
        
       
        button.setBackgroundColor(color: UIColor.red, forState: UIControl.State.highlighted)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderWidth = 1.5
        button.layer.borderColor = UIColor.systemGray2.cgColor
        button.layer.cornerRadius = 30
        button.sizeToFit()
        return button
    }()
    

    
    private let appleAccountButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        
        configuration.baseBackgroundColor = .systemBackground
        let attributes:AttributeContainer = AttributeContainer(
                                            [ NSAttributedString.Key.foregroundColor: UIColor.label,
                                              NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .bold) ])
        configuration.attributedTitle = AttributedString("Continue with Apple",attributes: attributes)
        configuration.image = UIImage(named: "apple_logo")?.withRenderingMode(.alwaysOriginal).withTintColor(.label)
        configuration.cornerStyle = .capsule
        configuration.imagePlacement = .leading
        configuration.imagePadding = 14
        let button = UIButton(type: .system)
       
        button.configuration = configuration
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderWidth = 1.5
        button.layer.borderColor = UIColor.systemGray2.cgColor
        button.layer.cornerRadius = 30
        button.sizeToFit()
        let leftDivider:UIView = UIView()
        let rightDivider:UIView = UIView()
        let orLabel:UILabel = UILabel()
        leftDivider.backgroundColor = .systemGray2
        rightDivider.backgroundColor = .systemGray2
        orLabel.textColor = .systemGray2
        orLabel.text = "Or"
        orLabel.font = .systemFont(ofSize: 14)
        button.addSubview(leftDivider)
        button.addSubview(rightDivider)
        button.addSubview(orLabel)
        
        
        leftDivider.translatesAutoresizingMaskIntoConstraints = false
        leftDivider.topAnchor.constraint(equalTo: button.bottomAnchor,constant: 20).isActive = true
        leftDivider.leadingAnchor.constraint(equalTo: button.leadingAnchor).isActive = true
        leftDivider.widthAnchor.constraint(equalToConstant: button.frame.width/2 + 30).isActive = true
        leftDivider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        orLabel.translatesAutoresizingMaskIntoConstraints = false
        orLabel.centerYAnchor.constraint(equalTo: leftDivider.centerYAnchor).isActive = true
        orLabel.leadingAnchor.constraint(equalTo: leftDivider.trailingAnchor, constant: 10).isActive = true
        
        
        
        rightDivider.translatesAutoresizingMaskIntoConstraints = false
        rightDivider.centerYAnchor.constraint(equalTo: leftDivider.centerYAnchor).isActive = true
        rightDivider.leadingAnchor.constraint(equalTo: orLabel.trailingAnchor ,constant: 10).isActive = true
        rightDivider.trailingAnchor.constraint(equalTo: button.trailingAnchor).isActive = true
        rightDivider.heightAnchor.constraint(equalToConstant: 1).isActive = true

      
        
        
        return button
    }()
    
    
    private let createAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Create account", for: .normal)
        
        button.titleLabel?.font = .systemFont(ofSize: 20,weight: .bold)
        button.backgroundColor = UIColor(red: 29/255, green: 161/255, blue: 242/255, alpha: 1)
        button.layer.masksToBounds = true
        button.tintColor = .white
        button.layer.cornerRadius = 30
        return button
    }()
    
    private let promptLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.tintColor = .gray
        label.text = "Have an account already?"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Log in", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.tintColor = UIColor(red: 29/255, green: 161/255, blue: 242/255, alpha: 1)
        return button
    }()
    
    private func buttonHighlightedState(_ button: UIButton) {
        button.configurationUpdateHandler = { button in
            var config = button.configuration
            config?.background.backgroundColor = button.isHighlighted ?
                .systemGray5
            : .systemBackground
            button.configuration = config
          }
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        twitterLogo()
        view.addSubview(welcomeLabel)
        view.addSubview(promptLabel)
        
        
        
        buttonConfigurations()
        buildSubscriptions()
        configureConstraints()
        
    }
    
    private func buttonConfigurations() {
        view.addSubview(googleAccountButton)
        view.addSubview(appleAccountButton)
        view.addSubview(createAccountButton)
        view.addSubview(loginButton)
        self.buttonHighlightedState(googleAccountButton)
        self.buttonHighlightedState(appleAccountButton)
    
        loginButton.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
        googleAccountButton.addTarget(self, action: #selector(didTapGoogleAccount), for: .touchUpInside)
        createAccountButton.addTarget(self, action: #selector(didTapCreateAccount), for: .touchUpInside)
    }
    
    private func buildSubscriptions(){
        viewModel.$user.sink { [weak self] user in
            guard user != nil else { return }
            guard let vc = self?.navigationController?.viewControllers.first as? OnboardingViewController else { return }
            vc.dismiss(animated: true)
            
        }
        .store(in: &subscriptions)
    }
    
    private func twitterLogo() {
        let size:CGFloat = 36
        let logoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: size, height: size))
        logoImageView.contentMode = .scaleAspectFill
        logoImageView.image = UIImage(named: "twitter_logo")
        
        let middleView = UIView(frame: CGRect(x: 0, y: 0, width: size, height: size))
        middleView.addSubview(logoImageView)
        navigationItem.titleView = middleView
        
    }
    
    @objc private func didTapLogin() {
        let cv = LoginViewController()
        navigationController?.pushViewController(cv, animated: true)
    }
    
    @objc private func didTapGoogleAccount(){
        viewModel.googleSignIn(target: self)
    }
    
    @objc private func didTapCreateAccount() {
      
        let vc = RegisterViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
 
    
    private func configureConstraints() {
        let welcomeLabelConstraints = [
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 40),
            welcomeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20),
          
            welcomeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant: -200)
        ]
        
        let googleAccountButtonConstraints = [
            googleAccountButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            googleAccountButton.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 150),
            googleAccountButton.widthAnchor.constraint(equalTo:  welcomeLabel.widthAnchor, constant: -20),
            googleAccountButton.heightAnchor.constraint(equalToConstant: 60)
        ]
        
        let appleAccountButtonConstraints = [
            appleAccountButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            appleAccountButton.topAnchor.constraint(equalTo: googleAccountButton.bottomAnchor, constant: 10),
            appleAccountButton.widthAnchor.constraint(equalTo: welcomeLabel.widthAnchor, constant: -20),
            appleAccountButton.heightAnchor.constraint(equalToConstant: 60)
        ]
        
        let createAccountButtonConstraints = [
            createAccountButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createAccountButton.topAnchor.constraint(equalTo: appleAccountButton.bottomAnchor, constant: 40),
            createAccountButton.widthAnchor.constraint(equalTo:  welcomeLabel.widthAnchor, constant: -20),
            createAccountButton.heightAnchor.constraint(equalToConstant: 60)
        
        ]
        let promptLabelConstraints = [
            promptLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 40),
            promptLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -60),
        ]
        
        let loginButtonConstraints = [
            loginButton.centerYAnchor.constraint(equalTo: promptLabel.centerYAnchor),
            loginButton.leadingAnchor.constraint(equalTo: promptLabel.trailingAnchor, constant: 10)
        ]
        
        NSLayoutConstraint.activate(welcomeLabelConstraints)
        NSLayoutConstraint.activate(googleAccountButtonConstraints)
        NSLayoutConstraint.activate(appleAccountButtonConstraints)
        NSLayoutConstraint.activate(createAccountButtonConstraints)
        NSLayoutConstraint.activate(promptLabelConstraints)
        NSLayoutConstraint.activate(loginButtonConstraints)
    }

    

}
