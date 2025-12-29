import XCTest
@testable import DesktopMateMac

final class AnimaitonStateTests: XCTestCase {
    
//    テスト前に実行される
    override func setUpWithError() throws {
//        初期化処理
    }
    
//    テスト前に実行される
    override func tearDownWithError() throws {
//        クリーンアップ処理
    }
    
//    テスト１： ループする場合のフレーム進行
    func testNextFrameWithLooping() {
//        Arrenge（準備）
        var state = AnimationState()
        state.frameCount = 3
        state.isLooping = true
        state.currentFrame = 0
        
//        Act（実行）& Assert（検証）
        state.nextFrame()
        XCTAssertEqual(state.currentFrame, 1, "1フレーム進むはず")
        
        state.nextFrame()
        XCTAssertEqual(state.currentFrame, 2, "2フレーム目に進むはず")
        
        state.nextFrame()
        XCTAssertEqual(state.currentFrame, 0, "ループして0に戻るはず")
    }
    
//    テスト２： ループしない場合のフレーム進行
    func testNextFrameWithoutLooping() {
//        Arrange
        var state = AnimationState()
        state.frameCount = 3
        state.isLooping = false
        state.currentFrame = 0
        
//        Act & Assert
        state.nextFrame()
        XCTAssertEqual(state.currentFrame, 1)
        
        state.nextFrame()
        XCTAssertEqual(state.currentFrame, 2)
        
//        最終のフレームで止まるはず
        state.nextFrame()
        XCTAssertEqual(state.currentFrame, 2, "最終のフレームで止まるはず")
        
//        もう一度読んでも変わらない
        state.nextFrame()
        XCTAssertEqual(state.currentFrame, 2, "まだ２で止まっているはず")
    }
    
//    テスト３： デフォルト値の確認
    func testDefaultValues() {
//        Arrange & Act
        let state = AnimationState()
        
//        Assert
        XCTAssertEqual(state.currentFrame, 0, "初期フレームは０")
        XCTAssertEqual(state.frameCount, 3, "デフォルトは３フレーム")
        XCTAssertEqual(state.fps, 2.0, "デフォルトFPSは2.0")
        XCTAssertTrue(state.isLooping, "デフォルトはループする")
    }
    
//    テスト４： 1フレームだけの場合
    func testSingleFrame() {
//        Arrange
        var state = AnimationState()
        state.frameCount = 1
        state.isLooping = false
        
//        Act & Assert
        XCTAssertEqual(state.currentFrame, 0)
        
        state.nextFrame()
        XCTAssertEqual(state.currentFrame, 0, "1フレームなので常に0")
        
        state.nextFrame()
        XCTAssertEqual(state.currentFrame, 0, "まだ0")
    }
    
//    テスト５： 大量のフレーム数でも動作するか
    func testManyFrames() {
//        Arrange
        var state = AnimationState()
        state.frameCount = 100
        state.isLooping = true
        
//        Act: 200回進める
        for _ in 0..<200 {
            state.nextFrame()
        }
        
//        Assert: 200 % 100 = 0
        XCTAssertEqual(state.currentFrame, 0, "200回進めたら0に戻る")
    }
}
