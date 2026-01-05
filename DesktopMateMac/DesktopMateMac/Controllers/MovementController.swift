import Foundation
import AppKit
import Combine

class MovementController: ObservableObject {
    @Published var isMoving = false
    @Published var targetPosition: CGPoint?
    
    private var moveTimer: Timer?
    private var waitTimer: Timer?
    
//    1フレームあたりの移動距離（ピクセル）
    let speed: CGFloat = 2.0
    
//    移動開始
    func startRandomMovement(
        from currentPosition: CGPoint, in
        window: NSWindow?,
        completion: @escaping(CGPoint, Direction) -> Void){
            guard let screen = NSScreen.main else {
                return
            }
            
//            ランダムな目的地を決定
            let screenFrame = screen.visibleFrame
            let randomX = CGFloat.random(in: screenFrame.minX...screenFrame.maxX - 200)
            let randomY = CGFloat.random(in: screenFrame.minY...screenFrame.maxY - 200)
            
            targetPosition = CGPoint(x: randomX, y: randomY)
            
//            向きを決定
            let direction: Direction = randomX < currentPosition.x ? .left : .right
            
            print("目的地: (\(randomX), \(randomY)), 向き: \(direction == .left ? "左" : "右")")
            
            isMoving = true
            completion(targetPosition!, direction)
            
//            移動開始
            startMoving(window: window)
        }
    
//    移動処理
    private func startMoving(window: NSWindow?) {
        moveTimer = Timer.scheduledTimer(withTimeInterval: 1.0 / 30.0, repeats: true) { [weak self] _ in
            guard let self = self,
                  let window = window,
                  let target = self.targetPosition else {
                return
            }
            
            var currentOrigin = window.frame.origin
            
//            目的地までの距離を計算
            let dx = target.x - currentOrigin.x
            let dy = target.y - currentOrigin.y
            let distance = sqrt(dx * dx + dy * dy)
            
//            到着判定
            if distance < self.speed {
//                到着
                window.setFrameOrigin(target)
                self.stopMoving()
                print("目的地に到着〜")
                return
            }
            
//            移動（目的地方向に speed ピクセル進む）
            let ratio = self.speed / distance
            currentOrigin.x += dx * ratio
            currentOrigin.y += dy * ratio
            
            window.setFrameOrigin(currentOrigin)
        }
    }
    
    func stopMoving() {
        moveTimer?.invalidate()
        moveTimer = nil
        isMoving = false
        targetPosition = nil
    }
    
//    待機タイマー開始
    func scheduleNextMovement(completion: @escaping () -> Void) {
//        30秒〜60秒のランダムな待機時間
        let waitTime = Double.random(in: 30...60)
        print("\(Int(waitTime))秒後に移動開始")
        
        waitTimer = Timer.scheduledTimer(withTimeInterval: waitTime, repeats: false) { _ in
            completion()
        }
    }
    
//    タイマーをすべて停止
    func stopAllTimers() {
        moveTimer?.invalidate()
        moveTimer = nil
        waitTimer?.invalidate()
        waitTimer = nil
    }
}
