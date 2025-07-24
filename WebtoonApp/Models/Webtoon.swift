import Foundation
import SwiftUI

/// Basic webtoon model used throughout the app.
/// Conforms to `Codable` so it can be easily saved to disk.
struct Webtoon: Identifiable, Codable {
    var id = UUID()
    var title: String
    var writer: String
    var artist: String
    var studio: String = ""
    var genres: [String] = []
    var day: String = ""
    var status: String = ""
    var rating: String = ""
    var thumbnailURL: URL?
    var episodes: Int = 0
    var lastRead: Int = 0
    var review: String = ""
    var lastOpened: Date = .distantPast
}

/// A simple store that keeps the list of webtoons and persists them as JSON.
class WebtoonStore: ObservableObject {
    @Published var webtoons: [Webtoon] = [] {
        didSet { save() }
    }

    /// Available genre categories that the user can edit.
    @Published var categories: [String] = [
        "판타지", "무협", "일상", "추리", "게임"
    ] {
        didSet { saveCategories() }
    }

    @Published var autoUpdate: Bool = UserDefaults.standard.bool(forKey: "autoUpdate") {
        didSet {
            UserDefaults.standard.set(autoUpdate, forKey: "autoUpdate")
            configureTimer()
        }
    }

    enum Theme: String, CaseIterable, Codable, Identifiable {
        case system, light, dark, sepia, poster

        var id: String { rawValue }

        var colorScheme: ColorScheme? {
            switch self {
            case .light: return .light
            case .dark: return .dark
            default: return nil
            }
        }
    }

    @Published var theme: Theme = Theme(rawValue: UserDefaults.standard.string(forKey: "theme") ?? "system") ?? .system {
        didSet { UserDefaults.standard.set(theme.rawValue, forKey: "theme") }
    }

    private var timer: Timer?

    private let saveURL: URL = {
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return docs.appendingPathComponent("webtoons.json")
    }()

    private let categoriesURL: URL = {
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return docs.appendingPathComponent("categories.json")
    }()

    init() {
        load()
        loadCategories()
        configureTimer()
    }

    @MainActor
    func refreshAll() async {
        for index in webtoons.indices {
            let title = webtoons[index].title
            do {
                let info = try await WebtoonAPI.fetchFromKakaoPage(title: title)
                merge(into: &webtoons[index], new: info)
            } catch {
                if let info = try? await WebtoonAPI.fetchFromNaver(title: title) {
                    merge(into: &webtoons[index], new: info)
                }
            }
        }
    }

    private func merge(into current: inout Webtoon, new: Webtoon) {
        current.thumbnailURL = new.thumbnailURL
        current.genres = new.genres
        current.day = new.day
        current.status = new.status
        current.episodes = new.episodes
    }

    /// Adds a new webtoon to the list and saves it to disk.
    func add(_ webtoon: Webtoon) {
        webtoons.append(webtoon)
    }

    /// Updates an existing webtoon in the list if its ID matches.
    func update(_ webtoon: Webtoon) {
        if let index = webtoons.firstIndex(where: { $0.id == webtoon.id }) {
            webtoons[index] = webtoon
        }
    }

    /// Loads the saved webtoon list from disk.
    private func load() {
        guard let data = try? Data(contentsOf: saveURL) else { return }
        if let decoded = try? JSONDecoder().decode([Webtoon].self, from: data) {
            webtoons = decoded
        }
    }

    /// Persists the current list of webtoons as JSON.
    private func save() {
        guard let data = try? JSONEncoder().encode(webtoons) else { return }
        try? data.write(to: saveURL)
    }

    private func loadCategories() {
        guard let data = try? Data(contentsOf: categoriesURL) else { return }
        if let decoded = try? JSONDecoder().decode([String].self, from: data) {
            categories = decoded
        }
    }

    private func saveCategories() {
        guard let data = try? JSONEncoder().encode(categories) else { return }
        try? data.write(to: categoriesURL)
    }

    private func configureTimer() {
        timer?.invalidate()
        guard autoUpdate else { return }
        timer = Timer.scheduledTimer(withTimeInterval: 3600, repeats: true) { _ in
            Task { await self.refreshAll() }
        }
    }
}
