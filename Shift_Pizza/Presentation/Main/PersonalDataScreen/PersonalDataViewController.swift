//
//  PersonalDataViewController.swift
//  Shift_Pizza
//
//  Created by Станислав Дейнекин on 30.01.2025.
//

import UIKit
import SnapKit

class PersonalDataViewController: UIViewController {

    private let viewModel: PersonalDataViewModel

    private let lastnameTextField = PersonalDataViewController.createTextField(placeholder: "Фамилия")
    private let firstnameTextField = PersonalDataViewController.createTextField(placeholder: "Имя")
    private let phoneTextField = PersonalDataViewController.createTextField(placeholder: "Телефон", keyboardType: .phonePad)
    private let emailTextField = PersonalDataViewController.createTextField(placeholder: "Email")
    private let cityTextField = PersonalDataViewController.createTextField(placeholder: "Город")

    private let confirmButton = LargeCustomButton(style: .orange)

    init(viewModel: PersonalDataViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
    }

    private func setupUI() {
        view.backgroundColor = UIColor(named: "White")
        
        let stackView = UIStackView(arrangedSubviews: [
            lastnameTextField,
            firstnameTextField,
            emailTextField,
            phoneTextField,
            cityTextField
        ])
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.distribution = .fillEqually

        view.addSubview(stackView)
        view.addSubview(confirmButton)

        stackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.left.right.equalToSuperview().inset(16)
        }

        confirmButton.setTitle("Продолжить", for: .normal)
        confirmButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(24)
            make.height.equalTo(50)
        }
    }

    private func setupActions() {
        [lastnameTextField, firstnameTextField, emailTextField, phoneTextField, cityTextField]
            .forEach { $0.addTarget(self, action: #selector(textFieldChanged(_:)), for: .editingChanged) }
        
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    }

    @objc private func textFieldChanged(_ textField: UITextField) {
        viewModel.updatePerson(
            firstname: firstnameTextField.text,
            lastname: lastnameTextField.text,
            email: emailTextField.text,
            phone: phoneTextField.text,
            city: cityTextField.text
        )
        updateButtonState()
    }

    private func updateButtonState() {
        confirmButton.isEnabled = viewModel.isFormValid
        confirmButton.alpha = viewModel.isFormValid ? 1.0 : 0.5
    }

    @objc private func confirmButtonTapped() {
        viewModel.confirmButtonTapped()
    }

    private static func createTextField(placeholder: String, keyboardType: UIKeyboardType = .default) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.keyboardType = keyboardType
        return textField
    }
}
