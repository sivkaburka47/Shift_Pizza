//
//  ShoppingCartViewController.swift
//  Shift_Pizza
//
//  Created by Станислав Дейнекин on 28.01.2025.
//

import Foundation
import UIKit

class ShoppingCartViewController: UIViewController {

    private let viewModel: ShoppingCartViewModel

    init(viewModel: ShoppingCartViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
    }
}
