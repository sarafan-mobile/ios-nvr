//
//  QuestionPack.swift
//  NVR
//
//  Created by Aleksei Cherepanov on 04.08.2023.
//  Copyright © 2023 Softeam Apps. All rights reserved.
//

import Foundation

struct QuestionPack: Identifiable, Decodable {
    var id: String
    var imageName: String
    var name: String
    var amount: Int { questions.count }
    var isPremium: Bool = false
    var questions: [Question]
    
    enum CodingKeys: String, CodingKey {
        case id, imageName, name, questions
    }
}

protocol QuestionCompatible {
    var id: String { get }
    var text: String { get }
    var fullText: String { get }
}

struct Question: Identifiable, QuestionCompatible, Decodable {
    var id: String = UUID().uuidString
    var text: String
    var fullText: String
}

struct GameQuestion: Identifiable, QuestionCompatible {
    var id: String = UUID().uuidString
    var text: String
    var fullText: String
    
    var packImageName: String
    var packName: String
}
