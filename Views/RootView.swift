import SwiftUI

struct RootView: View {
    var body: some View {
        NavigationStack {
            HomeView()
                .navigationTitle("Tariqak")
        }
        // اتجاه RTL للتناسق
        .environment(\.layoutDirection, .rightToLeft)
    }
}
