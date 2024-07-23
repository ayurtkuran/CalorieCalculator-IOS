import SwiftUI

struct ContentView: View {
  @Binding var calorieNeed: String
  @State private var Eklendi: Bool = false
    @State private var showInput: Bool = false
    @State private var sliderValue: Double = 250.0
    @State private var totalMakarna: Double = UserDefaults.standard.double(forKey: "totalMakarna")
    @State private var totalTavuk: Double = UserDefaults.standard.double(forKey: "totalTavuk")
    @State private var totalKiyma: Double = UserDefaults.standard.double(forKey: "totalKiyma")
    @State private var totalPilav: Double = UserDefaults.standard.double(forKey: "totalPilav")
  @State private var totalProtein:Double = UserDefaults.standard.double(forKey: "totalprotein")

    @State private var totalMakarnagr: Int = UserDefaults.standard.integer(forKey: "totalMakarnaGR")
    @State private var totalTavukgr: Int = UserDefaults.standard.integer(forKey: "totalTavukGR")
    @State private var totalKıymagr: Int = UserDefaults.standard.integer(forKey: "totalKıymaGR")
    @State private var totalPilavgr: Int = UserDefaults.standard.integer(forKey: "totalPilavGR")

    @State private var selectedProduct: String? = nil
    @State private var showTotalsMenu: Bool = false
    @Environment(\.dismiss) var dismiss

    func saveTotals() {
        UserDefaults.standard.set(totalMakarna, forKey: "totalMakarna")
        UserDefaults.standard.set(totalTavuk, forKey: "totalTavuk")
        UserDefaults.standard.set(totalKiyma, forKey: "totalKiyma")
        UserDefaults.standard.set(totalPilav, forKey: "totalPilav")
        UserDefaults.standard.set(totalProtein,forKey:"totalprotein")


    }

