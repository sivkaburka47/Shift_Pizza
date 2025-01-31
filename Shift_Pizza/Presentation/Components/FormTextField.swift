//
//  FormTextField.swift
//  Shift_Pizza
//
//  Created by Станислав Дейнекин on 31.01.2025.
//

import UIKit

class FormTextField: UIView {
    let titleLabel = UILabel()
    let textField = UITextField()
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        titleLabel.textColor = UIColor(named: "Primary")

        textField.borderStyle = .none
        textField.backgroundColor = UIColor(named: "White")
        textField.textColor = UIColor(named: "Primary")
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(named: "BorderLight")?.cgColor
        textField.layer.cornerRadius = 8
        textField.layer.masksToBounds = true
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 0))
        textField.leftViewMode = .always
        

        let stack = UIStackView(arrangedSubviews: [titleLabel, textField])
        stack.axis = .vertical
        stack.spacing = 8
        addSubview(stack)

        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        textField.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
    }
    
    func setPlaceholder(_ text: String, color: UIColor?) {
        let placeholderColor = color ?? UIColor(named: "Placeholder") ?? .lightGray
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: placeholderColor,
            .font: UIFont.systemFont(ofSize: 16, weight: .regular)
        ]
        textField.attributedPlaceholder = NSAttributedString(
            string: text,
            attributes: attributes
        )
    }

}
