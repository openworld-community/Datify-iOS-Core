//
//  DatingModel.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 05.11.2023.
//

import SwiftUI

struct DatingModel: Identifiable {
    let id: String
    var photos: [String]
    let label: String
    let colorLabel: Color
    let location: String
    let name: String
    let age: Int
    let star: Bool
    let description: String
    var liked: Bool
    var bookmarked: Bool
    let audiofile: String

    static var defaultUsers: [DatingModel] = [
        DatingModel(
            id: UUID().uuidString,
            photos: ["user1Photo1", "user1Photo2"],
            label: "Looking for love",
            colorLabel: .red,
            location: "500 meters from you",
            name: "Aleksandra",
            age: 24,
            star: true,
            // swiftlint:disable line_length
            description: "Я художник. Пробовала заниматься графическим дизайном и комиксами, но сейчас ищу что-то новое в области искусства и дизайна. У меня есть муж Лев, он гейм-дизайнер, и да, мы знаем, что поженились довольно рано, но на самом деле мы очень спокойные и дружелюбные люди) Сейчас нахожусь в Белграде, Сербии, я просто ищу кого-нибудь, с кем можно выпить кофе и посплетничать",
            liked: true,
            bookmarked: true,
            audiofile: "recording"
        ),
        DatingModel(
            id: UUID().uuidString,
            photos: ["user2Photo1", "user2Photo2", "user2Photo3"],
            label: "Adventurous Soul",
            colorLabel: .blue,
            location: "2 kilometers away",
            name: "Irina",
            age: 28,
            star: false,
            description: "Всегда в поиске новых приключений и интересных знакомств. Люблю путешествовать, активный отдых и хорошую компанию.",
            liked: false,
            bookmarked: false,
            audiofile: "recording5sec"
        ),
        DatingModel(
            id: UUID().uuidString,
            photos: ["user3Photo1", "user3Photo2", "user3Photo3"],
            label: "Music Lover",
            colorLabel: .green,
            location: "1 kilometer away",
            name: "Maxim",
            age: 25,
            star: true,
            description: "Музыка – моя страсть и профессия. Ищу человека с похожими интересами для совместного посещения концертов и не только.",
            liked: true,
            bookmarked: true,
            audiofile: "recording15sec"
        )
        ]
}