    var body: some View {
        ZStack {
            NavigationView {
                ZStack {
                    Image("Background")
                        .resizable()
                        .ignoresSafeArea()
                        .scaledToFill()
                        .opacity(0.8)


                    VStack {
                        Spacer().frame(height: 10)
                        HStack {
                            Spacer().frame(width: 15)
                            Button(action: {
                                if selectedProduct == "Makarna" {
                                    self.showInput.toggle()
                                } else {
                                    self.showInput = true
                                    self.selectedProduct = "Makarna"
                                }
                            }) {
                                Image("Makarna")
                                    .resizable()
                                    .frame(width: 70, height: 60)
                                    .aspectRatio(contentMode: .fill)
                                    .clipped()
                                    .shadow(radius: 10)
                                    .cornerRadius(10)
                            }
                            Spacer().frame(width: 20)

                            Button(action: {
                                if selectedProduct == "Tavuk" {
                                    self.showInput.toggle()
                                } else {
                                    self.showInput = true
                                    self.selectedProduct = "Tavuk"
                                }
                            }) {
                                Image("Tavuk")
                                    .resizable()
                                    .frame(width: 70, height: 60)
                                    .aspectRatio(contentMode: .fill)
                                    .clipped()
                                    .shadow(radius: 10)
                                    .cornerRadius(10)
                            }
                            Spacer().frame(width: 20)

                            Button(action: {
                                if selectedProduct == "Kıyma" {
                                    self.showInput.toggle()
                                } else {
                                    self.showInput = true
                                    self.selectedProduct = "Kıyma"
                                }
                            }) {
                                Image("Kıyma")
                                    .resizable()
                                    .frame(width: 70, height: 60)
                                    .aspectRatio(contentMode: .fill)
                                    .clipped()
                                    .shadow(radius: 10)
                                    .cornerRadius(10)
                            }
                            Spacer().frame(width: 20)

                            Button(action: {
                                if selectedProduct == "Pilav" {
                                    self.showInput.toggle()
                                } else {
                                    self.showInput = true
                                    self.selectedProduct = "Pilav"
                                }
                            }) {
                                Image("Pilav")
                                    .resizable()
                                    .frame(width: 70, height: 60)
                                    .aspectRatio(contentMode: .fill)
                                    .clipped()
                                    .shadow(radius: 10)
                                    .cornerRadius(10)
                            }
                            Spacer().frame(width: 15)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .top)

                        Spacer()

                        if showInput {
                            VStack {
                                Text(" ↓ Yediğiniz Miktarı Giriniz ↓ ")
                                    .padding()
                                    .foregroundColor(.white.opacity(0.85))
                                    .background(Color.black.opacity(0.45))
                                    .cornerRadius(10)
                                    .shadow(radius: 5)

                                Slider(value: $sliderValue, in: 0...500, step: 50)
                                    .padding()
                                    .foregroundColor(.white.opacity(0.85))
                                    .background(Color.black.opacity(0.45))
                                    .cornerRadius(10)
                                    .shadow(radius: 5)
                                    .accentColor(.red)

                                Text("Gram \(sliderValue, specifier: "%.0f")")
                                    .padding()
                                    .foregroundColor(.white.opacity(0.85))
                                    .background(Color.black.opacity(0.45))
                                    .cornerRadius(10)
                                    .shadow(radius: 5)

                                Button(action: {
                                    if let product = selectedProduct {
                                        switch product {
                                        case "Makarna":
                                            totalMakarnagr += Int(sliderValue)
                                            totalMakarna += sliderValue * 3.59
                                          totalProtein+=sliderValue*11/100
                                        case "Tavuk":
                                            totalTavuk += sliderValue * 1.65
                                            totalTavukgr += Int(sliderValue)
                                          totalProtein+=sliderValue*23.5/100
                                        case "Kıyma":
                                            totalKiyma += sliderValue * 2.69
                                            totalKıymagr += Int(sliderValue)
                                          totalProtein+=sliderValue*24/100

                                        case "Pilav":
                                            totalPilav += sliderValue * 3.59
                                            totalPilavgr += Int(sliderValue)
                                          totalProtein+=sliderValue*7/100

                                        default:
                                            break
                                        }
                                    }
                                    saveTotals()
                                    self.showInput = false
                                    withAnimation {
                                      self.Eklendi.toggle()
                                    }

                                  DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        withAnimation {
                                          self.Eklendi.toggle()

                                        }
                                    }
                                }) {
                                    Text("Ekle")
                                        .padding()
                                        .foregroundColor(.white.opacity(0.85))
                                        .background(Color.black.opacity(0.45))
                                        .cornerRadius(10)
                                }
                            }
                            .frame(maxWidth: 300)
                            .padding()
                        }

                        Spacer()
                    }
                }
            }

          if Eklendi{
            VStack{

              Text("Ürün başarıyla eklendi")
                .padding()
                .foregroundColor(.white)
                .background(Color.green.opacity(0.9))
                .cornerRadius(10)
                .shadow(radius: 5)
              Spacer()
                .frame(height: 100)

            }

          }


            if showTotalsMenu {
                HStack {
                    VStack(alignment: .center) {
                        if totalMakarna > 0 {
                            Text("Makarna \(totalMakarnagr) gr \(totalMakarna, specifier: "%.0f kcal")")
                                .padding()
                                .foregroundColor(.white.opacity(0.85))
                                .background(Color.black.opacity(0.45))
                                .cornerRadius(10)
                                .shadow(radius: 5)
                        }

                        if totalTavuk > 0 {
                            Text("Tavuk \(totalTavukgr) gr \(totalTavuk, specifier: "%.0f kcal")")
                                .padding()
                                .foregroundColor(.white.opacity(0.85))
                                .background(Color.black.opacity(0.45))
                                .cornerRadius(10)
                                .shadow(radius: 5)
                        }

                        if totalKiyma > 0 {
                            Text("Kıyma \(totalKıymagr) gr \(totalKiyma, specifier: "%.0f kcal")")
                                .padding()
                                .foregroundColor(.white.opacity(0.85))
                                .background(Color.black.opacity(0.45))                            .cornerRadius(10)
                                .shadow(radius: 5)
                        }

                        if totalPilav > 0 {
                            Text("Pilav \(totalPilavgr) gr  \(totalPilav, specifier: "%.0f kcal")")
                                .padding()
                                .foregroundColor(.white.opacity(0.85))
                                .background(Color.black.opacity(0.45))
                                .cornerRadius(10)
                                .shadow(radius: 5)
                        }

                        Spacer()

                        Text("Toplam Kalori: \(totalMakarna + totalKiyma + totalTavuk + totalPilav, specifier: "%.0f") kcal / \(Double(calorieNeed) ?? 0.0, specifier: "%.0f") kcal")
                            .padding()
                            .background(Color.red.opacity(0.9))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                      Spacer()
                        .frame(height: 20)
                                          Text("Toplam Protein: \(totalProtein,specifier: "%.1f")gr")
                        .padding()
                        .background(Color.red.opacity(0.9))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .frame(width: 500, height: UIScreen.main.bounds.height / 2)
                    .background(Color.gray.opacity(0.5))
                    .cornerRadius(10)
                    .padding()
                    .transition(.move(edge: .leading)) // Animasyonlu geçiş


                    Spacer()
                }
            }

            VStack {
                Spacer()
                VStack {
                    HStack {
                        Button(action: {
                            withAnimation {

                                showInput = false
                                sliderValue = 250.0
                                totalMakarna = 0.0
                                totalTavuk = 0.0
                                totalKiyma = 0.0
                                totalPilav = 0.0
                                selectedProduct = nil
                                showTotalsMenu = false
                                totalMakarnagr = 0
                                totalKıymagr = 0
                                totalPilavgr = 0
                                totalTavukgr = 0
                                calorieNeed = ""
                              UserDefaults.standard.set(calorieNeed, forKey: "calorieNeed") //UserDefaults güncellenir her sayfada geçerli!!
                              totalProtein=0
                                saveTotals()
                                dismiss()
                                                            }
                        }) {
                            Text("Sıfırla")
                                .padding()
                                .frame(width: 170)
                                .foregroundColor(.white.opacity(0.85))
                                .background(Color.black.opacity(0.45))
                                .cornerRadius(10)
                                .shadow(radius: 5)
                        }
                        Button(action: {
                            withAnimation {
                                showTotalsMenu.toggle()
                            }
                        }) {
                            Text("Menüyü Aç/Kapat")
                                .padding()
                                .frame(width: 170)
                                .foregroundColor(.white.opacity(0.85))
                                .background(Color.black.opacity(0.45))
                                .cornerRadius(10)
                                .shadow(radius: 5)
                        }
                    }
                    .padding()
                }
            }
        }
    }}

struct ContentView_Previews: PreviewProvider {
static var previews: some View {
ContentView(calorieNeed: .constant(""))
}
}
