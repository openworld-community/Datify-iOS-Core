//
//  DatingModel.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 05.11.2023.
//

import SwiftUI

struct DatingModel {
    let userId: UUID
    let photos: [String]
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

    init(
        userId: UUID = UUID(),
        photos: [String],
        label: String,
        colorLabel: Color,
        location: String,
        name: String,
        age: Int,
        star: Bool,
        description: String,
        liked: Bool,
        bookmarked: Bool,
        audiofile: String
    ) {
        self.userId = userId
        self.photos = photos
        self.label = label
        self.colorLabel = colorLabel
        self.location = location
        self.name = name
        self.age = age
        self.star = star
        self.description = description
        self.liked = liked
        self.bookmarked = bookmarked
        self.audiofile = audiofile
    }

    static let defaultUsers: [DatingModel] = [
        DatingModel(
            photos: ["mockBackground", "mockBackground2", "mockBackground"],
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
            photos: ["mockBackground2", "mockBackground2", "mockBackground"],
            label: "Adventurous Soul",
            colorLabel: .blue,
            location: "2 kilometers away",
            name: "Maxim",
            age: 28,
            star: false,
            description: "Всегда в поиске новых приключений и интересных знакомств. Люблю путешествовать, активный отдых и хорошую компанию.",
            liked: false,
            bookmarked: false,
            audiofile: "recording5sec"
        ),
        DatingModel(
            photos: ["mockBackground", "mockBackground2", "mockBackground"],
            label: "Music Lover",
            colorLabel: .green,
            location: "1 kilometer away",
            name: "Irina",
            age: 25,
            star: true,
            description: "Музыка – моя страсть и профессия. Ищу человека с похожими интересами для совместного посещения концертов и не только.",
            liked: true,
            bookmarked: true,
            audiofile: "recording15sec"
        )
        ]
}
