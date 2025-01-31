//
//  PersonalDataViewModel.swift
//  Shift_Pizza
//
//  Created by Станислав Дейнекин on 30.01.2025.
//

import Foundation
import UIKit

class PersonalDataViewModel {
    weak var appRouterDelegate: AppRouterDelegate?
    weak var uiViewController: UIViewController?
    
    var person: PersonEntity
    
    var isConfirmButtonActive: ((Bool) -> Void)?
    
    var isFirstnameValid: Bool = false {
        didSet {
            validateFields()
        }
    }
    
    var isLastnameValid: Bool = false {
        didSet {
            validateFields()
        }
    }
    
    var isEmailValid: Bool = false {
        didSet {
            validateFields()
        }
    }
    
    var isPhoneValid: Bool = false {
        didSet {
            validateFields()
        }
    }
    
    var isCityValid: Bool = false {
        didSet {
            validateFields()
        }
    }
    
    init() {
        self.person = PersonEntity(firstname: "",
                                   lastname: "",
                                   email: "",
                                   phone: "",
                                   city: "")
    }
    
    func confirmButtonTapped() {
        guard let vc = uiViewController else { return }
        appRouterDelegate?.navigateToPaymentCard(vc: vc)
    }
    
    
    func updateFirstname(_ firstname: String) {
        self.person.firstname = firstname
        isFirstnameValid = !firstname.isEmpty
        validateFields()
    }
    
    func updateLastname(_ lastname: String) {
        self.person.lastname = lastname
        isLastnameValid = !lastname.isEmpty
        validateFields()
    }
    func updateEmail(_ email: String) {
        self.person.email = email
        isEmailValid = !email.isEmpty
        validateFields()
    }
    
    func updatePhone(_ phone: String) {
        self.person.phone = phone
        isPhoneValid = !phone.isEmpty
        validateFields()
    }
    
    func updateCity(_ city: String) {
        self.person.city = city
        isCityValid = !city.isEmpty
        validateFields()
    }
    
    private func validateFields() {
        let isFirstnameValid = self.isFirstnameValid
        let isLastnameValid = self.isLastnameValid
        let isEmailValid = self.isEmailValid
        let isPhoneValid = self.isPhoneValid
        let isCityValid = self.isCityValid
        
        let isValid = isFirstnameValid && isLastnameValid && isEmailValid && isPhoneValid && isCityValid
        isConfirmButtonActive?(isValid)
    }
    
    private func  isValidEmail(_ input: String) -> Bool {
        let regularExpression = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regularExpression)
        return predicate.evaluate(with: input)
    }
    
    private func isValidLatinCharacters(_ input: String) -> Bool {
        let regularExpression = "^[A-Za-z0-9#?!@$%^&*-]+$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regularExpression)
        return predicate.evaluate(with: input)
    }
}
