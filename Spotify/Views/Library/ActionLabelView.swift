//
//  ActionLabelView.swift
//  Spotify
//
//  Created by ARDA BUYUKHATIPOGLU on 12.11.2023.
//

import UIKit

protocol ActionLabelViewDelegate: AnyObject {
    func actionLabelViewDidTapButton(_ actionView: ActionLabelView)
}

class ActionLabelView: UIView {

    weak var delegate: ActionLabelViewDelegate?
    
    private let stackview: UIStackView = {
       let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        
        return stack
    }()
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let actionButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.link, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        addSubview(stackview)
        stackview.addArrangedSubview(titleLabel)
        stackview.addArrangedSubview(actionButton)
        actionButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    @objc private func didTapButton() {
        delegate?.actionLabelViewDidTapButton(self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        stackview.frame = CGRect(x: 0, y: 0, width: width, height: height)
        
    }

    public func configure(with viewModel: ActionLabelViewModel) {
        titleLabel.text = viewModel.text
        actionButton.setTitle(viewModel.actionTitle, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
