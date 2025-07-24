import SwiftUI

@main
struct WebtoonApp: App {
    @StateObject private var store = WebtoonStore()

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(store)
                .preferredColorScheme(store.theme.colorScheme)
        }
    }
}
