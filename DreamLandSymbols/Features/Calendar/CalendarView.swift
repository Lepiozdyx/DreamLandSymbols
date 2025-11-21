import SwiftUI

struct CalendarView: View {
    @StateObject private var dreamStorage = DreamStorageManager.shared
    
    @State private var currentMonth = Date()
    @State private var selectedDate: Date? = nil
    @State private var selectedDream: DreamRecord? = nil
    
    private let calendar = Calendar.current
    private let weekDays = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
    
    private var monthYearString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: currentMonth)
    }
    
    private var daysInMonth: [Date?] {
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentMonth))!
        let firstWeekday = calendar.component(.weekday, from: startOfMonth)
        let adjustedFirstWeekday = (firstWeekday + 5) % 7
        
        var days: [Date?] = []
        
        for _ in 0..<adjustedFirstWeekday {
            days.append(nil)
        }
        
        let range = calendar.range(of: .day, in: .month, for: currentMonth)!
        for day in range {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: startOfMonth) {
                days.append(date)
            }
        }
        
        while days.count % 7 != 0 {
            days.append(nil)
        }
        
        return days
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.dreamDarkViolet
                    .ignoresSafeArea()
                
                if let image = UIImage(named: "fon_2") {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height * 0.5)
                        .position(x: geometry.size.width / 2, y: geometry.safeAreaInsets.top + 200)
                }
                
                VStack(spacing: 0) {
                    titleSection
                    
                    ScrollView {
                        VStack(spacing: 16) {
                            monthHeader
                            
                            calendarCard
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                        .padding(.bottom, 100)
                    }
                }
            }
        }
        .sheet(item: $selectedDream) { dream in
            DreamDetailView(dream: dream)
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
    }
    
    private var titleSection: some View {
        HStack {
            Spacer()
            Text("Calendar")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.dreamTextLight)
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.top, 16)
        .padding(.bottom, 9)
    }
    
    private var calendarCard: some View {
        VStack(spacing: 16) {
            calendarGrid
        }
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(red: 145/255, green: 145/255, blue: 167/255))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.25), lineWidth: 1)
        )
    }
    
    private var monthHeader: some View {
        HStack(spacing: 24) {
            Button(action: {
                withAnimation {
                    currentMonth = calendar.date(byAdding: .month, value: -1, to: currentMonth) ?? currentMonth
                }
            }) {
                ZStack {
                    Circle()
                        .fill(Color(red: 145/255, green: 145/255, blue: 167/255))
                        .frame(width: 24, height: 24)
                        .overlay(
                            Circle()
                                .stroke(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            .white,
                                            .white.opacity(0),
                                            .white.opacity(0),
                                            .white
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1
                                )
                                .blur(radius: 0.5)
                        )
                    
                    Image(systemName: "chevron.left")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white)
                }
            }
            
            Text(monthYearString)
                .font(.system(size: 17, weight: .medium))
                .foregroundColor(.white)
            
            Button(action: {
                withAnimation {
                    currentMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth) ?? currentMonth
                }
            }) {
                ZStack {
                    Circle()
                        .fill(Color(red: 145/255, green: 145/255, blue: 167/255))
                        .frame(width: 24, height: 24)
                        .overlay(
                            Circle()
                                .stroke(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            .white,
                                            .white.opacity(0),
                                            .white.opacity(0),
                                            .white
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1
                                )
                                .blur(radius: 0.5)
                        )
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white)
                }
            }
        }
    }
    
    private var calendarGrid: some View {
        VStack(spacing: 7) {
            weekDaysHeader
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 7), count: 7), spacing: 7) {
                ForEach(Array(daysInMonth.enumerated()), id: \.offset) { index, date in
                    if let date = date {
                        dayView(date: date)
                    } else {
                        Color.clear
                            .frame(height: 44)
                    }
                }
            }
            .padding(.horizontal, 16)
        }
        .frame(maxWidth: .infinity)
    }
    
    private var weekDaysHeader: some View {
        HStack(spacing: 0) {
            ForEach(weekDays, id: \.self) { day in
                Text(day)
                    .font(Font.custom("SF Pro", size: 13).weight(.semibold))
                    .foregroundColor(Color(red: 0.24, green: 0.24, blue: 0.26).opacity(0.3))
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 20)
    }
    
    private func dayView(date: Date) -> some View {
        let hasDream = dreamStorage.hasDream(for: date)
        
        return ZStack {
            if hasDream {
                Circle()
                    .fill(Color(red: 0.57, green: 0.18, blue: 0.83).opacity(0.12))
                    .frame(width: 44, height: 44)
            }
            
            Text("\(calendar.component(.day, from: date))")
                .font(Font.custom("SF Pro", size: hasDream ? 24 : 20).weight(hasDream ? .medium : .regular))
                .foregroundColor(hasDream ? Color(red: 0.57, green: 0.18, blue: 0.83) : Color(red: 0, green: 0, blue: 0))
                .tracking(-0.45)
        }
        .frame(width: 44, height: 44)
        .onTapGesture {
            if hasDream {
                selectedDate = date
                if let dream = dreamStorage.getDreams(for: date).first {
                    selectedDream = dream
                }
            }
        }
    }
}

#Preview {
    CalendarView()
        .preferredColorScheme(.dark)
}
