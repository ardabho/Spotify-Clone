//
//  PlayerControlsView.swift
//  Spotify
//
//  Created by ARDA BUYUKHATIPOGLU on 9.11.2023.
//

import UIKit
//delegate method for buttons

protocol PlayerControlsDelegate: AnyObject {
    func PlayerControlsDidTapControlButton(_ playerControlsView: PlayerControlsView, buttonType: ButtonType)
}

enum ButtonType {
    case back
    case playPause
    case forward
}

final class PlayerControlsView: UIView {
    
    weak var delegate: PlayerControlsDelegate?
    
    let verticalStack: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .vertical
        stackview.distribution = .fill
        stackview.spacing = 5
        return stackview
    }()
    
    let horizontalStack: UIStackView = {
        let stackview = UIStackView()
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.axis = .horizontal
        stackview.distribution = .fillEqually
        stackview.spacing = 5
        return stackview
    }()
    
    //nameLabel with lines 1 and font systemfont 22 with a weight of semibolkd
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        label.text = "Come And Get Your Love"
        return label
    }()
    //SubtitleLabel
    let subtitleLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .secondaryLabel
        label.text = "Redbone"
        return label
    }()
    
    //Volume Slider
    let volumeSlider: UISlider = {
        let slider = UISlider()
        slider.value = 0.5
        slider.minimumTrackTintColor = .secondaryLabel
        return slider
    }()
    
    //backbutton
    let backButton : UIButton = {
       let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "backward.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        button.setImage(image, for: .normal)
        return button
    }()
    
    //forwardButton sf: forward.fill
    let forwardButton: UIButton = {
       let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "forward.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        button.setImage(image, for: .normal)
        return button
    }()
    
    //play pause button sf: pause
    let pauseButton: UIButton = {
       let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "pause.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        button.setImage(image, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(verticalStack)
        
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        pauseButton.addTarget(self, action: #selector(didTapPauseButton), for: .touchUpInside)
        forwardButton.addTarget(self, action: #selector(didTapForwardButton), for: .touchUpInside)
        
        verticalStack.addArrangedSubview(nameLabel)
        verticalStack.addArrangedSubview(subtitleLabel)
        verticalStack.addArrangedSubview(volumeSlider)
        verticalStack.addArrangedSubview(horizontalStack)
        
        horizontalStack.addArrangedSubview(backButton)
        horizontalStack.addArrangedSubview(pauseButton)
        horizontalStack.addArrangedSubview(forwardButton)
        
        clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let height = frame.height
        
        verticalStack.frame = bounds
        nameLabel.heightAnchor.constraint(equalToConstant: height / 6).isActive = true
        subtitleLabel.heightAnchor.constraint(equalToConstant: height / 6).isActive = true
        
    }
    
    @objc private func didTapBackButton() {
        delegate?.PlayerControlsDidTapControlButton(self, buttonType: .back)
    }
    
    @objc private func didTapPauseButton() {
        delegate?.PlayerControlsDidTapControlButton(self, buttonType: .playPause)
    }
    
    @objc private func didTapForwardButton() {
        delegate?.PlayerControlsDidTapControlButton(self, buttonType: .forward)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
