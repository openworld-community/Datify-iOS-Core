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
        photos: [String] = ["defaultPhoto1", "defaultPhoto2", "defaultPhoto3"],
        label: String = "Looking for love",
        colorLabel: Color = .red,
        location: String = "500 meters from you",
        name: String = "Aleksandra",
        age: Int = 24,
        star: Bool = true,
        description: String = "Я художник. Пробовала заниматься графическим дизайном и комиксами, но сейчас ищу что-то новое...",
        liked: Bool = false,
        bookmarked: Bool = false,
        audiofile: String = "default_audiofile.mp3"
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

