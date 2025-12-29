// AppKitは古く、SwiftUIは新しいUI
// 透明ウィンドウはAppKit, キャラクター表示はSwiftUI
import SwiftUI
import AppKit

struct WindowAccessor: NSViewRepresentable{
    @Binding var window: NSWindow?
    
    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        
        DispatchQueue.main.async {
            self.window = view.window
        }
        
        return view
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {
//        現状何もない
    }
}
