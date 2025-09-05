import SwiftUI

struct HomeView: View {
    @State private var homeAddress: String = ""
    @State private var workAddress: String = ""
    @State private var selectedDays: [Int] = []  // نخليها للأيام

    var body: some View {
        VStack(spacing: 16) {
            Text("طريقك")
                .font(.largeTitle)
                .bold()

            TextField("أدخل عنوان المنزل", text: $homeAddress)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            TextField("أدخل عنوان العمل", text: $workAddress)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            Button("احسب الآن") {
                // نجهّز البيانات
                var prefs = UserPrefs()
                prefs.homeAddress = homeAddress
                prefs.workAddress = workAddress
                prefs.weekdays = selectedDays

                // نخزّنها
                UserPrefsStore.shared.save(prefs)
            }
            .buttonStyle(.borderedProminent)
            .padding(.top, 20)
        }
    }
}
