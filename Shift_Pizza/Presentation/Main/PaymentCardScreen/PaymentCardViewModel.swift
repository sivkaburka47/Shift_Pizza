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
    
    let person: PersonEntity
    
    let address: ReceiverAddressEntity
    
    private let payForOrderUseCase: PayForOrderUseCase
    
    
    init(person: PersonEntity, address: ReceiverAddressEntity) {
        self.person = person
        self.address = address
        self.payForOrderUseCase = PayForOrderUseCaseImpl.create()
    }
    
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
        
        guard let data = UserDefaults.standard.data(forKey: "savedPizzaOrders") else {
            return
        }
        
        var orders: [OrderedPizzaEntity] = []
        
        do {
            let decodedOrders = try JSONDecoder().decode([OrderedPizzaEntity].self, from: data)
            orders = decodedOrders
        } catch {
            print("Ошибка декодирования: \(error)")
            return
        }
        
        let receiverAddress = ReceiverAddress(
            street: address.street,
            house: address.house,
            apartment: address.apartment,
            comment: address.comment
        )
        
        let person = Person(
            firstname: person.firstname,
            lastname: person.lastname,
            middlename: person.middlename,
            phone: person.phone
        )
        

        let debitCard = DebitCard(
            pan: cardNumber,
            expireDate: expiryDate,
            cvv: cvv
        )
        
        var pizzas: [OrderedPizza] = []
        
        orders.forEach { pizza in
            for _ in 0..<pizza.quantity {
                pizzas.append(
                    OrderedPizza(
                        id: pizza.id,
                        name: pizza.name,
                        toppings: pizza.toppings.map { OrderedPizzaIngredient(name: $0.name, cost: Double($0.cost)) },
                        size: PizzaSize(name: pizza.size.name, price: pizza.size.price),
                        doughs: PizzaDough(name: pizza.doughs.name, price: pizza.doughs.price)
                    )
                )
            }
        }

        let pizzaPayment = CreatePizzaPaymentDto(
            receiverAddress: receiverAddress,
            person: person,
            debitCard: debitCard,
            pizzas: pizzas
        )
        Task {
            do {
                let paymentOrder = try await payForOrderUseCase.execute(request: pizzaPayment)
                print("Ответ \(paymentOrder.success)")
            } catch {
                print("Ошибка при оплате: \(error)")
            }
        }

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
