import Foundation

@MainActor
final class AppStateManager: ObservableObject {
    
    enum States {
        case request
        case support
        case loading
    }
    
    @Published private(set) var appState: States = .request
    let networkManager: NetworkManager
    
    init(networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func stateRequest() {
        Task { @MainActor in
            do {
                if networkManager.gameURL != nil {
                    appState = .support
                    return
                }
                
                let shouldShowWebView = try await networkManager.checkInitialURL()
                
                if shouldShowWebView {
                    appState = .support
                } else {
                    appState = .loading
                }
                
            } catch {
                appState = .loading
            }
        }
    }
}
