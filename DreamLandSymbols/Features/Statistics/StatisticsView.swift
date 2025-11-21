import SwiftUI

struct StatisticsView: View {
    @StateObject private var dreamStorage = DreamStorageManager.shared
    
    @State private var selectedPeriod: PeriodType = .week
    
    private var calendar: Calendar {
        var cal = Calendar.current
        cal.firstWeekday = 1
        return cal
    }
    private let weekDays = ["S", "M", "T", "W", "T", "F", "S"]
    private let moodEmojis = ["🤩", "😄", "🙂", "😐", "😞"]
    
    enum PeriodType {
        case week
        case month
    }
    
    private var currentWeekDates: [Date] {
        let today = Date()
        let weekday = calendar.component(.weekday, from: today)
        let daysFromSunday = (weekday - calendar.firstWeekday + 7) % 7
        guard let weekStart = calendar.date(byAdding: .day, value: -daysFromSunday, to: today) else {
            return []
        }
        
        var dates: [Date] = []
        for i in 0..<7 {
            if let date = calendar.date(byAdding: .day, value: i, to: weekStart) {
                dates.append(date)
            }
        }
        return dates
    }
    
    private var monthsOfYear: [Date] {
        let today = Date()
        guard let startOfYear = calendar.date(from: calendar.dateComponents([.year], from: today)) else {
            return []
        }
        
        var months: [Date] = []
        for month in 0..<12 {
            if let date = calendar.date(byAdding: .month, value: month, to: startOfYear) {
                months.append(date)
            }
        }
        return months
    }
    
    private func getAverageMoodForMonth(_ monthDate: Date) -> Double {
        let dreams = dreamStorage.getDreams().filter { calendar.isDate($0.date, equalTo: monthDate, toGranularity: .month) }
        guard !dreams.isEmpty else { return -1 }
        let totalMood = dreams.reduce(0.0) { $0 + $1.moodIntensity }
        return totalMood / Double(dreams.count)
    }
    
