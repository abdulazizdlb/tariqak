import SwiftUI

struct HomeView: View {
    @State private var homeAddress = ""
    @State private var workAddress = ""
    @State private var showToast = false
    
    let onCalculate: (Commute) -> Void
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 12) {
                    Image(systemName: "car.fill")
                        .font(.system(size: 48))
                        .foregroundColor(.blue)
                    
                    Text("احسب أفضل وقت للمغادرة")
                        .font(.title2)
                        .fontWeight(.medium)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 20)
                
                // Address Inputs
                VStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "house.fill")
                            Text("عنوان المنزل")
                                .font(.headline)
                        }
                        
                        TextField("أدخل عنوان منزلك", text: $homeAddress)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "building.2.fill")
                            Text("عنوان العمل")
                                .font(.headline)
                        }
                        
                        TextField("أدخل عنوان عملك", text: $workAddress)
                            .textFieldStyle(.roundedBorder)
                    }
                }
                
                // Calculate Button
                Button(action: handleCalculate) {
                    HStack(spacing: 8) {
                        Image(systemName: "arrow.right.circle.fill")
                        Text("احسب الآن")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .disabled(!isFormValid)
                .opacity(isFormValid ? 1.0 : 0.6)
                
                Spacer(minLength: 20)
            }
            .padding(.horizontal, 20)
        }
        .navigationTitle("طريقك")
        .environment(\.layoutDirection, .rightToLeft)
    }
    
    private var isFormValid: Bool {
        !homeAddress.trimmingCharacters(in: .whitespaces).isEmpty &&
        !workAddress.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    private func handleCalculate() {
        let commute = Commute(
            homeAddress: homeAddress.trimmingCharacters(in: .whitespaces),
            workAddress: workAddress.trimmingCharacters(in: .whitespaces)
        )
        
        onCalculate(commute)
    }
}
