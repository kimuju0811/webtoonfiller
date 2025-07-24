import SwiftUI

struct SearchView: View {
    @State private var query: String = ""
    @State private var sort: SortType = .rating
    @EnvironmentObject var store: WebtoonStore

    enum SortType: String, CaseIterable, Identifiable {
        case rating = "평가 순"
        case title = "제목 순"
        case recent = "최근 클릭 순"

        var id: String { rawValue }
    }

    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $query)
                Picker("정렬", selection: $sort) {
                    ForEach(SortType.allCases) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .pickerStyle(.segmented)
                List(filteredWebtoons) { webtoon in
                    NavigationLink(destination: DetailView(webtoon: webtoon).environmentObject(store)) {
                        WebtoonRow(webtoon: webtoon)
                    }
                }
            }
            .navigationTitle("검색")
        }
    }

    var filteredWebtoons: [Webtoon] {
        var result = store.webtoons.filter { webtoon in
            if query.isEmpty { return true }
            return webtoon.title.localizedCaseInsensitiveContains(query) ||
                   webtoon.writer.localizedCaseInsensitiveContains(query) ||
                   webtoon.studio.localizedCaseInsensitiveContains(query) ||
                   webtoon.genres.contains { $0.localizedCaseInsensitiveContains(query) }
        }

        switch sort {
        case .rating:
            result.sort { $0.rating > $1.rating }
        case .title:
            result.sort { $0.title < $1.title }
        case .recent:
            result.sort { $0.lastOpened > $1.lastOpened }
        }

        return result
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView().environmentObject(WebtoonStore())
    }
}
