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
    var address: ReceiverAddressEntity
    
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
    
    var isMiddlenameValid: Bool = false {
        didSet {
            validateFields()
        }
    }
    
    var isPhoneValid: Bool = false {
        didSet {
            validateFields()
        }
    }
    
    var isStreetValid: Bool = false {
        didSet {
            validateFields()
        }
    }
    
    var isHouseValid: Bool = false {
        didSet {
            validateFields()
        }
    }
    
    var isApartmentValid: Bool = false {
        didSet {
            validateFields()
        }
    }
    
    var isAddressValid: Bool = false {
        didSet {
            validateFields()
        }
    }
    

    
    init() {
        self.person = PersonEntity(firstname: "",
                                   lastname: "",
                                   middlename: "",
                                   phone: "")
        
        self.address = ReceiverAddressEntity(street: "",
                                             house: "",
                                             apartment: "",
                                             comment: "")
    }
    
    func confirmButtonTapped() {
        print("Вызван в viewCOntroller")
        guard let vc = uiViewController else { return }
        appRouterDelegate?.navigateToPaymentCard(vc: vc, person: person, address: address)
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
    func updateMiddlename(_ middlename: String) {
        self.person.middlename = middlename
        isMiddlenameValid = !middlename.isEmpty
        validateFields()
    }
    
    func updatePhone(_ phone: String) {
        self.person.phone = phone
        isPhoneValid = !phone.isEmpty
        validateFields()
    }
    
    func updateStreet(_ street: String) {
        self.address.street = street
        isStreetValid = !street.isEmpty
        validateFields()
    }
    
    func updateHouse(_ house: String) {
        self.address.house = house
        isHouseValid = !house.isEmpty
        validateFields()
    }
    
    func updateApartment(_ apartment: String) {
        self.address.apartment = apartment
        isApartmentValid = !apartment.isEmpty
        validateFields()
    }
    
    func updateComment(_ comment: String) {
        self.address.comment = comment
        isAddressValid = !comment.isEmpty
        validateFields()
    }
    
    
    private func validateFields() {
        let isFirstnameValid = self.isFirstnameValid
        let isLastnameValid = self.isLastnameValid
        let isMiddlenameValid = self.isMiddlenameValid
        let isPhoneValid = self.isPhoneValid
        
        let isStreetValid = self.isStreetValid
        let isHouseValid = self.isHouseValid
        let isApartmentValid = self.isApartmentValid
        let isAddressValid = self.isAddressValid
        
        let isValid = isFirstnameValid && isLastnameValid && isMiddlenameValid && isPhoneValid && isStreetValid && isHouseValid && isApartmentValid && isAddressValid
        isConfirmButtonActive?(isValid)
    }
    
    
    private func isValidLatinCharacters(_ input: String) -> Bool {
        let regularExpression = "^[A-Za-z0-9#?!@$%^&*-]+$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regularExpression)
        return predicate.evaluate(with: input)
    }
}
