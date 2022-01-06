//
//  LoginViewModel.swift
//  Form Login & Register
//
//  Created by Yusuf Saifudin on 06/01/22.
//

import Foundation

class LoginViewModel: ObservableObject {
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isValid: Bool = false
    
}
