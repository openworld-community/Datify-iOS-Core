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
    let liked: Bool
    let bookmarked: Bool
    let audiofile: String

    init(
        userId: UUID = UUID(),
        photos: [String] = ["mockBackground", "mockBackground2", "mockBackground"],
        label: String = "Looking for love",
        colorLabel: Color = .red,
        location: String = "500 meters from you",
        name: String = "Aleksandra",
        age: Int = 24,
        star: Bool = true,
        // swiftlint:disable line_length
        description: String = "Я художник. Пробовала заниматься графическим дизайном и комиксами, но сейчас ищу что-то новое в области искусства и дизайна. У меня есть муж Лев, он гейм-дизайнер, и да, мы знаем, что поженились довольно рано, но на самом деле мы очень спокойные и дружелюбные люди) Сейчас нахожусь в Белграде, Сербии, я просто ищу кого-нибудь, с кем можно выпить кофе и посплетничать",
        liked: Bool = false,
        bookmarked: Bool = false,
        audiofile: String = "recording5sec"
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
}
