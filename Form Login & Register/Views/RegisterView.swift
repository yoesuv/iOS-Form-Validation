//
//  RegisterView.swift
//  Form Login & Register
//
//  Created by Yusuf Saifudin on 07/01/22.
//

import SwiftUI

struct RegisterView: View {
    
    @StateObject private var viewModel = RegisterViewModel()
    
    var body: some View {
        VStack {
            Form {
                Section(
                    header: Text("Full Name"),
                    footer: TextFooter(message: $viewModel.inlineErrorFullName.wrappedValue),
                    content: {
                        TextField("Full Name", text: $viewModel.fullName)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                    })
                Section(
                    header: Text("Email"),
                    footer: TextFooter(message: $viewModel.inlineErrorEmail.wrappedValue),
                    content: {
                        TextField("Email", text: $viewModel.email)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                        
                    })
                Section(
                    header: Text("Password"),
                    footer: TextFooter(message: $viewModel.inlineErrorPassword.wrappedValue),
                    content: {
                        SecureField("Password", text: $viewModel.password)
                    })
                Section(
                    header: Text("Confirm Password"),
                    footer: TextFooter(message: $viewModel.inlineErrorConfirmPassword.wrappedValue),
                    content: {
                        SecureField("Confirm Password", text: $viewModel.confirmPassword)
                    })
            }
            Button(action: {
                
            }, label: {
                RoundedRectangle(cornerRadius: 10)
                    .frame(height: 60)
                    .overlay(Text("REGISTER").foregroundColor(.white))
                    
            })
            .padding()
            .disabled(!$viewModel.isFormValid.wrappedValue)
        }
        .navigationBarTitle("Register")
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
