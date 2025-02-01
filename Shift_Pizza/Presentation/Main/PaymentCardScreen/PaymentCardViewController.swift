//
//  PaymentCardViewController.swift
//  Shift_Pizza
//
//  Created by Станислав Дейнекин on 30.01.2025.
//

import UIKit
import SnapKit

class PaymentCardViewController: UIViewController {
    
    private let viewModel: PaymentCardViewModel
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let stepLabel = UILabel()
    private let progressBackground = UIView()
    private let progressFill = UIView()
    private let confirmButton = LargeCustomButton(style: .orange)
    private let cardContainerView = UIView()
    private let rowContainer = UIView()
    
    private let cardNumberField = FormTextField()
    private let expiryDateField = FormTextField()
    private let cvvField = FormTextField()
    
    private let fieldsStack = UIStackView()
    
    
    init(viewModel: PaymentCardViewModel) {
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
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(named: "White")
        
        stepLabel.text = "Шаг 2 из 2"
        stepLabel.font = .systemFont(ofSize: 14)
        stepLabel.textColor = .systemGray
        view.addSubview(stepLabel)
        
        progressBackground.backgroundColor = UIColor(named: "IndicatorLight")
        progressBackground.layer.cornerRadius = 2
        view.addSubview(progressBackground)
        
        progressFill.backgroundColor = UIColor(named: "IndicatorPositive")
        progressFill.layer.cornerRadius = 2
        progressBackground.addSubview(progressFill)
        
        cardContainerView.backgroundColor = UIColor(named: "BGDisabled")
        cardContainerView.layer.cornerRadius = 16
        view.addSubview(cardContainerView)
        
        cardNumberField.titleLabel.text = "Номер*"
        cardNumberField.textField.placeholder = "0000 0000 0000 0000"
        cardNumberField.setPlaceholder("0000 0000 0000 0000",color: UIColor(named: "Tertiary") )
        cardContainerView.addSubview(cardNumberField)

        let expiryCVVStack = UIStackView()
        expiryCVVStack.axis = .horizontal
        expiryCVVStack.spacing = 24
        expiryCVVStack.distribution = .fillEqually
        
        expiryDateField.titleLabel.text = "Срок*"
        expiryDateField.textField.placeholder = "MM/YY"
        expiryDateField.setPlaceholder("MM/YY",color: UIColor(named: "Tertiary") )
        expiryCVVStack.addArrangedSubview(expiryDateField)
        
        cvvField.titleLabel.text = "CVV*"
        cvvField.textField.placeholder = "CVC/CVV"
        cvvField.setPlaceholder("CVC/CVV",color: UIColor(named: "Tertiary") )
        expiryCVVStack.addArrangedSubview(cvvField)
        
        rowContainer.addSubview(expiryCVVStack)
        expiryCVVStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        cardContainerView.addSubview(rowContainer)
        
        confirmButton.setTitle("Оплатить", for: .normal)
        confirmButton.toggleStyle(.inactive)
        view.addSubview(confirmButton)
        
    }
    
    
    private func setupConstraints() {
        stepLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        progressBackground.snp.makeConstraints { make in
            make.top.equalTo(stepLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(4)
        }
        
        progressFill.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        cardContainerView.snp.makeConstraints { make in
            make.top.equalTo(progressBackground.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(212)
        }
        
        cardNumberField.snp.makeConstraints { make in
            make.top.equalToSuperview().inset( 16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        rowContainer.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(cardNumberField.snp.bottom).offset(24)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(cardContainerView.snp.bottom).offset(24)
            make.height.equalTo(50)
        }
        
        [cardNumberField, expiryDateField, cvvField].forEach {
            $0.snp.makeConstraints { make in
                make.height.equalTo(72)
            }
        }
    }
    
    private func setupTextFields() {
        cardNumberField.textField.keyboardType = .numberPad
        expiryDateField.textField.keyboardType = .numbersAndPunctuation
        cvvField.textField.keyboardType = .numberPad
        
        [cardNumberField, expiryDateField, cvvField].forEach {
            $0.textField.delegate = self
        }
        
        cardNumberField.textField.addTarget(self, action: #selector(cardNumberChanged), for: .editingChanged)
        expiryDateField.textField.addTarget(self, action: #selector(expiryDateChanged), for: .editingChanged)
        cvvField.textField.addTarget(self, action: #selector(cvvChanged), for: .editingChanged)
    }
    
    private func configureTextField(_ field: FormTextField, title: String, placeholder: String) {
        field.titleLabel.text = title
        field.textField.placeholder = placeholder
        field.textField.delegate = self

    }
    
    private func setupActions() {
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        
        cardNumberField.textField.addTarget(self, action: #selector(cardNumberChanged), for: .editingChanged)
        expiryDateField.textField.addTarget(self, action: #selector(expiryDateChanged), for: .editingChanged)
        cvvField.textField.addTarget(self, action: #selector(cvvChanged), for: .editingChanged)
    }
    
    @objc private func confirmButtonTapped() {

        viewModel.confirmButtonTapped()

        
    }
    
    @objc private func cardNumberChanged(_ textField: UITextField) {
        let formatted = formatCardNumber(textField.text ?? "")
        textField.text = formatted
        viewModel.updateCardNumber(formatted.replacingOccurrences(of: " ", with: ""))
    }
    
    @objc private func expiryDateChanged(_ textField: UITextField) {
        let formatted = formatExpiryDate(textField.text ?? "")
        textField.text = formatted
        viewModel.updateExpiryDate(formatted)
    }
    
    @objc private func cvvChanged(_ textField: UITextField) {
        let text = String(textField.text?.prefix(4) ?? "")
        textField.text = text
        viewModel.updateCVV(text)
    }
    
    private func bindToViewModel() {
        viewModel.isConfirmButtonActive = { [weak self] isActive in
            self?.confirmButton.toggleStyle(isActive ? .orange : .inactive)
            self?.confirmButton.isEnabled = isActive
        }
    }
    
    private func formatCardNumber(_ input: String) -> String {
        let numbers = input.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        
        for (index, char) in numbers.enumerated() {
            if index > 0 && index % 4 == 0 {
                result += " "
            }
            result.append(char)
            if index >= 15 { break }
        }
        return result
    }
    
    private func formatExpiryDate(_ input: String) -> String {
        let numbers = input.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        
        for (index, char) in numbers.enumerated() {
            if index == 2 {
                result += "/"
            }
            result.append(char)
            if index >= 3 { break }
        }
        return result
    }
}

extension PaymentCardViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        switch textField {
        case cardNumberField.textField:
            return updatedText.count <= 19
        case expiryDateField.textField:
            return updatedText.count <= 5
        case cvvField.textField:
            return updatedText.count <= 4
        default:
            return true
        }
    }
}

