//
//  ContentView.swift
//  iOS_Week1_ASS1
//
//  Created by 김지민 on 3/22/25.
//

import SwiftUI

struct RootView: View {
    @AppStorage("isLoggedIn") var isLoggedIn = false
    @AppStorage("email") private var savedEmail = ""
    @AppStorage("pwd") private var savedPwd = ""
    var body: some View {
        if isLoggedIn {
            MyTabView()
        } else {
            LoginView()
        }
    }
}

#Preview {
    RootView()
}
