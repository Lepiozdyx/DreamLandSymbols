import Foundation

struct DreamRecord: Identifiable, Codable, Equatable {
    let id: UUID
    let date: Date
    var dreamText: String
    var selectedSymbol: String?
    var selectedMood: String?
    var moodIntensity: Double
    
    init(
        id: UUID = UUID(),
        date: Date = Date(),
        dreamText: String = "",
        selectedSymbol: String? = nil,
        selectedMood: String? = nil,
        moodIntensity: Double = 0
    ) {
        self.id = id
        self.date = date
        self.dreamText = dreamText
        self.selectedSymbol = selectedSymbol
        self.selectedMood = selectedMood
        self.moodIntensity = moodIntensity
    }
}

struct DreamSymbol {
    static let interpretations: [String: String] = [
        "Water": "Represents your emotional landscape. Calm, clear water reflects inner peace and clarity. Turbulent or murky water suggests unresolved feelings, inner conflict, or being overwhelmed. Ask: Am I flowing with my emotions—or fighting them?",
        "Falling": "Symbolizes loss of control or insecurity. Often tied to anxiety about failure, instability, or sudden change. May reflect fear of letting go. If you land safely or enjoy the fall, it can mean surrendering to trust or embracing change.",
        "Flying": "Signifies freedom, perspective, and transcendence. Effortless flight = confidence and inspiration. Struggling to stay airborne = desire to escape but feeling held back. Often appears when gaining insight—or avoiding something on the ground.",
        "Car": "Reflects your sense of direction and control in life. You driving = autonomy. Someone else driving = external control. Crashing or losing control = fear of wrong choices. The car's condition mirrors how you view your current journey.",
        "Teeth": "One of the most common anxiety dreams. Linked to powerlessness, insecurity, fear of judgment, aging, or communication issues (\"losing your voice\"). Rarely about physical health—almost always about perceived loss of confidence.",
        "Death": "Not literal—symbolizes transformation and the end of a life phase (relationship, job, identity). What \"dies\" makes space for rebirth. Pay attention to who or what dies—it reveals what part of your life is ready to evolve.",
        "House": "A mirror of your inner self. A well-kept home = emotional stability. Ruined or unfamiliar rooms = unexplored emotions or neglected aspects. Floors often represent consciousness levels: basement = subconscious, attic = higher mind.",
        "Snake": "Ambivalent symbol—danger or wisdom. Fearful encounter = hidden threat or betrayal. Calm snake = intuition or primal knowledge. In many traditions, snakes shed skin—symbolizing renewal and deep personal change.",
        "Fire": "Raw energy that can create or destroy. Controlled fire (candle, hearth) = passion or spiritual warmth. Wildfire = rage or urgent need for change. Fire purifies—ask: What needs to be released so something new can grow?",
        "Ladder": "Symbol of progress and ambition. Climbing up = growth or rising awareness. Climbing down = introspection or returning to roots. Broken ladder = fear of failure or uncertainty. Where it leads reveals your subconscious direction.",
        "Mirror": "Reflection of self-perception. Clear reflection = self-awareness. Distorted or no reflection = confusion, low self-worth, or denial. May show the \"shadow self\"—parts you hide from the world.",
        "Key": "Represents opportunity or solution. Finding a key = readiness for a new chapter. Losing it = feeling stuck. Unlocking a door = courage to face the unknown. Ask: What are you trying to open—or keep closed?",
        "Rain": "Emotional release and renewal. Gentle rain = healing or spiritual refreshment. Heavy storm = overwhelming sadness or emotional overload. Rain nourishes—but only if the ground is ready to receive it.",
        "Bridge": "Symbol of transition. Crossing safely = moving confidently from past to future. Afraid to cross or collapsing bridge = resistance to change. Bridges connect opposites—what parts of your life need integration?",
        "Cat": "Mystery, independence, and intuition. Friendly cat = trusting your instincts. Aggressive or elusive cat = hidden fears or unpredictable energy. Cats see in the dark—what is your intuition trying to show you?",
        "Dog": "Loyalty, protection, and devotion. Happy dog = trustworthy relationships. Barking or lost dog = betrayal, guilt, or neglected loyalty (to others or yourself). Reflects how you give—and receive—love.",
        "Sand": "The passage of time and impermanence. Running through fingers = anxiety about aging or missed chances. Desert = emotional dryness or spiritual searching. Sand reminds us: nothing stays the same—not even our worries.",
        "Book": "Knowledge and life's unfolding story. Reading = seeking answers. Blank pages = untapped potential. Closed or locked book = hidden truth or fear of discovery. Are you ready to turn the page?",
        "Clock": "Pressure and urgency. Ticking loudly or broken = stress about deadlines or fear of running out of time. Melting clock = confusion about timing. Time in dreams asks: What are you rushing toward—or away from?",
        "Moon": "The subconscious and feminine energy. Full moon = emotional peak or revelation. New moon = new beginnings or hidden potential. Eclipse = deep transformation. The moon's phase mirrors your inner cycle.",
        "Sun": "Consciousness, vitality, and truth. Bright sun = clarity, joy, awakening. Eclipse or darkened sun = temporary loss of direction or obscured truth. The sun rises after every night—your light always returns.",
        "Forest": "The unknown and inner wilderness. Peaceful forest = calm or spiritual refuge. Dark, tangled forest = confusion or feeling lost. Forests hold both danger and magic—what are you exploring within yourself?",
        "Sea": "The vast unconscious and depth of emotion. Calm sea = emotional stability. Stormy or endless ocean = feeling adrift or overwhelmed. The sea doesn't judge—it simply holds everything. Can you do the same for your feelings?",
        "Bird": "Freedom, spirit, and messages. Flying high = hope or liberation. Injured or caged bird = stifled dreams or fear of speaking your truth. Flock = community or divine guidance. Birds remind you: you were born to rise.",
        "Shadow": "The hidden or rejected part of yourself. Chasing or fearing it = denying flaws or past. Facing it = healing and wholeness. As Jung said: \"Until you make the unconscious conscious, it will direct your life.\""
    ]
    
    static func interpretation(for symbol: String?) -> String? {
        guard let symbol = symbol else { return nil }
        return interpretations[symbol]
    }
}

