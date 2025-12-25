import AppKit
import SwiftUI

// NSObjectクラスを継承
// NSApplicationDelegate に準拠
class AppDelegate: NSObject, NSApplicationDelegate {
//    透明ウィンドウへの参照を保持
    var window: TransparentWindow?
    
//    アプリの起動が完了したら呼び出される
    func applicationDidFinishLaunching(_ notification: Notification) {
//        デフォルトウィンドウをすべて閉じる
        NSApplication.shared.windows.forEach{ $0.close() }
        
//        インスタンスを作成
        let contentView = CharacterView()

//        透明ウィンドウを作成
        window = TransparentWindow(
//            ウィンドウの位置とサイズ
            contentRect: NSRect(x: 0, y: 0, width: 200, height: 200),
            
//            描画方法（バッファリング）
            backing: .buffered,
            
//            初期化を遅延しない
            defer: false
        )
//        SwiftUIのビュー（CharacterView）をAppKitのウィンドウに埋め込む
        window?.contentView = NSHostingView(rootView: contentView)
        
//        ウィンドウを画面中央に配置
        window?.center()
        
//        表示して最前面にする
        window?.makeKeyAndOrderFront(nil)
    }
}
