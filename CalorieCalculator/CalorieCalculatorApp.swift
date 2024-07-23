import SwiftUI

@main
struct MyApp: App {
  @State private var calorieNeed: String = UserDefaults.standard.string(forKey: "calorieNeed") ?? ""

  var body: some Scene {
    WindowGroup {
      NavigationView {
        if calorieNeed.isEmpty { //kalori değeri girilmediğinde ana ekrana yollar
          StartView()
        } else {
          ContentView(calorieNeed: $calorieNeed)
        }
      }
    }
  }
}

