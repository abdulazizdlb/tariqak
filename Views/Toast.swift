import SwiftUI

// مكوّن التوست
struct ToastView: View {
    let text: String

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(.white)
            Text(text)
                .foregroundStyle(.white)
                .font(.subheadline)
                .bold()
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(.black.opacity(0.85))
        .clipShape(Capsule())
        .shadow(radius: 10)
        .padding(.bottom, 24)
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

// مُعدِّل عرض/إخفاء التوست
struct ToastModifier: ViewModifier {
    @Binding var isPresented: Bool
    let text: String
    let duration: TimeInterval

    func body(content: Content) -> some View {
        ZStack {
            content
            if isPresented {
                VStack {
                    Spacer()
                    ToastView(text: text)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
                .animation(.spring(response: 0.35, dampingFraction: 0.9), value: isPresented)
            }
        }
        .onChange(of: isPresented) { shown in
            guard shown else { return }
            // إخفاء تلقائي بعد المدة
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                withAnimation { isPresented = false }
            }
        }
    }
}

// إضافة ميثود مختصر على أي View
extension View {
    func toast(isPresented: Binding<Bool>, text: String, duration: TimeInterval = 2.0) -> some View {
        self.modifier(ToastModifier(isPresented: isPresented, text: text, duration: duration))
    }
}
