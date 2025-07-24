import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var store: WebtoonStore

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("테마")) {
                    Picker("테마", selection: $store.theme) {
                        ForEach(WebtoonStore.Theme.allCases) { theme in
                            Text(theme.rawValue).tag(theme)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                Section(header: Text("카테고리 편집")) {
                    ForEach(store.categories.indices, id: \.self) { index in
                        TextField("카테고리", text: $store.categories[index])
                    }
                    .onDelete { indexSet in
                        store.categories.remove(atOffsets: indexSet)
                    }
                    Button("카테고리 추가") {
                        store.categories.append("")
                    }
                }
                Section(header: Text("자동 업데이트")) {
                    Toggle("API 업데이트 사용", isOn: $store.autoUpdate)
                }
            }
            .navigationTitle("기타")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
