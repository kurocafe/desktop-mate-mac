import SwiftUI

struct CharacterView: View {
    var body: some View {
        ZStack {
            // 透明背景（確認用に一時的に半透明の色を使う）
            Color.blue.opacity(0.3)
            
            // テキスト表示（後で画像に置き換える）
            Text("Desktop Mate")
                .foregroundColor(.white)
                .font(.title)
        }
        .frame(width: 200, height: 200)
    }
}

#Preview {
    CharacterView()
}
