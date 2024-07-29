import SwiftUI

struct FoodItem: Identifiable, Codable {
    let id = UUID()
    let name: String
    let calories: Double
    let protein: Double
    let amount: Double
}

struct ContentView: View {
    @Binding var calorieNeed: String
    @State private var Eklendi: Bool = false
    @State private var showInput: Bool = false
    @State private var sliderValue: Double = 250.0
    @State private var totalCalories: Double = UserDefaults.standard.double(forKey: "totalCalories")
    @State private var totalProtein: Double = UserDefaults.standard.double(forKey: "totalProtein")
    @State private var selectedProduct: String? = nil
    @State private var fetchedCalories: Double = 0.0
    @State private var fetchedProtein: Double = 0.0
    @State private var searchQuery: String = ""
    @State private var showTotalsMenu: Bool = false
    @State private var foodItems: [FoodItem] = []
    @Environment(\.dismiss) var dismiss

    init(calorieNeed: Binding<String>) {
        self._calorieNeed = calorieNeed
        if let savedFoodItems = UserDefaults.standard.data(forKey: "foodItems") {
            if let decodedFoodItems = try? JSONDecoder().decode([FoodItem].self, from: savedFoodItems) {
                self._foodItems = State(initialValue: decodedFoodItems)
                self._totalCalories = State(initialValue: decodedFoodItems.reduce(0) { $0 + $1.calories })
                self._totalProtein = State(initialValue: decodedFoodItems.reduce(0) { $0 + $1.protein })
            }
        }
    }

    func saveTotals() {
        UserDefaults.standard.set(totalCalories, forKey: "totalCalories")
        UserDefaults.standard.set(totalProtein, forKey: "totalProtein")
        if let encoded = try? JSONEncoder().encode(foodItems) {
            UserDefaults.standard.set(encoded, forKey: "foodItems")
        }
    }

    func fetchNutritionData(for food: String) {
        let appId = "af563563"
        let appKey = "f6b895fdaedc5ddc85b65c721cbccfb0"
        let urlString = "https://trackapi.nutritionix.com/v2/natural/nutrients"

        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(appId, forHTTPHeaderField: "x-app-id")
        request.addValue(appKey, forHTTPHeaderField: "x-app-key")

        let json: [String: Any] = ["query": food]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)

        request.httpBody = jsonData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let foods = json["foods"] as? [[String: Any]] {
                    for food in foods {
                        if let calories = food["nf_calories"] as? Double,
                           let protein = food["nf_protein"] as? Double {
                            DispatchQueue.main.async {
                                self.fetchedCalories = calories
                                self.fetchedProtein = protein
                                self.selectedProduct = food["food_name"] as? String
                                self.showInput = true
                            }
                        }
                    }
                }
            } catch let error {
                print("Failed to parse JSON: \(error.localizedDescription)")
            }
        }

        task.resume()
    }

    func addFoodToMenu() {
        guard let product = selectedProduct else { return }

        let caloriesPerGram = fetchedCalories / 100
        let proteinPerGram = fetchedProtein / 100

        let totalItemCalories = sliderValue * caloriesPerGram
        let totalItemProtein = sliderValue * proteinPerGram

        totalCalories += totalItemCalories
        totalProtein += totalItemProtein

        let foodItem = FoodItem(name: product, calories: totalItemCalories, protein: totalItemProtein, amount: sliderValue)
        foodItems.append(foodItem)

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
                        TextField("Search Food", text: $searchQuery)
                        .padding()
                        .frame(width: 170)
                        .foregroundColor(.colorText)
                        .background(Color.colorButton)
                        .cornerRadius(10)
                        .shadow(radius: 5)


                        Button(action: {
                            fetchNutritionData(for: searchQuery)
                        }) {
                            Text("Search and Add")
                            .padding()
                            .frame(width: 170)
                            .foregroundColor(.colorText)
                            .background(Color.colorButton)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                        }
                        .padding(.bottom)

                        Spacer()

                        if showInput {
                            VStack {
                                Text("↓ Enter the Amount You Ate ↓")
                                    .padding()
                                    .foregroundColor(.colorText)
                                    .background(Color.colorButton)
                                    .cornerRadius(10)
                                    .shadow(radius: 5)

                                Slider(value: $sliderValue, in: 0...800, step: 50)
                                    .padding()
                                    .foregroundColor(.colorText)
                                    .background(Color.colorButton)
                                    .cornerRadius(10)
                                    .shadow(radius: 5)
                                    .accentColor(.colorText)

                                Text("Grams \(sliderValue, specifier: "%.0f")")
                                    .padding()
                                    .foregroundColor(.colorText)
                                    .background(Color.colorButton)
                                    .cornerRadius(10)
                                    .shadow(radius: 5)

                                Button(action: {
                                    addFoodToMenu()
                                }) {
                                    Text("Add")
                                        .padding()
                                        .foregroundColor(.white.opacity(0.85))
                                        .background(Color.green.opacity(0.95))
                                        .cornerRadius(10)
                                }
                            }
                            .frame(maxWidth: 300)
                            .padding()
                        }

                        Spacer()
                      Spacer()
                      Spacer()
                    }
                }
            }

            if Eklendi {
                VStack {
                    Text("Item added successfully")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.green.opacity(0.95))
                        .cornerRadius(10)
                        .shadow(radius: 5)
                    Spacer()
                        .frame(height: 100)
                }
            }

            if showTotalsMenu {
                HStack {
                    VStack(alignment: .center) {
                        ForEach(foodItems) { item in
                            Text("\(item.name) → \(item.calories, specifier: "%.0f") kcal")
                                .padding()
                                .foregroundColor(.colorText)
                                .background(Color.colorButton)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                        }

                        Spacer()

                        Text("Total Calories: \(totalCalories, specifier: "%.0f") kcal")
                            .padding()
                            .background(Color.colorButton)
                            .foregroundColor(.colorText)
                            .cornerRadius(10)
                        Spacer()
                            .frame(height: 20)
                        Text("Total Protein: \(totalProtein, specifier: "%.1f") gr")
                            .padding()
                            .background(Color.colorButton)
                            .foregroundColor(.colorText)
                            .cornerRadius(10)
                    }
                    .frame(width: 500, height: UIScreen.main.bounds.height / 2)
                    .background(Color.gray.opacity(0.65))
                    .cornerRadius(10)
                    .padding()
                    .transition(.move(edge: .leading))

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
                                totalCalories = 0.0
                                totalProtein = 0.0
                                selectedProduct = nil
                                calorieNeed = ""
                                foodItems.removeAll()
                                UserDefaults.standard.set(calorieNeed, forKey: "calorieNeed")
                                saveTotals()
                                dismiss()
                            }
                        }) {
                            Text("Reset")
                                .padding()
                                .frame(width: 170)
                                .foregroundColor(.colorText)
                                .background(Color.colorButton)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                        }
                        Button(action: {
                            withAnimation {
                                showTotalsMenu.toggle()
                            }
                        }) {
                            Text("Toggle Menu")
                                .padding()
                                .frame(width: 170)
                                .foregroundColor(.colorText)
                                .background(Color.colorButton)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                                }
                                }
                                .padding()
                                }
                                }
                                }
                                }
                                }

                                struct ContentView_Previews: PreviewProvider {
                                static var previews: some View {
                                ContentView(calorieNeed: .constant(""))
                                }
                                }
