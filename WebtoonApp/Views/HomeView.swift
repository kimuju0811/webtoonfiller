import SwiftUI

struct HomeView: View {
    @State private var query: String = ""
    @EnvironmentObject var store: WebtoonStore

    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $query)
                List(filteredWebtoons) { webtoon in
                    NavigationLink(destination: DetailView(webtoon: webtoon).environmentObject(store)) {
                        WebtoonRow(webtoon: webtoon)
                    }
                }
            }
            .navigationTitle("Webtoonfiller")
        }
    }

    private var filteredWebtoons: [Webtoon] {
        if query.isEmpty { return store.webtoons }
        return store.webtoons.filter { $0.title.localizedCaseInsensitiveContains(query) }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
