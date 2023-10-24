//
//  PacksManager.swift
//  NVR
//
//  Created by Aleksei Cherepanov on 09.08.2023.
//  Copyright © 2023 Softeam OOO. All rights reserved.
//

import Foundation
import SwiftUI
import NVRKit

final class PacksManager: ObservableObject {
    @Published private(set) var availablePacks: [QuestionPack] = []
    @Published private(set) var packs: [QuestionPack] = []
    @Published private(set) var favorites: Set<String> = []
    
    init() {
        let favorites = PacksManager.loadFaviorites()
        var packs: [QuestionPack]
        do {
            packs = try PacksManager.loadPacks()
            (0..<packs.count).forEach { i in packs[i].isPremium = i > 1 }
        } catch {
            print("Error loading packs: \(error)")
            packs = []
        }
        let favoritesPack = QuestionPack(
            id: "favorites",
            imageName: "pack_favorites",
            name: NVRStrings.packsFavorites,
            questions: packs.reduce([Question](), { $0 + $1.questions }).filter { favorites.contains($0.id) }
        )
        self.packs = [favoritesPack] + packs
        self.favorites = favorites
        updateAvailablePacks()
    }
    
    func toggleFavorite(_ question: QuestionCompatible) {
        if favorites.contains(question.id) {
            favorites.remove(question.id)
            packs[0].questions = packs[0].questions.filter { favorites.contains($0.id) }
            Analytics.addToFavorites(id: question.id, name: question.fullText)
        } else {
            favorites.insert(question.id)
            packs[0].questions.append(
                Question(id: question.id,
                         text: question.text,
                         fullText: question.fullText)
            )
            Analytics.removeFromFavorites(id: question.id, name: question.fullText)
        }
        saveFavorites()
        updateAvailablePacks()
    }
    
    func updateAvailablePacks() {
        availablePacks = packs.filter { !$0.questions.isEmpty }
    }
    
    func isFavorite(_ id: String) -> Bool {
        favorites.contains(id)
    }
    
    func saveFavorites() {
        guard let data = try? JSONEncoder().encode(favorites) else { return }
        UserDefaults.standard.set(data, forKey: "favorites")
    }
    
    static func countQuestions(_ packs: [QuestionPack]) -> Int {
        var ids = Set<String>()
        for pack in packs {
            pack.questions.forEach { ids.insert($0.id) }
        }
        return ids.count
    }
    
    static func makeQuestions(_ packs: [QuestionPack]) -> [GameQuestion] {
        var ids = Set<String>()
        var result = [GameQuestion]()
        var analyticsData = [String: String]()
        for pack in packs {
            analyticsData[pack.id] = pack.name
            for question in pack.questions where !ids.contains(question.id) {
                ids.insert(question.id)
                result.append(GameQuestion(
                    id: question.id,
                    text: question.text,
                    fullText: question.fullText,
                    packImageName: pack.imageName,
                    packName: pack.name
                ))
            }
        }
        Analytics.startGame(packs: analyticsData)
        return result.shuffled()
    }
    
    static func loadPacks() throws -> [QuestionPack] {
        guard let url = Bundle.main.url(forResource: "packs_data", withExtension: "json") else { throw NSError() }
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode([QuestionPack].self, from: data)
    }
    
    static func loadFaviorites() -> Set<String> {
        guard let data = UserDefaults.standard.data(forKey: "favorites") else { return [] }
        return (try? JSONDecoder().decode(Set<String>.self, from: data)) ?? []
    }
}

