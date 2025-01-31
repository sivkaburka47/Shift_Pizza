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
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let stepLabel = UILabel()
    private let progressBackground = UIView()
    private let progressFill = UIView()
    private let confirmButton = LargeCustomButton(style: .orange)
    
    private let lastNameField = FormTextField()
    private let firstNameField = FormTextField()
    private let phoneField = FormTextField()
    private let emailField = FormTextField()
    private let cityField = FormTextField()
    
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
        setupConstraints()
        setupActions()
        bindToViewModel()
        setupTextFields()
        configureTextFields()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(named: "White")
        
        
        stepLabel.text = "Шаг 1 из 2"
        stepLabel.font = .systemFont(ofSize: 14)
        stepLabel.textColor = .systemGray
        
        progressBackground.backgroundColor = UIColor(named: "IndicatorLight")
        progressBackground.layer.cornerRadius = 2
        contentView.addSubview(progressBackground)

        progressFill.backgroundColor = UIColor(named: "IndicatorPositive")
        progressFill.layer.cornerRadius = 2
        progressBackground.addSubview(progressFill)
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [stepLabel, lastNameField, firstNameField,
         phoneField, emailField, cityField].forEach {
            contentView.addSubview($0)
        }
        
        view.addSubview(confirmButton)
        
        confirmButton.setTitle("Продолжить", for: .normal)
        confirmButton.toggleStyle(.inactive)
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(confirmButton.snp.top).offset(-16)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.width.equalToSuperview()
            make.height.equalToSuperview().priority(.low)
        }
        
        
        stepLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24)
            make.left.right.equalToSuperview().inset(16)
        }
        
        progressBackground.snp.makeConstraints { make in
            make.top.equalTo(stepLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(4)
        }

        progressFill.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        
        lastNameField.snp.makeConstraints { make in
            make.top.equalTo(progressBackground.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(16)
        }
        
        firstNameField.snp.makeConstraints { make in
            make.top.equalTo(lastNameField.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
        }
        
        phoneField.snp.makeConstraints { make in
            make.top.equalTo(firstNameField.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
        }
        
        emailField.snp.makeConstraints { make in
            make.top.equalTo(phoneField.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
        }
        
        cityField.snp.makeConstraints { make in
            make.top.equalTo(emailField.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(24)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(50)
        }
    }
    
    private func setupTextFields() {
        configureTextField(lastNameField, title: "Фамилия*", placeholder: "Фамилия")
        configureTextField(firstNameField, title: "Имя*", placeholder: "Имя")
        configureTextField(phoneField, title: "Номер телефона*", placeholder: "Номер телефона", keyboardType: .phonePad)
        configureTextField(emailField, title: "Email*", placeholder: "Email", keyboardType: .emailAddress)
        configureTextField(cityField, title: "Город*", placeholder: "Город")
    }
    
    
    private func configureTextField(_ field: FormTextField, title: String, placeholder: String, keyboardType: UIKeyboardType = .default) {
        field.titleLabel.text = title
        field.textField.placeholder = placeholder
        field.textField.keyboardType = keyboardType
        field.textField.autocapitalizationType = .none
        field.textField.returnKeyType = .next
    }
    
    private func configureTextFields() {
        lastNameField.textField.delegate = self
        firstNameField.textField.delegate = self
        phoneField.textField.delegate = self
        emailField.textField.delegate = self
        cityField.textField.delegate = self
        
        lastNameField.textField.addTarget(self, action: #selector(lastNameTextFieldChanged), for: .editingChanged)
        firstNameField.textField.addTarget(self, action: #selector(firstNameTextFieldChanged), for: .editingChanged)
        phoneField.textField.addTarget(self, action: #selector(phoneTextFieldChanged), for: .editingChanged)
        emailField.textField.addTarget(self, action: #selector(emailTextFieldChanged), for: .editingChanged)
        cityField.textField.addTarget(self, action: #selector(cityTextFieldChanged), for: .editingChanged)
        
        phoneField.textField.addTarget(self, action: #selector(phoneTextFieldDidChange), for: .editingChanged)
    }
    
    private func setupActions() {
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    }
    
    @objc private func confirmButtonTapped() {
        viewModel.confirmButtonTapped()
    }
    
    @objc private func lastNameTextFieldChanged(_ textField: UITextField) {
        viewModel.updateLastname(textField.text ?? "")
    }

    @objc private func firstNameTextFieldChanged(_ textField: UITextField) {
        viewModel.updateFirstname(textField.text ?? "")
    }

    @objc private func phoneTextFieldChanged(_ textField: UITextField) {
        viewModel.updatePhone(textField.text ?? "")
    }

    @objc private func emailTextFieldChanged(_ textField: UITextField) {
        viewModel.updateEmail(textField.text ?? "")
    }

    @objc private func cityTextFieldChanged(_ textField: UITextField) {
        viewModel.updateCity(textField.text ?? "")
    }

    @objc private func phoneTextFieldDidChange(_ textField: UITextField) {
        guard var text = textField.text else { return }
        
        text = text.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        
        if text.count > 11 {
            text = String(text.prefix(11))
        }
        
        textField.text = text
        viewModel.updatePhone(text)
    }
    
    private func bindToViewModel() {
        viewModel.isConfirmButtonActive = { [weak self] isActive in
            self?.confirmButton.toggleStyle(isActive ? .orange : .inactive)
            self?.confirmButton.isEnabled = isActive
        }
    }
}


extension PersonalDataViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
