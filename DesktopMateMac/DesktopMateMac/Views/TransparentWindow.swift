import AppKit
import SwiftUI

class TransparentWindow: NSWindow {
    init(contentRect: NSRect, backing: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(
            contentRect: contentRect,
            styleMask: [.borderless, .fullSizeContentView],
            backing: backing,
            defer: flag
        )
        
        // 透明背景の設定
        self.isOpaque = false
        self.backgroundColor = .clear
        self.hasShadow = false
        
        // 常に最前面
        self.level = .floating
        
        // 全てのスペースに表示
        self.collectionBehavior = [.canJoinAllSpaces, .stationary]
        
        // タイトルバーを非表示
        self.titleVisibility = .hidden
        self.titlebarAppearsTransparent = true
        
        // ウィンドウの移動を有効化
        self.isMovableByWindowBackground = false
    }
}
