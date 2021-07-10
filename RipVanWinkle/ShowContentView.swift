//
//  ShowContentView.swift
//  RipVanWinkle
//
//  Created by Jason on 7/9/21.
//

import UIKit
import SwiftUI

class ShowContentView: UIView, UIContentView {
    var configuration: UIContentConfiguration = ShowContentConfiguration() {
        didSet {
            updateUI()
        }
    }
    
    let titleLabel = UILabel()
    let detailLabel = UILabel()
    let imageView = UIImageView()
    
    init(configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        sharedInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        sharedInit()
    }
    
    func sharedInit() {
        let outerStackView = UIStackView(frame: .zero)
        outerStackView.axis = .horizontal
        outerStackView.alignment = .center
        outerStackView.distribution = .fill
        outerStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(outerStackView)
        outerStackView.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
        outerStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12).isActive = true
        outerStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        outerStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        
        let innerStackView = UIStackView(frame: .zero)
        innerStackView.spacing = 0
        innerStackView.axis = .vertical
        innerStackView.distribution = .fill
        
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        innerStackView.addArrangedSubview(titleLabel)
        detailLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        innerStackView.addArrangedSubview(detailLabel)
        
        outerStackView.addArrangedSubview(innerStackView)
        
        imageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        imageView.contentMode = .scaleAspectFit
        outerStackView.addArrangedSubview(imageView)
        
        updateUI()
    }
    
    func updateUI() {
        guard let configuration = configuration as? ShowContentConfiguration else { return }
        titleLabel.text = configuration.title
        detailLabel.text = configuration.detail
        imageView.image = configuration.isFavorite ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
    }
}

struct __ShowViewProvider: PreviewProvider {
    static var previews: some View {
        __ShowView().previewLayout(.fixed(width: 375, height: 100))
    }
}

struct __ShowView: UIViewRepresentable {
    func makeUIView(context: Context) -> ShowContentView {
        ShowContentView(configuration: ShowContentConfiguration(title: "Title", detail: "Detail"))
    }
    
    func updateUIView(_ uiView: ShowContentView, context: Context) {
        
    }
}
