
import Foundation

enum AnimationType {
    case idle
    case walk
    case react
}

struct AnimationState {
    var currentFrame: Int = 0
    var frameCount: Int = 3
    var fps: Double = 2.0
    var isLooping: Bool = true
    
    mutating func nextFrame() {
        if isLooping {
            currentFrame = (currentFrame + 1) % frameCount
        } else {
            if currentFrame < frameCount - 1 {
                currentFrame += 1
            }
        }
    }
}
