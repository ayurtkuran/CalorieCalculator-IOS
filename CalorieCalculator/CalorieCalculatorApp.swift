import SwiftUI

@main
struct MyApp: App {
  @State private var calorieNeed: String = UserDefaults.standard.string(forKey: "calorieNeed") ?? ""

  var body: some Scene {
    WindowGroup {
      NavigationView {
        if calorieNeed.isEmpty {
          StartView()
        } else {
          ContentView(calorieNeed: $calorieNeed)
        }
      }
    }
  }
}

