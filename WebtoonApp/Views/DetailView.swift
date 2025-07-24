import SwiftUI

struct DetailView: View {
    @State var webtoon: Webtoon
    @EnvironmentObject var store: WebtoonStore

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(webtoon.title)
                    .font(.title)
                    .bold()
                Text(webtoon.writer)
                    .foregroundStyle(.secondary)
                Text(webtoon.artist)
                    .foregroundStyle(.secondary)
                ProgressView(value: Double(webtoon.lastRead), total: Double(max(webtoon.episodes, 1))) {
                    if webtoon.episodes > 0 {
                        Text("\(webtoon.lastRead)/\(webtoon.episodes)")
                    } else {
                        Text("안 읽음")
                    }
                }
                Stepper("읽은 회차", value: $webtoon.lastRead, in: 0...webtoon.episodes)
            }
            .padding()
        }
        .navigationTitle(webtoon.title)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if let index = store.webtoons.firstIndex(where: { $0.id == webtoon.id }) {
                store.webtoons[index].lastOpened = Date()
                webtoon = store.webtoons[index]
            }
        }
        .onChange(of: webtoon) { value in
            store.update(value)
        }
    }
}
