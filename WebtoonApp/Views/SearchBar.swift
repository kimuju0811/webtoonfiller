import SwiftUI

struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        TextField("검색", text: $text)
            .textFieldStyle(.roundedBorder)
            .padding([.leading, .trailing])
    }
}
