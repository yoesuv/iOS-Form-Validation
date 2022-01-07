//
//  TextFooter.swift
//  Form Login & Register
//
//  Created by Yusuf Saifudin on 07/01/22.
//

import SwiftUI

// error text footer
struct TextFooter: View {
    var message: String = ""
    var body: some View {
        Text(message).padding(.top, 5).foregroundColor(.red)
    }
}
