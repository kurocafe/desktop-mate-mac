//
//  DesktopMateMacApp.swift
//  DesktopMateMac
//
//  Created by 中浦芳也 on 2025/12/21.
//

import SwiftUI

@main
struct DesktopMateMacApp: App {
//    Appインターフェースを実装
    var body: some Scene {
        WindowGroup {
//            表示したいViewを書く
            CharacterView()
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
    }
}
