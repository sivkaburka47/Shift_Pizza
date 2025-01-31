//
//  PaymentCardViewController.swift
//  Shift_Pizza
//
//  Created by Станислав Дейнекин on 30.01.2025.
//

import Foundation
import UIKit

class PaymentCardViewController: UIViewController {

    private let viewModel: PaymentCardViewModel
    
    private let confirmButton = LargeCustomButton(style: .orange)

    init(viewModel: PaymentCardViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "White")
        
        view.addSubview(confirmButton)
        
        confirmButton.setTitle("Оплатить", for: .normal)
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        
        confirmButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(24)
        }
    }
    
    @objc private func confirmButtonTapped() {
        viewModel.confirmButtonTapped()
    }
}
