//
//  iOS_Week1_ASS1App.swift
//  iOS_Week1_ASS1
//
//  Created by 김지민 on 3/22/25.
//

import SwiftUI

@main
struct iOS_Week1_ASS1App: App {
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
        var body: some Scene {
            WindowGroup {
                RootView()
            }
        }
}
