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
    
    private var cancelables = Set<AnyCancellable>()
    
    init() {
        
    }
    
    private var isEmailEmptyPublisher: AnyPublisher<Bool, Never> {
        $email.debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map{ $0.isEmpty }
            .eraseToAnyPublisher()
    }
    
    private var isEmailValidPublisher: AnyPublisher<Bool, Never> {
        $email.debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map{ $0.count >= 3 }
            .eraseToAnyPublisher()
    }
    
    private var isPasswordValidPublisher: AnyPublisher<Bool, Never> {
        $password.debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map{ $0.isEmpty }
            .eraseToAnyPublisher()
    }
    
    private var isPasswordMinValidPublisher: AnyPublisher<Bool, Never> {
        $password.debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map{ $0.count > 4 }
            .eraseToAnyPublisher()
    }
    
    private var isEmailStatusPublisher: AnyPublisher<LoginStatus, Never> {
        Publishers.CombineLatest(isPasswordValidPublisher, isPasswordMinValidPublisher)
            .map {
                if $0 { return LoginStatus.passwordEmpty }
                if $1 { return LoginStatus.passwordNotValid }
                return LoginStatus.isValid
            }
            .eraseToAnyPublisher()
    }
    
    private var isPasswordStatusPublisher: AnyPublisher<LoginStatus, Never> {
        Publishers.CombineLatest(isEmailEmptyPublisher, isEmailValidPublisher)
            .map {
                if $0 { return LoginStatus.emailEmpty }
                if $1 { return LoginStatus.emailNotValid }
                return LoginStatus.isValid
            }
            .eraseToAnyPublisher()
    }
    
    
}
