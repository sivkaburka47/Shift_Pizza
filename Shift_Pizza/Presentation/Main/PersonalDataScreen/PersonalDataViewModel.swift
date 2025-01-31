//
//  PersonalDataViewModel.swift
//  Shift_Pizza
//
//  Created by Станислав Дейнекин on 30.01.2025.
//

import Foundation

class PersonalDataViewModel {
    weak var appRouterDelegate: AppRouterDelegate?
    
    var person: PersonEntity
    
    init() {
        self.person = PersonEntity(firstname: "",
                                   lastname: "",
                                   email: "",
                                   phone: "",
                                   city: "")
    }
    
    func confirmButtonTapped() {
        appRouterDelegate?.navigateToPaymentCard()
    }
    
    var isFormValid: Bool {
        return !person.firstname.isEmpty && !person.lastname.isEmpty && !person.phone.isEmpty && !person.email.isEmpty && !person.city.isEmpty
    }
    
    func updatePerson(firstname: String?, lastname: String?, email: String?, phone: String?, city: String?) {
        if let firstname = firstname { person.firstname = firstname }
        if let lastname = lastname { person.lastname = lastname }
        if let email = email { person.email = email }
        if let phone = phone { person.phone = phone }
        if let city = city { person.city = city }
    }
}
