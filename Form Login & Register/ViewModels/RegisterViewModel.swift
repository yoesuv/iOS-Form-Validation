//
//  RegisterViewModel.swift
//  Form Login & Register
//
//  Created by Yusuf Saifudin on 07/01/22.
//

import Foundation

class RegisterViewModel: ObservableObject {
    
    @Published var fullName: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    
    @Published var isFormValid: Bool = false
    
}
