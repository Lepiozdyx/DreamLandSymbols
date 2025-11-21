import SwiftUI

struct HomeView: View {
    @StateObject private var dreamStorage = DreamStorageManager.shared
    @State private var todayDream: DreamRecord? = nil
    @State private var showDreamEntry = false
    @State private var isEditing = false
    
    private var currentDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: Date())
    }
    
    private func updateTodayDream() {
        let today = Date()
        todayDream = dreamStorage.getDreams(for: today).first
    }
    
    var body: some View {
        GeometryReader { _ in
            ZStack {
                backgroundView
                
                VStack(spacing: 0) {
                    titleSection
                    
                    Spacer()
                    
                    VStack(spacing: 32) {
                        if todayDream != nil {
                            dreamCard
                                .padding(.horizontal, 16)
                        }
                        
                        recordButton
                    }
                    .padding(.bottom, 200)
                }
            }
        }
        .onAppear {
            updateTodayDream()
        }
        .onChange(of: dreamStorage.dreams) { _ in
            updateTodayDream()
        }
        .fullScreenCover(isPresented: $showDreamEntry) {
            NavigationView {
                DreamEntryView(
                    dreamRecord: todayDream,
                    showDreamEntry: $showDreamEntry,
                    onSave: { record in
                        dreamStorage.saveDream(record)
                        todayDream = record
                        showDreamEntry = false
                        isEditing = false
                    }
                )
            }
            .transaction { transaction in
                transaction.animation = nil
            }
        }
    }
    
    private var backgroundView: some View {
        ZStack {
            Color.dreamDarkViolet
                .ignoresSafeArea()
            
            if let image = UIImage(named: "background") {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            }
        }
    }
    
    private var titleSection: some View {
        HStack {
            Spacer()
            Text("Main page")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.dreamTextLight)
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 9)
    }
    
    private var recordButton: some View {
        Button(action: {
            isEditing = todayDream != nil
            showDreamEntry = true
        }) {
            HStack(alignment: .center, spacing: 2) {
                Text("Record a dream")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                
                Image(systemName: "plus")
                    .font(.system(size: 24))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 6)
            .frame(maxWidth: .infinity, minHeight: 60, maxHeight: 60)
            .background(Color.dreamGold)
            .cornerRadius(1000)
            .overlay(
                RoundedRectangle(cornerRadius: 1000)
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
            .shadow(color: Color.black.opacity(0.12), radius: 8, x: 0, y: 1)
        }
        .padding(.horizontal, 20)
    }
    
    private var dreamCard: some View {
        VStack(spacing: 16) {
            dreamCardTitle
            
            dreamCardInterpretation
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 24)
        .frame(maxWidth: .infinity, alignment: .top)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(red: 0.88, green: 0.88, blue: 0.88))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24)
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
    
    private var dreamCardTitle: some View {
        HStack {
            HStack(spacing: 8) {
                Text("Sleep recording:")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.dreamDarkViolet)
                
                Text(currentDate)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.dreamDarkViolet.opacity(0.5))
            }
            
            Spacer()
            
            Button(action: {
                isEditing = true
                showDreamEntry = true
            }) {
                Image("icon_pen")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(.dreamDarkViolet)
                    .frame(width: 24, height: 24)
            }
        }
    }
    
    private var dreamCardInterpretation: some View {
        VStack(spacing: 8) {
            Text("Interpretation of a dream")
                .font(.system(size: 17, weight: .regular))
                .foregroundColor(.dreamDarkViolet)
            
            if let symbol = todayDream?.selectedSymbol, let interpretation = DreamSymbol.interpretation(for: symbol) {
                Text(interpretation)
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(.dreamDarkViolet.opacity(0.5))
                    .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                Text("-")
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(.dreamDarkViolet.opacity(0.5))
            }
        }
    }
    
}

#Preview {
    HomeView()
        .preferredColorScheme(.dark)
}

