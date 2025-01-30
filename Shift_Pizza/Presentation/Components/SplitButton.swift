//
//  SplitButton.swift
//  Shift_Pizza
//
//  Created by Станислав Дейнекин on 29.01.2025.
//

import UIKit

class SplitButton: UIView {
    
    enum ButtonStyle {
        case sizePicker
    }
    
    let smallButton: CustomButton
    let mediumButton: CustomButton
    let largeButton: CustomButton
    
    private var style: ButtonStyle
    
    var onSizeSelected: ((String) -> Void)?
    
    init(style: ButtonStyle) {
        self.style = style
        self.smallButton = CustomButton(style: .white)
        self.mediumButton = CustomButton(style: .gray)
        self.largeButton = CustomButton(style: .gray)
        
        super.init(frame: .zero)
        
        setupView()
        setupButtons()
        configureButtons()
        layoutButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        layer.cornerRadius = 16
        clipsToBounds = true
        backgroundColor = UIColor(named: "IndicatorLight")
    }
    
    private func setupButtons() {
        smallButton.layer.cornerRadius = 14
        mediumButton.layer.cornerRadius = 14
        largeButton.layer.cornerRadius = 14
        
        smallButton.addTarget(self, action: #selector(smallButtonTapped), for: .touchUpInside)
        mediumButton.addTarget(self, action: #selector(mediumButtonTapped), for: .touchUpInside)
        largeButton.addTarget(self, action: #selector(largeButtonTapped), for: .touchUpInside)
        
        addSubview(smallButton)
        addSubview(mediumButton)
        addSubview(largeButton)
    }
    
    private func configureButtons() {
        switch style {
        case .sizePicker:
            smallButton.setTitle("Маленькая", for: .normal)
            mediumButton.setTitle("Средняя", for: .normal)
            largeButton.setTitle("Большая", for: .normal)
        }
        
        smallButton.toggleStyle(.white)
        mediumButton.toggleStyle(.gray)
        largeButton.toggleStyle(.gray)
    }
    
    private func layoutButtons() {
        smallButton.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview().inset(2)
            make.trailing.equalTo(mediumButton.snp.leading).offset(-2)
            make.width.equalTo(mediumButton)
        }
        
        mediumButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(2)
            make.leading.equalTo(smallButton.snp.trailing).offset(2)
            make.trailing.equalTo(largeButton.snp.leading).offset(-2)
            make.width.equalTo(smallButton)
        }
        
        largeButton.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview().inset(2)
            make.width.equalTo(smallButton)
        }
    }
    
    @objc private func smallButtonTapped() {
        smallButton.toggleStyle(.white)
        mediumButton.toggleStyle(.gray)
        largeButton.toggleStyle(.gray)
        onSizeSelected?("SMALL")
    }
    
    @objc private func mediumButtonTapped() {
        smallButton.toggleStyle(.gray)
        mediumButton.toggleStyle(.white)
        largeButton.toggleStyle(.gray)
        onSizeSelected?("MEDIUM")
    }
    
    @objc private func largeButtonTapped() {
        smallButton.toggleStyle(.gray)
        mediumButton.toggleStyle(.gray)
        largeButton.toggleStyle(.white)
        onSizeSelected?("LARGE")
    }
}
