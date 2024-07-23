import SwiftUI

struct StartView: View {
    @State var calorieNeed: String = ""
    @State private var isNextViewActive: Bool = false
    @State private var showAlert: Bool = false

    var body: some View {
        NavigationStack {
            ZStack {
                Image("Background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .opacity(0.8)
                VStack {
                    Text("Günlük ihtiyacınız olan kalori miktarını giriniz")
                        .padding()
                        .background(Color.red.opacity(0.85))
                        .foregroundColor(.white)
                        .cornerRadius(10)

                    TextField("", text: $calorieNeed)
                        .keyboardType(.decimalPad)
                        .padding()
                        .frame(width: 100)
                        .background(Color.black.opacity(0.45))
                        .cornerRadius(10)
                        .shadow(radius: 5)

                    if showAlert {
                        Text("Lütfen geçerli bir kalori değeri giriniz")
                            .foregroundColor(.red)
                            .background(Color.black.opacity(0.45))
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            .padding()
                    }

                    Button(action: {
                        if let _ = Double(calorieNeed), !calorieNeed.isEmpty {
                            UserDefaults.standard.set(calorieNeed, forKey: "calorieNeed")
                            isNextViewActive = true
                            showAlert = false
                        } else {
                            showAlert = true
                        }
                    }) {
                        Text("Enter")
                            .padding()
                            .foregroundColor(.white.opacity(0.85))
                            .background(Color.black.opacity(0.45))
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                    .navigationDestination(isPresented: $isNextViewActive) {
                        ContentView(calorieNeed: $calorieNeed)
                    }
                }
                .padding()
            }
        }
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