    private func getMonthName(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: date)
    }
    
    private func getMoodForDate(_ date: Date) -> Double {
        let dreams = dreamStorage.getDreams(for: date)
        guard let dream = dreams.first else { return -1 }
        return Double(dream.moodIntensity)
    }
    
    private func calculateBarHeight(mood: Double) -> CGFloat {
        if mood < 0 { return 0 }
        let maxHeight: CGFloat = 264
        let stepHeight = maxHeight / 4.0
        let height = stepHeight * CGFloat(mood)
        return max(height, 0)
    }
    
    private struct MoodInfo {
        let name: String
        let emoji: String
        let advice: String
        let intensity: Int
        
        static let moods: [MoodInfo] = [
            MoodInfo(name: "Sad", emoji: "😞", advice: "Dreams cry for what you keep silent about during the day. Talk to someone.", intensity: 0),
            MoodInfo(name: "Anxious", emoji: "😐", advice: "Your dreams reflect inner tension. Try 5 minutes of breathing before bed.", intensity: 1),
            MoodInfo(name: "Calm", emoji: "🙂", advice: "You find peace even in your sleep. Trust this state.", intensity: 2),
            MoodInfo(name: "Joyful", emoji: "😄", advice: "You are in harmony with yourself. Preserve this state - write down gratitudes before bed.", intensity: 3),
            MoodInfo(name: "Inspiring", emoji: "🤩", advice: "You are on the verge of a breakthrough. Write down ideas - they are not random.", intensity: 4)
        ]
        
        static func mood(named: String) -> MoodInfo? {
            return moods.first { $0.name.lowercased() == named.lowercased() }
        }
        
        static func mood(for intensity: Int) -> MoodInfo? {
            return moods.first { $0.intensity == intensity }
        }
    }
    
    private var dreamsForPeriod: [DreamRecord] {
        selectedPeriod == .week ?
            dreamStorage.getDreams().filter { calendar.isDate($0.date, equalTo: Date(), toGranularity: .weekOfYear) } :
            dreamStorage.getDreams().filter { calendar.isDate($0.date, equalTo: Date(), toGranularity: .month) }
    }
    
    private var predominantMood: MoodInfo? {
        let dreams = dreamsForPeriod
        guard !dreams.isEmpty else { return nil }
        
        let intensities = dreams.map { Int($0.moodIntensity) }
        guard !intensities.isEmpty else { return nil }
        
        let intensityCounts = Dictionary(grouping: intensities, by: { $0 }).mapValues { $0.count }
        let mostCommonIntensity = intensityCounts.max(by: { $0.value < $1.value })?.key
        
        guard let intensity = mostCommonIntensity else { return nil }
        return MoodInfo.mood(for: intensity)
    }
    
    private var reportText: String {
        let dreams = dreamsForPeriod
        
        if dreams.isEmpty {
            return "No dreams recorded yet"
        }
        
        guard let mood = predominantMood else {
            return "Keep recording your dreams to see your mood patterns"
        }
        
        let periodText = selectedPeriod == .week ? "week" : "month"
        return "Predominant mood this \(periodText): \(mood.emoji) \(mood.name)"
    }
    
    private var adviceText: String {
        guard let mood = predominantMood else {
            return "Keep recording your dreams to get personalized advice"
        }
        
        return mood.advice
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.dreamDarkViolet
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    titleSection
                    
                    ScrollView {
                        VStack(spacing: 0) {
                            segmentedControl
                                .padding(.top, 2)
                                .padding(.horizontal, 16)
                            
                            chartSection
                                .padding(.top, 50)
                                .padding(.horizontal, 8)
                            
                            if selectedPeriod == .week {
                                reportSection
                                    .padding(.top, 48)
                                    .padding(.horizontal, 16)
                                
                                adviceSection
                                    .padding(.top, 26)
                                    .padding(.horizontal, 16)
                                    .padding(.bottom, 100)
                            } else {
                                monthInfoSection
                                    .padding(.top, 48)
                                    .padding(.horizontal, 16)
                                    .padding(.bottom, 100)
                            }
                        }
                    }
                    .scrollContentBackground(.hidden)
                }
            }
        }
    }
    
    private var titleSection: some View {
        HStack {
            Spacer()
            Text("Statistics")
                .font(Font.custom("SF Pro Display", size: 17).weight(.semibold))
                .lineSpacing(20)
                .foregroundColor(Color(red: 1, green: 0.97, blue: 0.97))
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 10)
        .padding(.top, 16)
    }
    
    private var segmentedControl: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 100)
                .fill(Color(red: 118/255, green: 118/255, blue: 128/255).opacity(0.12))
                .frame(height: 36)
            
            GeometryReader { geometry in
                let buttonWidth = (geometry.size.width - 16) / 2
                
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                    .frame(width: buttonWidth, height: 28)
                    .shadow(color: Color.black.opacity(0.06), radius: 10, y: 2)
                    .offset(x: selectedPeriod == .week ? 8 : 8 + buttonWidth, y: 4)
            }
            
        HStack(spacing: 0) {
            Button(action: {
                withAnimation {
                    selectedPeriod = .week
                }
            }) {
                Text("Week")
                    .font(Font.custom("SF Pro", size: 14).weight(selectedPeriod == .week ? .semibold : .medium))
                        .foregroundColor(selectedPeriod == .week ? Color(red: 0.02, green: 0.02, blue: 0.16) : Color(red: 154/255, green: 154/255, blue: 154/255))
                    .frame(maxWidth: .infinity)
                        .padding(.horizontal, 10)
                        .padding(.vertical, selectedPeriod == .week ? 2 : 3)
            }
            
            Button(action: {
                withAnimation {
                    selectedPeriod = .month
                }
            }) {
                Text("Month")
                    .font(Font.custom("SF Pro", size: 14).weight(selectedPeriod == .month ? .semibold : .medium))
                        .foregroundColor(selectedPeriod == .month ? Color(red: 0.02, green: 0.02, blue: 0.16) : Color(red: 154/255, green: 154/255, blue: 154/255))
                    .frame(maxWidth: .infinity)
                        .padding(.horizontal, 10)
                        .padding(.vertical, selectedPeriod == .month ? 2 : 3)
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            }
        .frame(height: 36)
    }
    
    private var chartSection: some View {
        HStack(alignment: .top, spacing: 16) {
            moodScale
            
            if selectedPeriod == .week {
            VStack(spacing: 0) {
                    weekChartBars
                    weekChartDays
                }
                .frame(maxWidth: .infinity)
                } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    VStack(spacing: 0) {
                        monthChartBarsContent
                        monthChartDaysContent
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .frame(height: 264)
    }
    
    private var moodScale: some View {
        ZStack(alignment: .bottomLeading) {
            ForEach(Array(moodEmojis.enumerated()), id: \.offset) { index, emoji in
                Text(emoji)
                    .font(Font.custom("SF Pro", size: 24).weight(.semibold))
                    .lineSpacing(22)
                    .frame(height: 24, alignment: .center)
                    .offset(y: -CGFloat(moodEmojis.count - 1 - index) * (264 - 24) / CGFloat(moodEmojis.count - 1))
            }
        }
        .frame(width: 38, height: 264, alignment: .bottomLeading)
    }
    
    private var weekChartBars: some View {
        HStack(alignment: .bottom, spacing: 8) {
            ForEach(Array(currentWeekDates.enumerated()), id: \.offset) { index, date in
                let mood = getMoodForDate(date)
                let height = calculateBarHeight(mood: mood)
                
                if mood >= 0 {
                    VStack(spacing: 0) {
                        Spacer()
                            .frame(height: 264 - max(height, 1))
                
                ZStack(alignment: .top) {
                    Rectangle()
                        .fill(Color(red: 163/255, green: 140/255, blue: 179/255))
                                .frame(width: 1, height: max(height, 1))
                    
                        Circle()
                            .fill(Color(red: 163/255, green: 140/255, blue: 179/255))
                            .frame(width: 7, height: 7)
                            .offset(y: -3.5)
                    }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 264)
                } else {
                    Spacer()
                        .frame(maxWidth: .infinity)
                        .frame(height: 264)
                }
            }
        }
        .frame(height: 264)
    }
    
    private var weekChartDays: some View {
        HStack(spacing: 8) {
            ForEach(Array(currentWeekDates.enumerated()), id: \.offset) { index, _ in
                dayCircle(dayIndex: index)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.top, 12)
    }
    
    private var monthChartBarsContent: some View {
            HStack(alignment: .bottom, spacing: 8) {
            ForEach(Array(monthsOfYear.enumerated()), id: \.offset) { index, monthDate in
                let averageMood = getAverageMoodForMonth(monthDate)
                let height = calculateBarHeight(mood: averageMood)
                
                if averageMood >= 0 {
                    VStack(spacing: 0) {
                        Spacer()
                            .frame(height: 264 - max(height, 1))
                    
                    ZStack(alignment: .top) {
                        Rectangle()
                            .fill(Color(red: 163/255, green: 140/255, blue: 179/255))
                                .frame(width: 1, height: max(height, 1))
                        
                            Circle()
                                .fill(Color(red: 163/255, green: 140/255, blue: 179/255))
                                .frame(width: 7, height: 7)
                                .offset(y: -3.5)
                        }
                    }
                    .frame(width: 40)
                    .frame(height: 264)
                } else {
                    Spacer()
                        .frame(width: 40)
                        .frame(height: 264)
                }
                }
            }
            .padding(.horizontal, 8)
        .frame(height: 264)
    }
    
    private var monthChartDaysContent: some View {
            HStack(spacing: 8) {
            ForEach(Array(monthsOfYear.enumerated()), id: \.offset) { index, monthDate in
                Text(getMonthName(monthDate))
                            .font(Font.custom("SF Pro", size: 12).weight(.medium))
                            .foregroundColor(Color(red: 0.57, green: 0.18, blue: 0.83))
                    .frame(width: 40)
                    .frame(height: 40)
                }
            }
            .padding(.horizontal, 8)
            .padding(.top, 12)
    }
    
    private func dayCircle(dayIndex: Int) -> some View {
        ZStack {
            Circle()
                .fill(Color(red: 0.57, green: 0.18, blue: 0.83).opacity(0.2))
                .frame(width: 40, height: 40)
            
            Text(weekDays[dayIndex])
                .font(Font.custom("SF Pro", size: 16).weight(.medium))
                .foregroundColor(Color(red: 0.57, green: 0.18, blue: 0.83))
        }
        .frame(width: 40, height: 40)
    }
    
    private var reportSection: some View {
        VStack(alignment: .center, spacing: 8) {
            HStack(spacing: 4) {
                Text("Report")
                    .font(Font.custom("SF Pro Display", size: 20).weight(.semibold))
                    .lineSpacing(10)
                    .foregroundColor(.white)
                
                Image("icon_report")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(.white)
                    .frame(width: 18, height: 18)
            }
            
            Text(reportText)
                .font(Font.custom("SF Pro Display", size: 17).weight(.regular))
                .lineSpacing(10)
                .foregroundColor(Color(red: 0.64, green: 0.55, blue: 0.70))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
    
    private var adviceSection: some View {
        VStack(alignment: .center, spacing: 8) {
            HStack(spacing: 4) {
                Text("Advice")
                    .font(Font.custom("SF Pro Display", size: 20).weight(.semibold))
                    .lineSpacing(10)
                    .foregroundColor(.white)
                
                Image("icon_advice")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(.white)
                    .frame(width: 18, height: 18)
            }
            
            Text(adviceText)
                .font(Font.custom("SF Pro Display", size: 17).weight(.regular))
                .lineSpacing(10)
                .foregroundColor(Color(red: 0.64, green: 0.55, blue: 0.70))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
    
    private var monthInfoSection: some View {
        VStack(alignment: .center, spacing: 8) {
            Text("Monthly Statistics")
                .font(Font.custom("SF Pro Display", size: 20).weight(.semibold))
                .lineSpacing(10)
                .foregroundColor(.white)
            
            Text("The graph shows the average mood for each month of the year. Each column represents one month, and the height indicates your average emotional state during that period.")
                .font(Font.custom("SF Pro Display", size: 17).weight(.regular))
                .lineSpacing(10)
                .foregroundColor(Color(red: 0.64, green: 0.55, blue: 0.70))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    StatisticsView()
        .preferredColorScheme(.dark)
}

