# 設計書

## 1. システムアーキテクチャ

### 全体構成
```
┌─────────────────────────────────────┐
│    Desktop Mate Mac Application     │
├─────────────────────────────────────┤
│  Presentation Layer (SwiftUI)       │
│  - CharacterView                    │
│  - SettingsView                     │
│  - TransparentWindow                │
├─────────────────────────────────────┤
│  Business Logic Layer               │
│  - CharacterViewModel               │
│  - AnimationController              │
│  - MovementController               │
│  - InteractionHandler               │
├─────────────────────────────────────┤
│  Data Layer                         │
│  - Character (Model)                │
│  - Settings (UserDefaults)          │
│  - AnimationState                   │
├─────────────────────────────────────┤
│  Services                           │
│  - AssetLoader                      │
│  - WindowManager                    │
│  - TimerService                     │
└─────────────────────────────────────┘
```

### レイヤーの責務

**Presentation Layer**
- UI表示
- ユーザー入力の受付
- ViewModelとのバインディング

**Business Logic Layer**
- アニメーション制御
- 移動ロジック
- 状態管理

**Data Layer**
- データモデル定義
- 設定の永続化

**Services**
- 画像読み込み
- ウィンドウ操作
- タイマー管理

## 2. データモデル

### Character
```swift
struct Character {
    let id: UUID
    let name: String
    var position: CGPoint          // 現在位置
    var size: CGSize               // 表示サイズ
    var currentAnimation: AnimationType
    var direction: Direction       // 向き（左/右）
}

enum AnimationType {
    case idle    // 待機
    case walk    // 歩行
    case react   // 反応
}

enum Direction {
    case left
    case right
}
```

### AnimationState
```swift
struct AnimationState {
    var currentFrame: Int = 0
    var frames: [String]          // 画像ファイル名のリスト
    var fps: Double               // フレームレート
    var isLooping: Bool           // ループするか
}
```

### Settings
```swift
struct Settings: Codable {
    var characterSize: CGFloat = 200     // デフォルト200px
    var launchAtLogin: Bool = false
    var alwaysOnTop: Bool = true
    
    // Phase 2
    var autoWalkEnabled: Bool = true
    var walkInterval: TimeInterval = 60   // 待機時間（秒）
    
    // 将来的な拡張用
    var animationSpeed: Double = 1.0
}
```

### MovementState
```swift
struct MovementState {
    var isMoving: Bool = false
    var targetPosition: CGPoint?
    var speed: CGFloat = 2.0      // 移動速度（px/frame）
}
```

## 3. 画面設計

### メインウィンドウ（CharacterView）
```
┌─────────────────┐
│                 │
│   [キャラ画像]   │  ← 透明背景
│                 │     サイズ可変
│                 │     ドラッグ可能
└─────────────────┘

- サイズ: 可変（100px〜300px）
- 背景: 完全透過
- タイトルバー: なし
- 常に最前面: true
```

### 設定ウィンドウ（SettingsView）
```
┌────────────────────────────────┐
│  Desktop Mate 設定              │
├────────────────────────────────┤
│                                │
│  キャラクターサイズ             │
│  ├─────●──────┤  200px         │
│  100         300               │
│                                │
│  ☑ ログイン時に自動起動           │
│                                │
│  [閉じる]                       │
└────────────────────────────────┘
```

## 4. アニメーション仕様

### 待機アニメーション
```
フレーム数: 2-3枚
FPS: 2-3
ループ: 無限
例: idle_01.png → idle_02.png → idle_01.png ...
```

### 歩行アニメーション
```
フレーム数: 左3枚、右3枚
FPS: 8-10
ループ: 移動中のみ
例（左向き）: 
  walk_left_01.png → walk_left_02.png → walk_left_03.png → ...
```

### 反応アニメーション
```
フレーム数: 2-3枚
FPS: 5-6
ループ: 1回のみ
例: react_01.png → react_02.png → react_03.png → 待機に戻る
```

## 5. 動作フロー

### 起動フロー
```
1. アプリ起動
   ↓
2. 設定読み込み（UserDefaults）
   ↓
3. アセット読み込み（画像）
   ↓
4. 透明ウィンドウ作成
   ↓
5. 初期位置に配置（画面中央）
   ↓
6. 待機アニメーション開始
```

### 自動移動フロー（Phase 2）
```
待機状態
   ↓
タイマー（30秒〜2分、ランダム）
   ↓
目的地をランダム決定
   ↓
向きを決定（left/right）
   ↓
歩行アニメーション開始
   ↓
目的地まで移動（毎フレーム少しずつ）
   ↓
到着
   ↓
待機アニメーションに切り替え
```

### クリック時のフロー（Phase 3）
```
待機 or 歩行中
   ↓
ユーザーがクリック
   ↓
現在のアニメーションを中断
   ↓
反応アニメーション再生（1回）
   ↓
元の状態に戻る
```

### ドラッグ時のフロー
```
ユーザーがドラッグ開始
   ↓
アニメーション一時停止
   ↓
マウス座標に追従
   ↓
ドラッグ終了
   ↓
その位置で待機アニメーション再開
```

