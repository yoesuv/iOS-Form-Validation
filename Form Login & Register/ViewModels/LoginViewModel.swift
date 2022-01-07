//
//  LoginViewModel.swift
//  Form Login & Register
//
//  Created by Yusuf Saifudin on 06/01/22.
//

import Foundation
import Combine

class LoginViewModel: ObservableObject {
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isFormValid: Bool = false
    
    @Published var inlineErrorEmail: String = ""
    @Published var inlineErrorPassword: String = ""
    
    private var cancelables = Set<AnyCancellable>()
    
    init() {
        isFormValidPublisher.receive(on: RunLoop.main)
            .assign(to: \.isFormValid, on: self)
            .store(in: &cancelables)
        
        emailStatusPublisher
            .dropFirst()
            .receive(on: RunLoop.main)
            .map { emailStatus in
                switch emailStatus {
                    case .emailEmpty:
                        return "email is empty"
                    case .emailNotValid:
                        return "email is not valid"
                    case .isValid:
                        return ""
                    default:
                        return ""
                }
            }
            .assign(to: \.inlineErrorEmail, on: self)
            .store(in: &cancelables)
        
        passwordStatusPublisher
            .dropFirst()
            .receive(on: RunLoop.main)
            .map { passwordStatus in
                    switch passwordStatus {
                    case .passwordEmpty:
                        return "password is empty"
                    case .passwordMinLegth:
                        return "password min 5 character"
                    case .isValid:
                        return ""
                    default:
                        return ""
                }
            }
            .assign(to: \.inlineErrorPassword, on: self)
            .store(in: &cancelables)
    }
    
    // MARK: Begin Validation Email
    private var isEmailEmptyPublisher: AnyPublisher<Bool, Never> {
        $email.debounce(for: Constants.debounceTime, scheduler: RunLoop.main)
            .removeDuplicates()
            .map{ $0.isEmpty }
            .eraseToAnyPublisher()
    }
    
    private var isEmailValidPublisher: AnyPublisher<Bool, Never> {
        $email.debounce(for: Constants.debounceTime, scheduler: RunLoop.main)
            .removeDuplicates()
            .map{ $0.count < 5 }
            .eraseToAnyPublisher()
    }
    
    private var emailStatusPublisher: AnyPublisher<LoginStatus, Never> {
        Publishers.CombineLatest(isEmailEmptyPublisher, isEmailValidPublisher)
            .map {
                if $0 { return LoginStatus.emailEmpty }
                if $1 { return LoginStatus.emailNotValid }
                return LoginStatus.isValid
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: Begin validation Password
    private var isPasswordEmptyPublisher: AnyPublisher<Bool, Never> {
        $password.debounce(for: Constants.debounceTime, scheduler: RunLoop.main)
            .removeDuplicates()
            .map{ $0.isEmpty }
            .eraseToAnyPublisher()
    }
    
    private var isPasswordMinValidPublisher: AnyPublisher<Bool, Never> {
        $password.debounce(for: Constants.debounceTime, scheduler: RunLoop.main)
            .removeDuplicates()
            .map{ $0.count < 5 }
            .eraseToAnyPublisher()
    }
    
    private var passwordStatusPublisher: AnyPublisher<LoginStatus, Never> {
        Publishers.CombineLatest(isPasswordEmptyPublisher, isPasswordMinValidPublisher)
            .map {
                if $0 { return LoginStatus.passwordEmpty }
                if $1 { return LoginStatus.passwordMinLegth }
                return LoginStatus.isValid
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: Valifation Form email & password
    private var isFormValidPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(emailStatusPublisher, passwordStatusPublisher)
            .map {
                $0 == LoginStatus.isValid && $1 == LoginStatus.isValid
            }
            .eraseToAnyPublisher()
    }
    
}
