//
//  SignInViewController.swift
//  Shift_Pizza
//
//  Created by Станислав Дейнекин on 28.01.2025.
//

import UIKit
import SnapKit

class SignInViewController: UIViewController {
    
    private let viewModel: SignInViewModel
    private let signInButton = LargeCustomButton(style: .orange)

    init(viewModel: SignInViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        signInButton.setTitle("Войти", for: .normal)
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        
        view.addSubview(signInButton)
        
        signInButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
    }

    @objc private func didTapSignIn() {
        viewModel.signIn()
    }
}


