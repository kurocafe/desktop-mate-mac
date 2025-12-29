import SwiftUI

struct CharacterView: View {
//    ウィンドウへの参照を保持する状態変数
    @State private var window: NSWindow?
//    ドラッグ中かどうか
    @State private var isDragging = false
    
    var body: some View {
//        Z軸方向に重ねるコンテナ（奥から手前に重ねる）
        ZStack {
//            ウィンドウアクセサリー
            WindowAccessor(window: $window)
            
            // 透明背景（確認用に一時的に半透明の色を使う）
            Color.blue.opacity(0.3)
            
            // テキスト表示（後で画像に置き換える）
            Text("Desktop Mate")
                .foregroundColor(.white)
                .font(.title)
        }
        .frame(width: 200, height: 200)
        .contentShape(Rectangle())
        .gesture(
            DragGesture()
                .onChanged{ value in
                    isDragging = true
                    
                    guard let window = window else { return }
                    
//                    現在のウィンドウの位置
                    var origin = window.frame.origin
                    
//                    ドラッグの移動量を加算
                    origin.x += value.translation.width
//                    macは下が0なのでマイナス
                    origin.y -= value.translation.height
                    
//                    ウィンドウを移動
                    window.setFrameOrigin(origin)
                }
                .onEnded{ _ in
                    isDragging = false
                }
        )
//        ドラッグ中は少し透明に
        .opacity(isDragging ? 0.8 : 1.0)
    }
}

#Preview {
    CharacterView()
}
