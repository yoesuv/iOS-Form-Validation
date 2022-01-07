//
//  RegisterViewModel.swift
//  Form Login & Register
//
//  Created by Yusuf Saifudin on 07/01/22.
//

import Foundation
import Combine

class RegisterViewModel: ObservableObject {
    
    @Published var fullName: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    
    @Published var isFormValid: Bool = false
    
    @Published var inlineErrorFullName: String = ""
    @Published var inlineErrorEmail: String = ""
    @Published var inlineErrorPassword: String = ""
    @Published var inlineErrorConfirmPassword: String = ""
    
    private var cancelables = Set<AnyCancellable>()
    
    init() {
        isFormValidPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.isFormValid, on: self)
            .store(in: &cancelables)
    
        fullNameStatusPublisher
            .dropFirst()
            .receive(on: RunLoop.main)
            .map { status in
                switch status {
                    case .fullNameEmpty:
                        return "fullname empty"
                    case .fullNameNotValid:
                        return "fullname not valid"
                    case .isValid:
                        return ""
                    default:
                        return ""
                }
            }
            .assign(to: \.inlineErrorFullName, on: self)
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
        
        passwordMatchPublisher
            .dropFirst()
            .receive(on: RunLoop.main)
            .map { confirmPasswordStatus in
                switch confirmPasswordStatus {
                    case .passwordDidNotMatch:
                        return "password did not match"
                    case .isValid:
                        return ""
                    default:
                        return ""
                }
            }
            .assign(to: \.inlineErrorConfirmPassword, on: self)
            .store(in: &cancelables)
    }
    
    // MARK: Begin validation full name
    private var isEmptyFullName: AnyPublisher<Bool, Never> {
        $fullName.debounce(for: Constants.debounceTime, scheduler: RunLoop.main)
            .removeDuplicates()
            .map{ $0.isEmpty }
            .eraseToAnyPublisher()
    }
    
    private var isValidFullName: AnyPublisher<Bool, Never> {
        $fullName.debounce(for: Constants.debounceTime, scheduler: RunLoop.main)
            .removeDuplicates()
            .map{ !($0.count > 255) }
            .eraseToAnyPublisher()
    }
    
    private var fullNameStatusPublisher: AnyPublisher<RegisterStatus, Never> {
        Publishers.CombineLatest(isEmptyFullName, isValidFullName)
            .map {
                if $0 { return RegisterStatus.fullNameEmpty }
                if !$1 { return RegisterStatus.fullNameNotValid }
                return RegisterStatus.isValid
            }
            .eraseToAnyPublisher()
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
            .map{ Constants.emailPredicate.evaluate(with: $0) }
            .eraseToAnyPublisher()
    }
    
    private var emailStatusPublisher: AnyPublisher<RegisterStatus, Never> {
        Publishers.CombineLatest(isEmailEmptyPublisher, isEmailValidPublisher)
            .map {
                if $0 { return RegisterStatus.emailEmpty }
                if !$1 { return RegisterStatus.emailNotValid }
                return RegisterStatus.isValid
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
    
    private var passwordStatusPublisher: AnyPublisher<RegisterStatus, Never> {
        Publishers.CombineLatest(isPasswordEmptyPublisher, isPasswordMinValidPublisher)
            .map {
                if $0 { return RegisterStatus.passwordEmpty }
                if $1 { return RegisterStatus.passwordMinLegth }
                return RegisterStatus.isValid
            }
            .eraseToAnyPublisher()
    }
    
    private var passwordMatchPublisher: AnyPublisher<RegisterStatus, Never> {
        Publishers.CombineLatest($password, $confirmPassword)
            .debounce(for: Constants.debounceTime, scheduler: RunLoop.main)
            .map {
                if ($0 != $1) { return RegisterStatus.passwordDidNotMatch }
                return RegisterStatus.isValid
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: Valifation Form email & password
    private var isFormValidPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest4(fullNameStatusPublisher, emailStatusPublisher, passwordStatusPublisher, passwordMatchPublisher)
            .map {
                $0 == RegisterStatus.isValid && $1 == RegisterStatus.isValid && $2 == RegisterStatus.isValid && $3 == RegisterStatus.isValid
            }
            .eraseToAnyPublisher()
    }
    
}
