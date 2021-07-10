//
//  ShowContentConfiguration.swift
//  RipVanWinkle
//
//  Created by Jason on 7/9/21.
//

import UIKit

class ShowContentConfiguration: UIContentConfiguration {
    var title: String = ""
    var detail: String = ""
    var isFavorite: Bool = false
    
    init(title: String = "", detail: String = "", isFavorite: Bool = false) {
        self.title = title
        self.detail = detail
        self.isFavorite = isFavorite
    }
    
    func makeContentView() -> UIView & UIContentView {
        ShowContentView(configuration: self)
    }
    
    func updated(for state: UIConfigurationState) -> Self {
        self
    }
}
