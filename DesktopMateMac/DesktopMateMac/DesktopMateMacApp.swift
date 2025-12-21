//
//  DesktopMateMacApp.swift
//  DesktopMateMac
//
//  Created by 中浦芳也 on 2025/12/21.
//

import SwiftUI

@main
struct DesktopMateMacApp: App {
    var body: some Scene {
        WindowGroup {
            CharacterView()
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
    }
}
