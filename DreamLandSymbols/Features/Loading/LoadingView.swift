import SwiftUI

struct LoadingView: View {
    @State private var loading: CGFloat = 0
    
    var body: some View {
        ZStack {
            Color.dreamDarkViolet
                .ignoresSafeArea()
            
            VStack {
                Image(.startlogo)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250)
                
                Capsule()
                    .foregroundStyle(.black.opacity(0.4))
                    .frame(maxWidth: 200, maxHeight: 17)
                    .overlay(alignment: .leading) {
                        Capsule()
                            .foregroundStyle(.yellow)
                            .frame(width: 198 * loading, height: 15)
                            .padding(.horizontal, 1)
                    }
            }
            .padding()
        }
        .onAppear {
            withAnimation(.linear(duration: 3)) {
                loading = 1
            }
        }
    }
}

#Preview {
    LoadingView()
}
