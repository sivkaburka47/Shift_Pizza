//
//  SplitButtonDuo.swift
//  Shift_Pizza
//
//  Created by Станислав Дейнекин on 30.01.2025.
//

import UIKit

class SplitButtonDuo: UIView {
    
    enum ButtonStyle {
        case doughPicker
    }
    
    let thinButton: CustomButton
    let thickButton: CustomButton
    
    private var style: ButtonStyle
    var onDoughSelected: ((String) -> Void)?
    
    init(style: ButtonStyle) {
        self.style = style
        self.thinButton = CustomButton(style: .white)
        self.thickButton = CustomButton(style: .gray)
        
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
        thinButton.layer.cornerRadius = 14
        thickButton.layer.cornerRadius = 14
        
        thinButton.addTarget(self, action: #selector(thinButtonTapped), for: .touchUpInside)
        thickButton.addTarget(self, action: #selector(thickButtonTapped), for: .touchUpInside)
        
        addSubview(thinButton)
        addSubview(thickButton)
    }
    
    private func configureButtons() {
        switch style {
        case .doughPicker:
            thinButton.setTitle("Традиционное", for: .normal)
            thickButton.setTitle("Тонкое", for: .normal)
        }
        
        thinButton.toggleStyle(.white)
        thickButton.toggleStyle(.gray)
    }
    
    private func layoutButtons() {
        thinButton.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview().inset(2)
            make.trailing.equalTo(thickButton.snp.leading).offset(-2)
            make.width.equalTo(thickButton)
        }
        
        thickButton.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview().inset(2)
            make.width.equalTo(thinButton)
        }
    }
    
    @objc private func thinButtonTapped() {
        thinButton.toggleStyle(.white)
        thickButton.toggleStyle(.gray)
        onDoughSelected?("THIN")
    }
    
    @objc private func thickButtonTapped() {
        thinButton.toggleStyle(.gray)
        thickButton.toggleStyle(.white)
        onDoughSelected?("THICK")
    }
}
