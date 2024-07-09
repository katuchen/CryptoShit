import SwiftUI

struct StatisticsView: View {
	let stat: StatisticModel
    var body: some View {
		VStack(alignment: .leading, spacing: 5) {
			Text(stat.title)
				.foregroundStyle(Color.theme.secondaryText)
			Text(stat.value)
				.font(.headline)
				.foregroundStyle(Color.theme.accent)
			HStack(spacing: 5) {
				Image(systemName: (stat.percentageChange ?? 0.0) > 0 ? "arrowtriangle.up.fill" : "arrowtriangle.down.fill")
				Text("\(stat.percentageChange?.asPercent() ?? "")")
					.bold()
			}
			.foregroundStyle((stat.percentageChange ?? 0.0) > 0 ? Color.theme.green : Color.theme.red)
			.opacity(stat.percentageChange == nil ? 0.0 : 1.0)
		}
		.font(.caption)

    }
}

struct StatisticsView_Previews: PreviewProvider {
	static var previews: some View {
		StatisticsView(stat: dev.stat1)
	}
}
