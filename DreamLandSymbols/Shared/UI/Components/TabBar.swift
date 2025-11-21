import SwiftUI

enum TabItem: Int, CaseIterable {
    case home = 0
    case calendar = 1
    case statistics = 2
    
    var title: String {
        switch self {
        case .home:
            return "Main"
        case .calendar:
            return "Calendar"
        case .statistics:
            return "Statistics"
        }
    }
    
    var iconName: String {
        switch self {
        case .home:
            return "icon_home"
        case .calendar:
            return "icon_calendar"
        case .statistics:
            return "icon_graphic"
        }
    }
}

struct TabBar: View {
    @Binding var selectedTab: TabItem
    
    var body: some View {
        HStack {
            Spacer()
            
            ZStack {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 294, height: 62)
                    .background(.black)
                    .cornerRadius(1000)
                
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 294, height: 62)
                    .background(Color.black.opacity(0.04))
                    .cornerRadius(1000)
                    .offset(x: 0, y: 2)
                    .blur(radius: 20)
                
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 294, height: 62)
                    .background(Color(red: 119/255, green: 119/255, blue: 142/255))
                    .cornerRadius(296)
                    .overlay(
                        RoundedRectangle(cornerRadius: 296)
                            .stroke(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        .white,
                                        Color(red: 1, green: 1, blue: 1).opacity(0),
                                        Color(red: 1, green: 1, blue: 1).opacity(0),
                                        .white
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                            .blur(radius: 0.5)
                    )
                
                HStack(alignment: .top, spacing: -10) {
                    ForEach(TabItem.allCases, id: \.self) { tab in
                        TabBarButton(
                            tab: tab,
                            isSelected: selectedTab == tab,
                            action: {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    selectedTab = tab
                                }
                            }
                        )
                    }
                }
            }
            .frame(width: 294, height: 62)
            
            Spacer()
        }
        .padding(.horizontal, 25)
        .padding(.top, 16)
        .padding(.bottom, 16)
    }
}

struct TabBarButton: View {
    let tab: TabItem
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                if isSelected {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 102, height: 54)
                        .background(Color(red: 104/255, green: 104/255, blue: 127/255))
                        .cornerRadius(100)
                }
                
                VStack(spacing: 2) {
                    Image(isSelected ? "\(tab.iconName)_on" : "\(tab.iconName)_off")
                        .resizable()
                        .frame(width: 24, height: 24)
                    
                    Text(tab.title)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(isSelected ? Color(red: 190/255, green: 143/255, blue: 55/255) : Color.dreamDarkViolet)
                        .padding(.top, 2)
                }
            }
            .padding(EdgeInsets(top: 6, leading: 8, bottom: 7, trailing: 8))
            .frame(width: 102, height: 54)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    VStack {
        Spacer()
        TabBar(selectedTab: .constant(.home))
            .padding(.horizontal)
    }
    .background(Color.gray.opacity(0.2))
}

