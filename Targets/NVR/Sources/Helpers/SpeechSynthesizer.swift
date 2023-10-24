//
//  SpeechSynthesizer.swift
//  NVR
//
//  Created by Aleksei Cherepanov on 09.08.2023.
//  Copyright © 2023 Softeam OOO. All rights reserved.
//

import SwiftUI
import AVFoundation
import NaturalLanguage

final class SpeechSynthesizer: NSObject, ObservableObject, AVSpeechSynthesizerDelegate {
    @Published var isSpeaking: Bool = false
    
    let synthesizer = AVSpeechSynthesizer()
    var availableLocales: Set<String> = []
    let defaultLocale = "en_US"
    
    override init() {
        super.init()
        synthesizer.delegate = self
        collectLocales()
    }
    
    private func collectLocales() {
        var locales = Set<String>()
        for voice in AVSpeechSynthesisVoice.speechVoices() {
            locales.insert(voice.language)
        }
        availableLocales = locales
    }
    
    func speach(_ string: String) {
        guard !isSpeaking else { return }
        let utterance = AVSpeechUtterance(string: string)
        if let locale = recognizeLocale(string) {
            utterance.voice = AVSpeechSynthesisVoice(language: locale.identifier)
        } else {
            utterance.voice = AVSpeechSynthesisVoice(language: Locale.current.identifier)
        }
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate
        synthesizer.speak(utterance)
    }
    
    func recognizeLocale(_ string: String) -> Locale? {
        let identifier = NLLanguageRecognizer.dominantLanguage(for: string)?.rawValue ?? defaultLocale
        return Locale(identifier: identifier)
    }
    
    func stop() {
        guard isSpeaking else { return }
        synthesizer.stopSpeaking(at: .immediate)
    }
    
    // MARK: - AVSpeechSynthesizerDelegate
    
    private var utterance: AVSpeechUtterance?
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        self.utterance = utterance
        isSpeaking = true
    }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish: AVSpeechUtterance) {
        isSpeaking = false
    }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel: AVSpeechUtterance) {
        isSpeaking = false
    }
}
