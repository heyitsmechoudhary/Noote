//
//  hideKeyboardExtention.swift
//  Noote
//
//  Created by Rahul choudhary on 27/03/25.
//

import SwiftUI

#if canImport(UIKit)
extension View {
    func hidekeyboard(){
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil , from: nil, for: nil)
    }
}
#endif
