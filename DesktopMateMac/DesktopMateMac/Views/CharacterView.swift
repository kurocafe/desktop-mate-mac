import SwiftUI

struct CharacterView: View {
//    ウィンドウへの参照を保持する状態変数
    @State private var window: NSWindow?
//    ドラッグ中かどうか
    @State private var isDragging = false
    
//    アニメーション用
    @State private var animationState = AnimationState()
    @State private var animationTimer: Timer?
    
//    画像ファイル名リスト
    private let idleFrames = ["idle_01", "idle_02", "idle_03"]
    
//    現在の画像名
    private var currentImageName: String {
        idleFrames[animationState.currentFrame]
    }
    
    var body: some View {
//        Z軸方向に重ねるコンテナ（奥から手前に重ねる）
        ZStack {
//            ウィンドウアクセサリー
            WindowAccessor(window: $window)
            
            // 透明背景
            Color.clear
            
            // アニメーションする画像
            Image(currentImageName)
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
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
        .onAppear{
            startAnimation()
        }
        .onDisappear{
            stopAnimation()
        }
    }
    
//    アニメーション開始
    private func startAnimation() {
        let interval = 1.0 / animationState.fps
        
        animationTimer = Timer.scheduledTimer(
            withTimeInterval: interval,
            repeats: true
        ) { _ in
            animationState.nextFrame()
        }
    }
    
//    アニメーション停止
    private func stopAnimation() {
        animationTimer?.invalidate()
        animationTimer = nil
    }
}

#Preview {
    CharacterView()
}
