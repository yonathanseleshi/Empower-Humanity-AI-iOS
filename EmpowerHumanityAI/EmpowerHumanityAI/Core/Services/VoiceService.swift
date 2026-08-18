import Foundation
import Observation
import AVFoundation

// MARK: - Voice State

enum VoiceState: String, CaseIterable, Equatable, Hashable {
    case idle, listening, processing, speaking
    var displayName: String { rawValue.capitalized }
}

// MARK: - VoiceService
// Architecture stub — full implementation requires AVAudioSession + Speech framework permissions.
// Wire to real speech recognition and TTS in a future iteration.

@Observable
final class VoiceService {
    static let shared = VoiceService()

    var state: VoiceState = .idle
    var transcript: String = ""
    var isPermissionGranted: Bool = false

    private init() {}

    // MARK: - Permission

    func requestPermission() async {
        // Future: AVAudioApplication.requestRecordPermission()
        // Future: SFSpeechRecognizer.requestAuthorization(_:)
        isPermissionGranted = true
    }

    // MARK: - Listening

    func startListening() {
        guard isPermissionGranted else { return }
        state = .listening
        transcript = ""
        // Future: Start AVAudioEngine + SFSpeechAudioBufferRecognitionRequest
    }

    func stopListening() {
        guard state == .listening else { return }
        state = .processing
        // Future: Stop audio engine, finalize recognition
        // Simulate processing
        Task {
            try? await Task.sleep(for: .milliseconds(500))
            await MainActor.run {
                state = .idle
            }
        }
    }

    // MARK: - Speaking

    func speak(_ text: String) {
        state = .speaking
        // Future: AVSpeechSynthesizer with configured voice
        let words = text.components(separatedBy: " ")
        let duration = Double(words.count) * 0.15
        Task {
            try? await Task.sleep(for: .seconds(duration))
            await MainActor.run {
                state = .idle
            }
        }
    }

    func stopSpeaking() {
        state = .idle
        // Future: synthesizer.stopSpeaking(at:)
    }
}
