//
//  ContentView.swift
//  Form Login & Register
//
//  Created by Yusuf Saifudin on 01/11/21.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject private var viewModel = LoginViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Email")) {
                        TextField("Email", text: $viewModel.email)
                            .autocapitalization(.none)
                    }
                    Section(header: Text("Password")) {
                        SecureField("Password", text: $viewModel.password)
                    }
                }
                Button(action: {
                    
                }, label: {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(height: 60)
                        .overlay(Text("LOGIN").foregroundColor(.white))
                        
                })
                .padding()
                .disabled(!$viewModel.isValid.wrappedValue)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
