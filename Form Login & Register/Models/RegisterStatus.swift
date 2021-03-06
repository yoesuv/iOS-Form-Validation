//
//  RegisterStatus.swift
//  Form Login & Register
//
//  Created by Yusuf Saifudin on 07/01/22.
//

import Foundation

enum RegisterStatus {
    case fullNameEmpty
    case fullNameNotValid
    case emailEmpty
    case emailNotValid
    case passwordEmpty
    case passwordMinLegth
    case passwordDidNotMatch
    case isValid
}
