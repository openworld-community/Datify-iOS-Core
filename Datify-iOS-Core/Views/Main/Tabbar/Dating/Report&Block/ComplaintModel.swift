//
//  ComplaintModel.swift
//  Datify-iOS-Core
//
//  Created by Reek i on 11.12.2023.
//

import SwiftUI

protocol ComplaintAddInfoProtocol: Hashable {
    var rawValue: LocalizedStringKey { get }
}

enum Complaint {
    case fake, unacceptableContent, age, insults, behavior, scamSpam

    var title: LocalizedStringKey {
        switch self {
        case .fake:
            "Fake"
        case .unacceptableContent:
            "Unacceptable content"
        case .age:
            "Age"
        case .insults:
            "Insults"
        case .behavior:
            "Behavior outside of Datify"
        case .scamSpam:
            "Scam or spam"
        }
    }

    enum Fake: LocalizedStringKey, ComplaintAddInfoProtocol, CaseIterable {
        case example = "Some 'Fake' details"
    }

    enum UnacceptableContent: LocalizedStringKey, ComplaintAddInfoProtocol, CaseIterable {
        case example = "Some 'Unacceptable content' details"
    }

    enum Age: LocalizedStringKey, ComplaintAddInfoProtocol, CaseIterable {
        case example = "Some 'Age' details"
    }

    enum Insults: LocalizedStringKey, ComplaintAddInfoProtocol, CaseIterable {
        case example = "Some 'Insults' details"
    }

    enum Behavior: LocalizedStringKey, ComplaintAddInfoProtocol, CaseIterable {
        case example = "Some 'Behavior outside of Datify' details"
    }

    enum ScamSpam: LocalizedStringKey, ComplaintAddInfoProtocol, CaseIterable {
        case sends = "Sends spam and suspicious links"
        case sells = "Sells goods or services"
        case promotes = "Promotes social media accounts"
        case other = "Other"
    }
}

struct ComplaintModel {
    let complaintType: Complaint
    let adInfo: [any ComplaintAddInfoProtocol]
}
