//
//  Model.swift
//  RipVanWinkle
//
//  Created by Jason on 7/9/21.
//

import Foundation

struct Show: Hashable, Identifiable {
    let id = UUID()
    let title: String
    let network: String
    var status: Status
}

enum Status: Int, Hashable, CaseIterable {
    case favorite, watching, watched
    
    var title: String {
        switch self {
        case .favorite: return "Favorites"
        case .watching: return "Watching"
        case .watched: return "Watched"
        }
    }
}
