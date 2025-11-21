import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: TabItem = .home
    
    var body: some View {
        ZStack {
            Color.dreamDarkViolet
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                contentView
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                TabBar(selectedTab: $selectedTab)
            }
        }
    }
    
    @ViewBuilder
    private var contentView: some View {
        switch selectedTab {
        case .home:
            HomeView()
        case .calendar:
            CalendarView()
        case .statistics:
            StatisticsView()
        }
    }
}

#Preview {
    MainTabView()
        .preferredColorScheme(.dark)
}

