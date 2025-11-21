import SwiftUI

struct DreamDetailView: View {
    @Environment(\.dismiss) var dismiss
    
    let dream: DreamRecord
    @State private var showEditScreen = false
    
    private let symbols: [(emoji: String, name: String)] = [
        ("💧", "Water"),
        ("🪂", "Falling"),
        ("🕊️", "Flying"),
        ("🚗", "Car"),
        ("🦷", "Teeth"),
        ("🌑", "Death"),
        ("🏠", "House"),
        ("🐍", "Snake"),
        ("🔥", "Fire"),
        ("🪜", "Ladder"),
        ("🪞", "Mirror"),
        ("🔑", "Key"),
        ("🌧️", "Rain"),
        ("🌉", "Bridge"),
        ("🐈", "Cat"),
        ("🐕", "Dog"),
        ("⏳", "Sand"),
        ("📖", "Book"),
        ("⏰", "Clock"),
        ("🌕", "Moon"),
        ("☀️", "Sun"),
        ("🌲", "Forest"),
        ("🌊", "Sea"),
        ("🐦", "Bird"),
        ("🌒", "Shadow")
    ]
    
    private var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM"
        return formatter.string(from: dream.date).lowercased()
    }
    
    private var interpretation: String? {
        guard let symbol = dream.selectedSymbol else { return nil }
        return DreamSymbol.interpretation(for: symbol)
    }
    
    var body: some View {
        ZStack {
            Color.dreamDarkViolet
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    titleSection
                    
                    interpretationSection
                    
                    symbolSection
                    
                    dreamTextSection
                    
                    moodSection
                }
                .padding(.horizontal, 16)
                .padding(.top, 50)
                .padding(.bottom, 100)
            }
        }
        .fullScreenCover(isPresented: $showEditScreen) {
            NavigationView {
                DreamEntryView(
                    dreamRecord: dream,
                    showDreamEntry: $showEditScreen,
                    onSave: { updatedDream in
                        DreamStorageManager.shared.saveDream(updatedDream)
                        showEditScreen = false
                    }
                )
            }
        }
    }
    
    private var titleSection: some View {
        VStack(spacing: 8) {
            Text("Information about sleep")
                .font(Font.custom("SF Pro Display", size: 20).weight(.semibold))
                .foregroundColor(.white)
            
            Text(dateString)
                .font(Font.custom("SF Pro Display", size: 17).weight(.regular))
                .foregroundColor(Color(red: 55/255, green: 55/255, blue: 93/255))
        }
        .frame(maxWidth: .infinity)
    }
    
    private var interpretationSection: some View {
        VStack(spacing: 12) {
            Text("Interpretation:")
                .font(Font.custom("SF Pro Display", size: 17).weight(.semibold))
                .foregroundColor(.white)
            
            if let interpretation = interpretation {
                Text(interpretation)
                    .font(Font.custom("SF Pro Display", size: 17).weight(.regular))
                    .foregroundColor(Color(red: 163/255, green: 140/255, blue: 179/255))
                    .lineSpacing(4)
                    .multilineTextAlignment(.center)
            } else {
                Text("-")
                    .font(Font.custom("SF Pro Display", size: 17).weight(.regular))
                    .foregroundColor(Color(red: 163/255, green: 140/255, blue: 179/255))
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    private var symbolSection: some View {
        VStack(spacing: 16) {
            Text("The symbol of sleep")
                .font(Font.custom("SF Pro Display", size: 17).weight(.semibold))
                .foregroundColor(.white)
            
            VStack(spacing: 8) {
                HStack(spacing: 6) {
                    ForEach(0..<7) { index in
                        if index < symbols.count {
                            symbolButton(symbols[index])
                        }
                    }
                }
                
                HStack(spacing: 6) {
                    ForEach(7..<14) { index in
                        if index < symbols.count {
                            symbolButton(symbols[index])
                        }
                    }
                }
                
                HStack(spacing: 6) {
                    ForEach(14..<21) { index in
                        if index < symbols.count {
                            symbolButton(symbols[index])
                        }
                    }
                }
                
                HStack(spacing: 6) {
                    ForEach(21..<25) { index in
                        if index < symbols.count {
                            symbolButton(symbols[index])
                        }
                    }
                    Spacer()
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    private func symbolButton(_ symbol: (emoji: String, name: String)) -> some View {
        ZStack {
            if dream.selectedSymbol == symbol.name {
                Circle()
                    .fill(Color(red: 0.41, green: 0.41, blue: 0.66))
                    .frame(width: 46, height: 46)
                    .shadow(color: Color.black.opacity(0.12), radius: 8, y: 1)
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
            } else {
                Circle()
                    .fill(Color(red: 145/255, green: 145/255, blue: 167/255))
                    .frame(width: 46, height: 46)
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
            }
            
            Text(symbol.emoji)
                .font(Font.custom("SF Pro", size: 16).weight(.regular))
                .lineSpacing(22)
        }
        .frame(width: 46, height: 46)
    }
    
    private var dreamTextSection: some View {
        VStack(spacing: 12) {
            Text("Dream:")
                .font(Font.custom("SF Pro Display", size: 17).weight(.semibold))
                .foregroundColor(.white)
            
            Text(dream.dreamText.isEmpty ? "-" : dream.dreamText)
                .font(Font.custom("SF Pro Display", size: 17).weight(.regular))
                .foregroundColor(Color(red: 157/255, green: 157/255, blue: 195/255))
                .lineSpacing(4)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(red: 18/255, green: 18/255, blue: 57/255))
                )
        }
        .frame(maxWidth: .infinity)
    }
    
    private var moodSection: some View {
        VStack(spacing: 16) {
            Text("Sleep mood")
                .font(Font.custom("SF Pro Display", size: 17).weight(.semibold))
                .foregroundColor(.white)
            
            GeometryReader { geometry in
                VStack(alignment: .center, spacing: 0) {
                    HStack(alignment: .top, spacing: 0) {
                        Text("😞")
                            .font(Font.custom("SF Pro", size: 17).weight(.regular))
                            .lineSpacing(22)
                            .foregroundColor(Color(red: 0.24, green: 0.24, blue: 0.26).opacity(0.60))
                            .frame(width: 30)
                        
                        Spacer()
                            .frame(width: 8)
                        
                        ZStack {
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 280, height: 6)
                                .background(Color(red: 145/255, green: 145/255, blue: 167/255).opacity(0.20))
                                .cornerRadius(3)
                            
                            GeometryReader { geometry in
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: calculateProgressWidth(geometry: geometry), height: 6)
                                    .background(Color(red: 0.41, green: 0.41, blue: 0.66))
                                    .cornerRadius(3)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .frame(width: 280, height: 6)
                            
                            GeometryReader { geometry in
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: 38, height: 24)
                                    .background(.white)
                                    .cornerRadius(100)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 100)
                                            .stroke(Color(red: 1, green: 0, blue: 0), lineWidth: 0.50)
                                    )
                                    .offset(x: calculateKnobOffset(geometry: geometry) - 19, y: 0)
                                    .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.12), radius: 13, y: 6)
                            }
                            .frame(width: 280, height: 24)
                        }
                        .frame(width: 280, height: 24)
                        
                        Spacer()
                            .frame(width: 8)
                        
                        Text("🤩")
                            .font(Font.custom("SF Pro", size: 17).weight(.regular))
                            .lineSpacing(22)
                            .foregroundColor(Color(red: 0.24, green: 0.24, blue: 0.26).opacity(0.60))
                            .frame(width: 30)
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 1)
                    
                    HStack(spacing: 0) {
                        Spacer()
                            .frame(width: 30 + 8)
                        
                        HStack(spacing: 0) {
                            Text("😞")
                                .font(Font.custom("SF Pro", size: 12).weight(.regular))
                                .lineSpacing(22)
                                .foregroundColor(Color(red: 0.24, green: 0.24, blue: 0.26).opacity(0.60))
                                .frame(maxWidth: .infinity)
                            
                            Text("😐")
                                .font(Font.custom("SF Pro", size: 12).weight(.regular))
                                .lineSpacing(22)
                                .foregroundColor(Color(red: 0.24, green: 0.24, blue: 0.26).opacity(0.60))
                                .frame(maxWidth: .infinity)
                            
                            Text("🙂")
                                .font(Font.custom("SF Pro", size: 12).weight(.regular))
                                .lineSpacing(22)
                                .foregroundColor(Color(red: 0.24, green: 0.24, blue: 0.26).opacity(0.60))
                                .frame(maxWidth: .infinity)
                            
                            Text("😄")
                                .font(Font.custom("SF Pro", size: 12).weight(.regular))
                                .lineSpacing(22)
                                .foregroundColor(Color(red: 0.24, green: 0.24, blue: 0.26).opacity(0.60))
                                .frame(maxWidth: .infinity)
                            
                            Text("🤩")
                                .font(Font.custom("SF Pro", size: 12).weight(.regular))
                                .lineSpacing(22)
                                .foregroundColor(Color(red: 0.24, green: 0.24, blue: 0.26).opacity(0.60))
                                .frame(maxWidth: .infinity)
                        }
                        .frame(width: 280)
                        
                        Spacer()
                            .frame(width: 30 + 8)
                    }
                    .padding(.top, 4)
                    .padding(.horizontal, 16)
                }
                .frame(width: geometry.size.width)
            }
            .frame(height: 76)
        }
        .frame(maxWidth: .infinity)
    }
    
    private func calculateProgressWidth(geometry: GeometryProxy) -> CGFloat {
        let totalWidth = geometry.size.width
        let progress = dream.moodIntensity / 4.0
        return totalWidth * CGFloat(progress)
    }
    
    private func calculateKnobOffset(geometry: GeometryProxy) -> CGFloat {
        let totalWidth = geometry.size.width
        let progress = dream.moodIntensity / 4.0
        return totalWidth * CGFloat(progress)
    }
}

#Preview {
    DreamDetailView(dream: DreamRecord(
        date: Date(),
        dreamText: "You're standing on a bridge above a rushing river. The water reflects the moon, but the reflection trembles like uncertain breath. You want to cross, yet the bridge sways, as if it might vanish at any moment. In the distance, a light — and you take a step forward.",
        selectedSymbol: "Bridge",
        selectedMood: "🙂",
        moodIntensity: 2
    ))
    .preferredColorScheme(.dark)
}

