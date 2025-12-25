import SwiftUI

@main
struct DesktopMateMacApp: App {
//    SwiftUIアプリにAppDelegateを接続
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
//    Appインターフェースを実装
    var body: some Scene {
//        「設定」メニュー用のシーン
        Settings {
            EmptyView()
        }
    }
}
