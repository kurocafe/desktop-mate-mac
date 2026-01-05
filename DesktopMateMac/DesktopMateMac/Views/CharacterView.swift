import SwiftUI

struct CharacterView: View {
//    ウィンドウへの参照を保持する状態変数
    @State private var window: NSWindow?
//    ドラッグ中かどうか
    @State private var isDragging = false

//    アニメーション用
    @State private var animationState = AnimationState()
    @State private var animationTimer: Timer?

//    移動コントローラー
    @StateObject private var movementController = MovementController()
    
//    画像ファイル名リスト
    private let idleFrames = ["idle_01", "idle_02", "idle_03"]
    private let walkLeftFrames = ["walk_left_01", "walk_left_02", "walk_left_03"]
    private let walkRightFrames = ["walk_right_01", "walk_right_02", "walk_right_03"]
    
//    現在の画像名
    private var currentImageName: String {
        let imageName: String
        
        switch animationState.animationType {
        case .idle:
            imageName = idleFrames[animationState.currentFrame]
        case .walk:
            switch animationState.direction {
            case .left:
                imageName = walkLeftFrames[animationState.currentFrame]
            case .right:
                imageName = walkRightFrames[animationState.currentFrame]
            }
        case .react:
            imageName = idleFrames[animationState.currentFrame] // 仮
        }
        
        print("画像: \(imageName)")
        
        return imageName
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
                .frame(width: 400, height: 400)
        }
        .frame(width: 400, height: 400)
        .contentShape(Rectangle())
        .gesture(
            DragGesture()
                .onChanged{ value in
                    if !isDragging {
//                        ドラッグすると移動停止
                        movementController.stopAllTimers()
                        switchToIdle()
                    }
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
                    
//                    ドラッグ終了後、次の移動をスケジュール
                    scheduleNextMovement()
                }
        )
//        ドラッグ中は少し透明に
        .opacity(isDragging ? 0.8 : 1.0)
//        ビューが表示されたらアニメーション開始
        .onAppear{
            startAnimation()
            
//            最初の移動をスケジュール
            scheduleNextMovement()
        }
//        ビューが消えたらアニメーション停止
        .onDisappear{
            stopAnimation()
            movementController.stopAllTimers()
        }
        .onChange(of: movementController.isMoving) { isMoving in
            //        移動し終わったら待機に戻る
            if !isMoving && animationState.animationType == .walk {
                switchToIdle()
                scheduleNextMovement()
            }
        }
    }
    
//    アニメーション開始
    private func startAnimation() {
        animationTimer = Timer.scheduledTimer(
            withTimeInterval: 0.1,
            repeats: true
        ) { _ in
            let interval = 1.0 / animationState.fps
//            fpsに応じてフレームを更新
            if Date().timeIntervalSince1970.truncatingRemainder(dividingBy: interval) < 0.1 {
                animationState.nextFrame()
            }
        }
    }
    
//    アニメーション停止
    private func stopAnimation() {
        animationTimer?.invalidate()
        animationTimer = nil
    }
    
//    待機アニメーションに切り替え
    private func switchToIdle() {
        print("待機モードに切り替え")
        animationState.animationType = .idle
        animationState.fps = 2.0
        animationState.currentFrame = 0
    }
    
//    歩行アニメーションに切り替え
    private func switchToWalk(direction: Direction) {
        print("歩行アニメーションに切り替え（向き: \(direction == .left ? "左" : "右")）")
        animationState.animationType = .walk
        animationState.direction = direction
        animationState.fps = 8.0
        animationState.currentFrame = 0
    }
    
//    次の移動をスケジュール
    private func scheduleNextMovement() {
        movementController.scheduleNextMovement { [self] in
            guard let window = window else {
                return
            }
            let currentPosition = window.frame.origin

            movementController.startRandomMovement(from: currentPosition, in: window) { target, direction in
                switchToWalk(direction: direction)

            }
        }
    }
}

#Preview {
    CharacterView()
}
