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
    private let middleNameField = FormTextField()
    private let phoneField = FormTextField()
    
    private let streetField = FormTextField()
    private let houseField = FormTextField()
    private let apartmentField = FormTextField()
    private let commentField = FormTextField()
    
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
        
        [stepLabel, lastNameField, firstNameField, middleNameField,
         phoneField, streetField, houseField, apartmentField, commentField].forEach {
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
        
        middleNameField.snp.makeConstraints { make in
            make.top.equalTo(firstNameField.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
        }
        
        phoneField.snp.makeConstraints { make in
            make.top.equalTo(middleNameField.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
        }
        
        streetField.snp.makeConstraints { make in
            make.top.equalTo(phoneField.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(16)
        }
        
        houseField.snp.makeConstraints { make in
            make.top.equalTo(streetField.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
        }
        
        apartmentField.snp.makeConstraints { make in
            make.top.equalTo(houseField.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
        }
        
        commentField.snp.makeConstraints { make in
            make.top.equalTo(apartmentField.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(20)
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
        configureTextField(middleNameField, title: "Отчество (при наличии)", placeholder: "Отчество")
        configureTextField(phoneField, title: "Номер телефона*", placeholder: "Номер телефона", keyboardType: .phonePad)
        configureTextField(streetField, title: "Улица*", placeholder: "Название улицы")
        configureTextField(houseField, title: "Дом*", placeholder: "Номер дома")
        configureTextField(apartmentField, title: "Квартира*", placeholder: "Номер квартиры")
        configureTextField(commentField, title: "Комментарий", placeholder: "Дополнительная информация")
    }
    
    
    private func configureTextField(_ field: FormTextField, title: String, placeholder: String, keyboardType: UIKeyboardType = .default) {
        field.titleLabel.text = title
        field.textField.placeholder = placeholder
        field.textField.keyboardType = keyboardType
        field.textField.autocapitalizationType = .none
        field.textField.returnKeyType = .next
        field.setPlaceholder(placeholder,color: UIColor(named: "Tertiary") )
    }
    
    private func configureTextFields() {
        lastNameField.textField.delegate = self
        firstNameField.textField.delegate = self
        middleNameField.textField.delegate = self
        phoneField.textField.delegate = self
        
        streetField.textField.delegate = self
        houseField.textField.delegate = self
        apartmentField.textField.delegate = self
        commentField.textField.delegate = self
        
        lastNameField.textField.addTarget(self, action: #selector(lastNameTextFieldChanged), for: .editingChanged)
        firstNameField.textField.addTarget(self, action: #selector(firstNameTextFieldChanged), for: .editingChanged)
        phoneField.textField.addTarget(self, action: #selector(phoneTextFieldChanged), for: .editingChanged)
        middleNameField.textField.addTarget(self, action: #selector(middleNameTextFieldChanged), for: .editingChanged)
        
        phoneField.textField.addTarget(self, action: #selector(phoneTextFieldDidChange), for: .editingChanged)
        
        streetField.textField.addTarget(self, action: #selector(streetTextFieldChanged), for: .editingChanged)
        houseField.textField.addTarget(self, action: #selector(houseTextFieldChanged), for: .editingChanged)
        apartmentField.textField.addTarget(self, action: #selector(apartmentTextFieldChanged), for: .editingChanged)
        commentField.textField.addTarget(self, action: #selector(commentTextFieldChanged), for: .editingChanged)
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
    
    @objc private func middleNameTextFieldChanged(_ textField: UITextField) {
        viewModel.updateMiddlename(textField.text ?? "")
    }
    
    @objc private func phoneTextFieldChanged(_ textField: UITextField) {
        viewModel.updatePhone(textField.text ?? "")
    }

    @objc private func streetTextFieldChanged(_ textField: UITextField) {
        viewModel.updateStreet(textField.text ?? "")
    }
    
    @objc private func houseTextFieldChanged(_ textField: UITextField) {
        viewModel.updateHouse(textField.text ?? "")
    }
    
    @objc private func apartmentTextFieldChanged(_ textField: UITextField) {
        viewModel.updateApartment(textField.text ?? "")
    }
    
    @objc private func commentTextFieldChanged(_ textField: UITextField) {
        viewModel.updateComment(textField.text ?? "")
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
