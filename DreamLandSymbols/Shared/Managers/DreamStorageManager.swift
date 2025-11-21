import Foundation
import os.log

class DreamStorageManager: ObservableObject {
    static let shared = DreamStorageManager()
    
    @MainActor @Published private(set) var dreams: [DreamRecord] = []
    
    private let logger = Logger(subsystem: "com.dreamlandsymbols", category: "DreamStorage")
    private let saveQueue = DispatchQueue(label: "com.dreamlandsymbols.save", qos: .utility)
    
    private init() {
        Task { @MainActor in
            loadFromDisk()
        }
    }
    
    @MainActor
    func saveDream(_ dream: DreamRecord) {
        if let index = dreams.firstIndex(where: { $0.id == dream.id }) {
            dreams[index] = dream
        } else {
            dreams.append(dream)
        }
        saveToDiskAsync(dreams: dreams)
    }
    
    @MainActor
    func getDreams(for date: Date) -> [DreamRecord] {
        let calendar = Calendar.current
        return dreams
            .filter { calendar.isDate($0.date, inSameDayAs: date) }
            .sorted(by: { $0.date > $1.date })
    }
    
    @MainActor
    func hasDream(for date: Date) -> Bool {
        let calendar = Calendar.current
        return dreams.first { calendar.isDate($0.date, inSameDayAs: date) } != nil
    }
    
    @MainActor
    func getDreamsForMonth(_ month: Date) -> [DreamRecord] {
        let calendar = Calendar.current
        guard
            let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: month)),
            let startOfNextMonth = calendar.date(byAdding: .month, value: 1, to: startOfMonth)
        else {
            return []
        }
        
        return dreams
            .filter { dream in
                dream.date >= startOfMonth && dream.date < startOfNextMonth
            }
            .sorted(by: { $0.date > $1.date })
    }
    
    @MainActor
    func getDreams() -> [DreamRecord] {
        return dreams.sorted(by: { $0.date > $1.date })
    }
    
    private var storageURL: URL? {
        do {
            let fm = FileManager.default
            let dir = try fm.url(for: .applicationSupportDirectory,
                                 in: .userDomainMask,
                                 appropriateFor: nil,
                                 create: true)
            let bundleID = Bundle.main.bundleIdentifier ?? "Dreams"
            let appDir = dir.appendingPathComponent(bundleID, isDirectory: true)
            if !fm.fileExists(atPath: appDir.path) {
                try fm.createDirectory(at: appDir, withIntermediateDirectories: true)
            }
            return appDir.appendingPathComponent("dreams.json")
        } catch {
            logger.error("Failed to create storage directory: \(error.localizedDescription)")
            return nil
        }
    }
    
    private func saveToDiskAsync(dreams: [DreamRecord]) {
        saveQueue.async { [weak self] in
            guard let self = self, let url = self.storageURL else { return }
            
            do {
                let encoder = JSONEncoder()
                encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
                if #available(iOS 11.0, macOS 10.13, *) {
                    encoder.dateEncodingStrategy = .iso8601
                }
                let data = try encoder.encode(dreams)
                try data.write(to: url, options: [.atomic])
            } catch {
                self.logger.error("Failed to save dreams: \(error.localizedDescription)")
            }
        }
    }
    
    @MainActor
    private func loadFromDisk() {
        guard let url = storageURL else { return }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            if #available(iOS 11.0, macOS 10.13, *) {
                decoder.dateDecodingStrategy = .iso8601
            }
            dreams = try decoder.decode([DreamRecord].self, from: data)
        } catch {
            logger.warning("Failed to load dreams: \(error.localizedDescription)")
            dreams = []
        }
    }
}
