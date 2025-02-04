//
//  LargeCustomButton.swift
//  Shift_Pizza
//
//  Created by Станислав Дейнекин on 29.01.2025.
//

import UIKit

final class LargeCustomButton: UIButton {
    
    enum ButtonStyle {
        case orange
        case white
        case inactive
    }
    
    private var buttonStyle: ButtonStyle
    
    init(style: ButtonStyle) {
        self.buttonStyle = style
        super.init(frame: .zero)
        setupButton()
        configureStyle()
    }
    
    required init?(coder: NSCoder) {
        self.buttonStyle = .orange
        super.init(coder: coder)
        setupButton()
        configureStyle()
    }
    
    private func setupButton() {
        layer.cornerRadius = 16
        clipsToBounds = true
        titleLabel?.textAlignment = .center
        titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        
        snp.makeConstraints { make in
            make.height.equalTo(56)
        }
    }
    
    private func configureStyle() {
        layer.sublayers?.forEach { layer in
            if layer is CAGradientLayer {
                layer.removeFromSuperlayer()
            }
        }
        
        layer.borderWidth = 0.0
        layer.borderColor = nil
        
        switch buttonStyle {
        case .white:
            backgroundColor = .white
            setTitleColor(UIColor(named: "Secondary"), for: .normal)
            layer.borderWidth = 1.0
            layer.borderColor = UIColor(named: "IndicatorLight")?.cgColor
            isUserInteractionEnabled = true
            
        case .orange:
            backgroundColor = UIColor(named: "Brand")
            setTitleColor(UIColor(named: "White"), for: .normal)
            isUserInteractionEnabled = true
            
        case .inactive:
            backgroundColor = .white
            setTitleColor(UIColor(named: "Secondary"), for: .normal)
            layer.borderWidth = 1.0
            layer.borderColor = UIColor(named: "IndicatorLight")?.cgColor
            isUserInteractionEnabled = false
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            updateButtonAppearance(for: isHighlighted)
        }
    }
    
    private func updateButtonAppearance(for highlighted: Bool) {
        let targetAlpha: CGFloat = highlighted ? 0.7 : 1.0
        UIView.animate(withDuration: 0.1) {
            self.alpha = targetAlpha
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let gradientLayer = layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = bounds
        }
    }
    
    func getCurrentStyle() -> ButtonStyle {
        return buttonStyle
    }
    
    func toggleStyle(_ style: ButtonStyle) {
        buttonStyle = style
        configureStyle()
    }
}
