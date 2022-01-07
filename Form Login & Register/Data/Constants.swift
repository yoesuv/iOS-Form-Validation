//
//  Constants.swift
//  Form Login & Register
//
//  Created by Yusuf Saifudin on 07/01/22.
//

import Foundation
import SwiftUI


struct Constants{
    static let debounceTime: RunLoop.SchedulerTimeType.Stride = 0.1
    static let emailPredicate = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
}
