import Foundation

/// Helper for fetching webtoon information from external APIs.
/// Replace the placeholder URLs with real endpoints and provide your API key if necessary.
struct WebtoonAPI {
    /// Fetch information from KakaoPage API.
    static func fetchFromKakaoPage(title: String) async throws -> Webtoon {
        // TODO: Replace with actual KakaoPage API endpoint
        let encoded = title.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? title
        let url = URL(string: "https://YOUR_KAKAOPAGE_ENDPOINT?query=\(encoded)&apikey=YOUR_KEY")!
        let (data, _) = try await URLSession.shared.data(from: url)
        // Adjust decoding according to API response structure
        return try JSONDecoder().decode(Webtoon.self, from: data)
    }

    /// Fetch information from Naver Webtoon API.
    static func fetchFromNaver(title: String) async throws -> Webtoon {
        // TODO: Replace with actual Naver Webtoon API endpoint
        let encoded = title.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? title
        let url = URL(string: "https://YOUR_NAVER_ENDPOINT?title=\(encoded)&apikey=YOUR_KEY")!
        let (data, _) = try await URLSession.shared.data(from: url)
        // Adjust decoding according to API response structure
        return try JSONDecoder().decode(Webtoon.self, from: data)
    }
}