## 6. ファイル構成
```
DesktopMateMac/
├── DesktopMateMac/
│   ├── App/
│   │   ├── DesktopMateMacApp.swift       # エントリーポイント
│   │   └── AppDelegate.swift             # アプリライフサイクル
│   │
│   ├── Views/
│   │   ├── CharacterView.swift           # メインビュー
│   │   ├── TransparentWindow.swift       # 透明ウィンドウ
│   │   └── SettingsView.swift            # 設定画面（Phase 4）
│   │
│   ├── ViewModels/
│   │   ├── CharacterViewModel.swift      # キャラクター状態管理
│   │   └── SettingsViewModel.swift       # 設定管理（Phase 4）
│   │
│   ├── Models/
│   │   ├── Character.swift               # キャラクターモデル
│   │   ├── AnimationState.swift          # アニメーション状態
│   │   ├── MovementState.swift           # 移動状態
│   │   └── Settings.swift                # 設定モデル
│   │
│   ├── Controllers/
│   │   ├── AnimationController.swift     # アニメーション制御
│   │   ├── MovementController.swift      # 移動制御（Phase 2）
│   │   └── InteractionHandler.swift      # クリック処理（Phase 3）
│   │
│   ├── Services/
│   │   ├── AssetLoader.swift             # 画像読み込み
│   │   ├── WindowManager.swift           # ウィンドウ操作
│   │   └── TimerService.swift            # タイマー管理
│   │
│   ├── Utils/
│   │   ├── Extensions.swift              # 拡張メソッド
│   │   └── Constants.swift               # 定数定義
│   │
│   └── Resources/
│       ├── Assets.xcassets/
│       │   └── Characters/
│       │       └── Default/
│       │           ├── Idle/
│       │           │   ├── idle_01.png
│       │           │   └── idle_02.png
│       │           ├── Walk/
│       │           │   ├── walk_left_01.png
│       │           │   ├── walk_left_02.png
│       │           │   ├── walk_left_03.png
│       │           │   ├── walk_right_01.png
│       │           │   ├── walk_right_02.png
│       │           │   └── walk_right_03.png
│       │           └── React/
│       │               ├── react_01.png
│       │               └── react_02.png
│       └── Info.plist
│
└── DesktopMateMacTests/
    └── （テストコード）
```

## 7. 技術仕様

### 使用フレームワーク
```swift
import SwiftUI          // UI構築
import AppKit           // ウィンドウ操作
import Combine          // 状態管理・リアクティブプログラミング
import Foundation       // 基本機能
```

### ウィンドウ設定
```swift
// 透明ウィンドウの作成
let window = NSWindow(
    contentRect: NSRect(x: 0, y: 0, width: 200, height: 200),
    styleMask: [.borderless],
    backing: .buffered,
    defer: false
)
window.isOpaque = false
window.backgroundColor = .clear
window.level = .floating              // 常に最前面
window.collectionBehavior = [.canJoinAllSpaces]
window.ignoresMouseEvents = false     // クリック可能
```

### アニメーション実装
```swift
// Timerを使った実装例
Timer.publish(every: 1.0 / fps, on: .main, in: .common)
    .autoconnect()
    .sink { _ in
        // フレームを進める
        currentFrame = (currentFrame + 1) % frames.count
    }
```

### 画面範囲チェック
```swift
func isWithinScreen(position: CGPoint) -> Bool {
    guard let screen = NSScreen.main else { return true }
    let screenFrame = screen.visibleFrame
    return screenFrame.contains(position)
}
```

## 8. 設定の永続化

### UserDefaults を使用
```swift
extension UserDefaults {
    static let characterSizeKey = "characterSize"
    static let launchAtLoginKey = "launchAtLogin"
    
    var characterSize: CGFloat {
        get { CGFloat(double(forKey: Self.characterSizeKey)) }
        set { set(newValue, forKey: Self.characterSizeKey) }
    }
}
```

## 9. パフォーマンス最適化

### 画像のキャッシュ
- 起動時に全画像を読み込み、メモリにキャッシュ
- アニメーション中の画像読み込みを避ける

### タイマーの効率化
- 必要な時だけタイマーを動かす
- バックグラウンド時はアニメーション停止

### メモリ管理
- 使わない画像は解放
- ViewModelで循環参照に注意（weak/unowned）

## 10. エラーハンドリング

### 画像が見つからない場合
```swift
guard let image = NSImage(named: imageName) else {
    print("Error: Image not found - \(imageName)")
    return defaultImage  // デフォルト画像を返す
}
```

### 設定読み込み失敗
```swift
// デフォルト値を使用
let settings = Settings()
```

## 11. 開発の進め方

### Phase 1（Week 1-2）
1. プロジェクト構造の作成
2. TransparentWindow の実装
3. CharacterView に画像1枚表示
4. ドラッグ移動の実装
5. AnimationController で待機アニメーション

### Phase 2（Week 3-4）
1. MovementController の実装
2. ランダム移動ロジック
3. 画面端検出
4. 歩行アニメーションと移動の連動

### Phase 3（Week 5-6）
1. InteractionHandler の実装
2. クリック検出
3. 反応アニメーション再生

### Phase 4（Week 7-8）
1. SettingsView の実装
2. サイズ変更機能
3. ログイン時自動起動

## 12. テスト項目

### 機能テスト
- [ ] ウィンドウが透明で表示される
- [ ] ドラッグで移動できる
- [ ] 待機アニメーションがループする
- [ ] 歩行アニメーションが正しく再生される
- [ ] ランダムに移動開始する
- [ ] 画面外に出ない
- [ ] クリックで反応する
- [ ] 設定が保存される
- [ ] ログイン時に自動起動する

### パフォーマンステスト
- [ ] CPU使用率が5%以下
- [ ] メモリ使用量が100MB以下
- [ ] アニメーションが滑らか
- [ ] バッテリー消費が少ない

### 互換性テスト
- [ ] macOS 14で動作
- [ ] Intelチップで動作
- [ ] Apple Siliconで動作
- [ ] Retinaディスプレイで正しく表示

## 13. 将来の拡張性

### 考慮事項
- 複数キャラクター対応（キャラクターID管理）
- プラグインシステム（カスタムアニメーション）
- 外部連携API（天気、カレンダー）
- クラウド同期（設定の共有）

### 拡張しやすい設計
- Protocol指向（AnimationProvider など）
- Dependency Injection
- モジュール分割