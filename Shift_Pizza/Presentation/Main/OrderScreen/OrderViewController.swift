//
//  OrderViewController.swift
//  Shift_Pizza
//
//  Created by Станислав Дейнекин on 28.01.2025.
//

import Foundation
import UIKit

class OrderViewController: UIViewController {

    private let viewModel: OrderViewModel

    init(viewModel: OrderViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "White")
        let label = UILabel()
        label.text = "В разработке..."
        label.textColor = UIColor(named: "Tertiary")
        label.font = .systemFont(ofSize: 28, weight: .semibold)
        label.textAlignment = .center
        
        view.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
}
