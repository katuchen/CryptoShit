import SwiftUI

struct XmarkButtonView: View {
	@Environment(\.dismiss) var dismiss
    var body: some View {
		Button(action: {
			dismiss()
		}, label: {
			Image(systemName: "xmark")
				.font(.headline)
		})
    }
}

#Preview (traits: .sizeThatFitsLayout) {
    XmarkButtonView()
}
