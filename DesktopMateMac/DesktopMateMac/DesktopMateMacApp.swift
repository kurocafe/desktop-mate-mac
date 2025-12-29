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
