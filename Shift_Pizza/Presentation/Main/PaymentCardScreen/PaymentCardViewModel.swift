//
//  PaymentCardViewModel.swift
//  Shift_Pizza
//
//  Created by Станислав Дейнекин on 30.01.2025.
//

import Foundation
import UIKit

class PaymentCardViewModel {
    weak var appRouterDelegate: AppRouterDelegate?
    weak var uiViewController: UIViewController?
    
    var isConfirmButtonActive: ((Bool) -> Void)?
    
    private var cardNumber: String = ""
    private var expiryDate: String = ""
    private var cvv: String = ""
    
    private var isCardNumberValid: Bool = false {
        didSet { validateFields() }
    }
    
    private var isExpiryDateValid: Bool = false {
        didSet { validateFields() }
    }
    
    private var isCVVValid: Bool = false {
        didSet { validateFields() }
    }
    
    func updateCardNumber(_ number: String) {
        cardNumber = number
        isCardNumberValid = validateCardNumber(number)
    }
    
    func updateExpiryDate(_ date: String) {
        expiryDate = date
        isExpiryDateValid = validateExpiryDate(date)
    }
    
    func updateCVV(_ cvv: String) {
        self.cvv = cvv
        isCVVValid = validateCVV(cvv)
    }
    
    func confirmButtonTapped() {
        guard let vc = uiViewController else { return }
//        appRouterDelegate?.navigateToOrderConfirmation(vc: vc)
    }
    
    private func validateFields() {
        let isValid = isCardNumberValid && isExpiryDateValid && isCVVValid
        isConfirmButtonActive?(isValid)
    }
    
    private func validateCardNumber(_ input: String) -> Bool {
        let cleaned = input.replacingOccurrences(of: " ", with: "")
        return cleaned.count == 16 && cleaned.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
    
    private func validateExpiryDate(_ input: String) -> Bool {
        let components = input.split(separator: "/")
        guard components.count == 2,
              let month = Int(components[0]),
              let year = Int(components[1]),
              (1...12).contains(month),
              year >= 23 else { return false }
        return true
    }
    
    private func validateCVV(_ input: String) -> Bool {
        return (3...4).contains(input.count) && input.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}
