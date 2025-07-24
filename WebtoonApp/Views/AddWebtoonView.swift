import SwiftUI

struct AddWebtoonView: View {
    @EnvironmentObject var store: WebtoonStore
    @State private var webtoon = Webtoon(title: "", writer: "", artist: "")
    @State private var showingAPIAlert = false
    @State private var selectedGenres: Set<String> = []
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("기본 정보")) {
                    TextField("제목", text: $webtoon.title)
                        .onSubmit { Task { await fetchInfo() } }
                    TextField("글 작가", text: $webtoon.writer)
                    TextField("그림 작가", text: $webtoon.artist)
                    TextField("스튜디오", text: $webtoon.studio)
                    Picker("연재 요일", selection: $webtoon.day) {
                        ForEach(["월","화","수","목","금","토","일"], id: \.self) { Text($0) }
                    }
                    Picker("연재 상태", selection: $webtoon.status) {
                        ForEach(["연재 중","완결","휴재"], id: \.self) { Text($0) }
                    }
                    .pickerStyle(.segmented)
                }
                Section(header: Text("장르")) {
                    List(store.categories, id: \.self, selection: $selectedGenres) { cat in
                        Text(cat)
                    }
                    .environment(\.editMode, .constant(.active))
                    .frame(height: 150)
                }
                Section(header: Text("메모")) {
                    TextEditor(text: $webtoon.review)
                        .frame(minHeight: 80)
                }
                Section {
                    Button("저장") {
                        webtoon.genres = Array(selectedGenres)
                        store.add(webtoon)
                        dismiss()
                    }
                    Button("취소", role: .destructive) {
                        dismiss()
                    }
                }
            }
            .navigationTitle("웹툰 추가")
            .alert("API 정보를 불러오지 못했습니다.", isPresented: $showingAPIAlert) {
                Button("확인", role: .cancel) {}
            }
        }
    }

    /// Attempts to fetch webtoon info from external APIs using the entered title.
    private func fetchInfo() async {
        guard !webtoon.title.isEmpty else { return }
        do {
            let info = try await WebtoonAPI.fetchFromKakaoPage(title: webtoon.title)
            self.webtoon = info
        } catch {
            do {
                let info = try await WebtoonAPI.fetchFromNaver(title: webtoon.title)
                self.webtoon = info
            } catch {
                showingAPIAlert = true
            }
        }
    }
}

struct AddWebtoonView_Previews: PreviewProvider {
    static var previews: some View {
        AddWebtoonView().environmentObject(WebtoonStore())
    }
}
