import SwiftUI

struct HomeView: View {
    @StateObject private var vm = HomeViewModel()
    private let weekdayNames = ["السبت","الأحد","الاثنين","الثلاثاء","الأربعاء","الخميس","الجمعة"]

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.white, Color(UIColor.systemGroupedBackground)]),
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .trailing, spacing: 20) {
                    Text("طريقك")
                        .font(.system(size: 34, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.top, 8)

                    VStack(alignment: .trailing, spacing: 16) {
                        Group {
                            LabeledField(title: "منزلي") {
                                TextField("أدخل عنوان المنزل", text: $vm.home)
                                    .textInputAutocapitalization(.never)
                                    .autocorrectionDisabled()
                                    .multilineTextAlignment(.trailing)
                            }
                            LabeledField(title: "عملي") {
                                TextField("أدخل عنوان العمل", text: $vm.work)
                                    .textInputAutocapitalization(.never)
                                    .autocorrectionDisabled()
                                    .multilineTextAlignment(.trailing)
                            }
                        }

                        VStack(alignment: .trailing, spacing: 8) {
                            Text("أيام الذهاب").font(.headline)
                            FlexibleChips(names: weekdayNames, selection: $vm.selectedDays)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }

                        VStack(alignment: .trailing, spacing: 8) {
                            Text("الفترة المعتادة للخروج").font(.headline)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                            HStack(spacing: 12) {
                                VStack(alignment: .trailing) {
                                    Text("من").font(.subheadline)
                                    DatePicker("", selection: $vm.windowStart, displayedComponents: .hourAndMinute)
                                        .labelsHidden()
                                }.frame(maxWidth: .infinity, alignment: .trailing)
                                VStack(alignment: .trailing) {
                                    Text("إلى").font(.subheadline)
                                    DatePicker("", selection: $vm.windowEnd, displayedComponents: .hourAndMinute)
                                        .labelsHidden()
                                }.frame(maxWidth: .infinity, alignment: .trailing)
                            }
                            .environment(\.locale, Locale(identifier: "ar"))
                        }

                        Button(action: { vm.calculateNow() }) {
                            Text("احسب الآن")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.accentColor)
                                .foregroundColor(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                                .shadow(color: Color.black.opacity(0.08), radius: 8, y: 4)
                        }
                        .padding(.top, 4)
                    }
                    .padding(16)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .shadow(color: Color.black.opacity(0.06), radius: 12, y: 6)

                    VStack(alignment: .center, spacing: 10) {
                        Text("أفضل وقت اليوم").font(.headline)
                        Text(vm.bestTimeString).font(.system(size: 36, weight: .bold))
                        Text("المدة المتوقعة: \(vm.expectedDuration) دقيقة")
                            .foregroundStyle(.secondary).font(.subheadline)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(20)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .shadow(color: Color.black.opacity(0.06), radius: 12, y: 6)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
        }
        .environment(\.layoutDirection, .rightToLeft)
    }
}

private struct LabeledField<Content: View>: View {
    let title: String
    @ViewBuilder var content: Content
    var body: some View {
        VStack(alignment: .trailing, spacing: 6) {
            Text(title).font(.headline)
            content
                .padding(12)
                .background(Color(UIColor.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

private struct FlexibleChips: View {
    let names: [String]
    @Binding var selection: Set<Int>
    var body: some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        return ZStack(alignment: .topLeading) {
            ForEach(Array(names.enumerated()), id: \.offset) { idx, name in
                chip(name: name, isOn: selection.contains(idx))
                    .padding(.vertical, 4)
                    .alignmentGuide(.leading) { d in
                        if (abs(width - d.width) > UIScreen.main.bounds.width - 80) {
                            width = 0; height -= d.height + 8
                        }
                        let r = width
                        if idx == names.count - 1 { width = 0 } else { width -= d.width + 8 }
                        return r
                    }
                    .alignmentGuide(.top) { _ in
                        let r = height
                        if idx == names.count - 1 { height = 0 }
                        return r
                    }
                    .onTapGesture {
                        if selection.contains(idx) { selection.remove(idx) }
                        else { selection.insert(idx) }
                    }
            }
        }
    }
    @ViewBuilder private func chip(name: String, isOn: Bool) -> some View {
        Text(name)
            .font(.subheadline)
            .padding(.vertical, 8).padding(.horizontal, 12)
            .background(isOn ? Color.accentColor.opacity(0.15) : Color(UIColor.secondarySystemBackground))
            .foregroundStyle(isOn ? Color.accentColor : .primary)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(isOn ? Color.accentColor : Color.gray.opacity(0.25), lineWidth: 1))
    }
}
