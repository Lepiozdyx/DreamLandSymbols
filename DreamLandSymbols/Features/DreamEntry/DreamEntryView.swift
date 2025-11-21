import SwiftUI

struct DreamEntryView: View {
    let dreamRecord: DreamRecord?
    let onSave: (DreamRecord) -> Void
    @Binding var showDreamEntry: Bool
    
    @FocusState private var isDreamTextFocused: Bool
    @State private var dreamText: String = ""
    @State private var selectedSymbol: String? = nil
    @State private var selectedMood: String? = nil
    @State private var moodIntensity: Double = 0
    @State private var showSymbolError: Bool = false
    @State private var showTextError: Bool = false
    
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
    
    init(dreamRecord: DreamRecord? = nil, showDreamEntry: Binding<Bool>, onSave: @escaping (DreamRecord) -> Void) {
        self.dreamRecord = dreamRecord
        self._showDreamEntry = showDreamEntry
        self.onSave = onSave
    }
    
    var body: some View {
        ZStack {
            Color(red: 0.02, green: 0.02, blue: 0.16)
                .ignoresSafeArea()
            
            ScrollView {
                ZStack(alignment: .top) {
                    GeometryReader { geometry in
                        if let image = UIImage(named: "background") {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: geometry.size.width, height: geometry.size.height)
                                .clipped()
                        }
                    }
                    .frame(height: UIScreen.main.bounds.height)
                    
                    VStack(spacing: 32) {
                        symbolSection
                        dreamTextSection
                        moodSection
                        recordButton
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 460)
                    .padding(.bottom, 50)
                }
            }
            .scrollContentBackground(.hidden)
            .ignoresSafeArea(edges: .top)
            .scrollDismissesKeyboard(.interactively)
            .simultaneousGesture(
                TapGesture()
                    .onEnded { _ in
                        isDreamTextFocused = false
                    }
            )
        }
        .overlay(alignment: .top) {
            navigationBar
                .background(Color.clear)
                .ignoresSafeArea(edges: .top)
        }
        .statusBar(hidden: true)
        .onAppear {
            if let record = dreamRecord {
                dreamText = record.dreamText
                selectedSymbol = record.selectedSymbol
                moodIntensity = record.moodIntensity
                if let mood = getMoodForIntensity(Int(moodIntensity)) {
                    selectedMood = mood.name
                }
            }
        }
    }
    
    private var navigationBar: some View {
        ZStack {
            HStack {
                backButton
                Spacer()
            }
            
            Text("Add Sleep")
                .font(Font.custom("SF Pro Display", size: 17).weight(.semibold))
                .lineSpacing(20)
                .foregroundColor(Color(red: 1, green: 0.97, blue: 0.97))
                .padding(.vertical, 9)
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 10)
        .padding(.top, 50)
        .frame(maxWidth: .infinity)
    }
    
    private var backButton: some View {
        Button(action: {
            showDreamEntry = false
        }) {
            ZStack {
                Circle()
                    .fill(Color(red: 145/255, green: 145/255, blue: 167/255))
                    .frame(width: 44, height: 44)
                
                Image("arrow_back")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(Color(red: 0.02, green: 0.02, blue: 0.16))
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 17, height: 17)
            }
            .frame(width: 44, height: 44)
            .overlay(
                Circle()
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
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var symbolSection: some View {
        VStack(spacing: 24) {
            Text("The symbol of sleep")
                .font(Font.custom("SF Pro Display", size: 20).weight(.semibold))
                .lineSpacing(24)
                .foregroundColor(.white)
            
            VStack(spacing: 8) {
                VStack(spacing: 6) {
                    HStack(spacing: 6) {
                        symbolButton(emoji: symbols[0].emoji, name: symbols[0].name)
                        symbolButton(emoji: symbols[1].emoji, name: symbols[1].name)
                        symbolButton(emoji: symbols[2].emoji, name: symbols[2].name)
                        symbolButton(emoji: symbols[3].emoji, name: symbols[3].name)
                        symbolButton(emoji: symbols[4].emoji, name: symbols[4].name)
                        symbolButton(emoji: symbols[5].emoji, name: symbols[5].name)
                        symbolButton(emoji: symbols[6].emoji, name: symbols[6].name)
                    }
                    
                    HStack(spacing: 6) {
                        symbolButton(emoji: symbols[7].emoji, name: symbols[7].name)
                        symbolButton(emoji: symbols[8].emoji, name: symbols[8].name)
                        symbolButton(emoji: symbols[9].emoji, name: symbols[9].name)
                        symbolButton(emoji: symbols[10].emoji, name: symbols[10].name)
                        symbolButton(emoji: symbols[11].emoji, name: symbols[11].name)
                        symbolButton(emoji: symbols[12].emoji, name: symbols[12].name)
                        symbolButton(emoji: symbols[13].emoji, name: symbols[13].name)
                    }
                    
                    HStack(spacing: 6) {
                        symbolButton(emoji: symbols[14].emoji, name: symbols[14].name)
                        symbolButton(emoji: symbols[15].emoji, name: symbols[15].name)
                        symbolButton(emoji: symbols[16].emoji, name: symbols[16].name)
                        symbolButton(emoji: symbols[17].emoji, name: symbols[17].name)
                        symbolButton(emoji: symbols[18].emoji, name: symbols[18].name)
                        symbolButton(emoji: symbols[19].emoji, name: symbols[19].name)
                        symbolButton(emoji: symbols[20].emoji, name: symbols[20].name)
                    }
                    
                    HStack(alignment: .center, spacing: 6) {
                        symbolButton(emoji: symbols[21].emoji, name: symbols[21].name)
                        symbolButton(emoji: symbols[22].emoji, name: symbols[22].name)
                        symbolButton(emoji: symbols[23].emoji, name: symbols[23].name)
                        symbolButton(emoji: symbols[24].emoji, name: symbols[24].name)
                        Spacer()
                    }
                }
                
                if showSymbolError && selectedSymbol == nil {
                    Text("The sleep symbol must be selected")
                        .font(Font.custom("SF Pro Display", size: 15).weight(.medium))
                        .lineSpacing(20)
                        .foregroundColor(Color(red: 1, green: 0.23, blue: 0.19))
                }
            }
        }
    }
    
    private func symbolButton(emoji: String, name: String) -> some View {
        Button(action: {
            selectedSymbol = selectedSymbol == name ? nil : name
            if selectedSymbol != nil {
                showSymbolError = false
            }
        }) {
            ZStack {
                if selectedSymbol == name {
                    Circle()
                        .fill(Color.dreamGold)
                        .frame(width: 46, height: 46)
                        .shadow(color: Color.black.opacity(0.12), radius: 8, y: 1)
                        .overlay(
                            Circle()
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
                } else {
                    Circle()
                        .fill(showSymbolError ? Color(red: 1, green: 0.6, blue: 0.6).opacity(0.5) : Color(red: 145/255, green: 145/255, blue: 167/255))
                        .frame(width: 46, height: 46)
                        .overlay(
                            Circle()
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
                }
                
                Text(emoji)
                    .font(Font.custom("SF Pro", size: 16).weight(.regular))
                    .lineSpacing(22)
            }
            .frame(width: 46, height: 46)
        }
    }
    
    private var dreamTextSection: some View {
        VStack(spacing: 24) {
            Text("What was the dream about?")
                .font(Font.custom("SF Pro Display", size: 20).weight(.semibold))
                .lineSpacing(24)
                .foregroundColor(.white)
            
            GeometryReader { geometry in
                ZStack(alignment: .topLeading) {
                    if dreamText.isEmpty {
                        Text(showTextError ? "It is necessary to describe the dream" : "Describe your dream")
                            .font(Font.custom("SF Pro", size: 17))
                            .lineSpacing(20)
                            .foregroundColor(showTextError ? Color(red: 0.55, green: 0.34, blue: 0.34) : Color(red: 0.60, green: 0.60, blue: 0.60))
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .frame(width: geometry.size.width, alignment: .leading)
                            .frame(minHeight: 99, maxHeight: 99)
                    }
                    
                    TextEditor(text: $dreamText)
                        .font(Font.custom("SF Pro", size: 17))
                        .foregroundColor(.white)
                        .scrollContentBackground(.hidden)
                        .frame(width: geometry.size.width)
                        .frame(minHeight: 99, maxHeight: 99)
                        .padding(12)
                        .focused($isDreamTextFocused)
                        .onChange(of: dreamText) { _ in
                            if !dreamText.isEmpty {
                                showTextError = false
                            }
                        }
                }
                .frame(width: geometry.size.width)
                .frame(minHeight: 99, maxHeight: 99)
                .background(Color(red: 0.46, green: 0.46, blue: 0.50).opacity(0.12))
                .cornerRadius(16)
                .overlay(
                    Group {
                        if showTextError && dreamText.isEmpty {
                            RoundedRectangle(cornerRadius: 16)
                                .inset(by: 0.50)
                                .stroke(Color(red: 1, green: 0.03, blue: 0.03), lineWidth: 0.50)
                        }
                    }
                )
            }
            .frame(height: 99)
        }
    }
    
    private var moodSection: some View {
        VStack(spacing: 24) {
            Text("Sleep mood")
                .font(Font.custom("SF Pro Display", size: 20).weight(.semibold))
                .lineSpacing(24)
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
                            
                            Slider(value: $moodIntensity, in: 0...4, step: 1)
                                .tint(.clear)
                                .frame(width: 280)
                                .onChange(of: moodIntensity) { newValue in
                                    if let mood = getMoodForIntensity(Int(newValue)) {
                                        selectedMood = mood.name
                                    }
                                }
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
                .frame(minHeight: 76, maxHeight: 76)
            }
            .frame(height: 76)
        }
    }
    
    private func calculateProgressWidth(geometry: GeometryProxy) -> CGFloat {
        let totalWidth = geometry.size.width
        let progress = moodIntensity / 4.0
        return totalWidth * CGFloat(progress)
    }
    
    private func getMoodForIntensity(_ intensity: Int) -> (name: String, emoji: String)? {
        switch intensity {
        case 0: return ("Sad", "😞")
        case 1: return ("Anxious", "😐")
        case 2: return ("Calm", "🙂")
        case 3: return ("Joyful", "😄")
        case 4: return ("Inspiring", "🤩")
        default: return nil
        }
    }
    
    private var recordButton: some View {
        GeometryReader { geometry in
            Button(action: {
                saveDream()
            }) {
                HStack(alignment: .center, spacing: 2) {
                    Text("Record a dream")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Image("icon_heart")
                        .renderingMode(.template)
                        .foregroundColor(.white)
                        .frame(width: 20, height: 20)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 6)
                .frame(width: geometry.size.width)
                .frame(minHeight: 60, maxHeight: 60)
                .background(Color.dreamGold)
                .cornerRadius(1000)
                .overlay(
                    RoundedRectangle(cornerRadius: 1000)
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
                .shadow(color: Color.black.opacity(0.12), radius: 8, x: 0, y: 1)
            }
        }
        .frame(height: 60)
    }
    
    private func saveDream() {
        if selectedSymbol == nil {
            showSymbolError = true
            return
        }
        
        if dreamText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            showTextError = true
            return
        }
        
        let moodName = getMoodForIntensity(Int(moodIntensity))?.name
        
        let record = DreamRecord(
            id: dreamRecord?.id ?? UUID(),
            date: dreamRecord?.date ?? Date(),
            dreamText: dreamText,
            selectedSymbol: selectedSymbol,
            selectedMood: moodName,
            moodIntensity: moodIntensity
        )
        onSave(record)
        showDreamEntry = false
    }
}

#Preview {
    NavigationView {
        DreamEntryView(showDreamEntry: .constant(true), onSave: { _ in })
        .preferredColorScheme(.dark)
    }
}

