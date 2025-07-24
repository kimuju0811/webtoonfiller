import SwiftUI

struct WebtoonRow: View {
    var webtoon: Webtoon

    var body: some View {
        HStack(alignment: .top) {
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 70, height: 100)
            VStack(alignment: .leading, spacing: 4) {
                Text(webtoon.title)
                    .font(.headline)
                Text("\(webtoon.writer) / \(webtoon.artist)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text("평가: \(webtoon.rating)  상태: \(webtoon.status)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("스튜디오: \(webtoon.studio)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}
