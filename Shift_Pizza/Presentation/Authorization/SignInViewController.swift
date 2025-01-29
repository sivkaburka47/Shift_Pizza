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
        title = "Sign In"
        let signInButton = UIButton(type: .system)
        signInButton.setTitle("Sign In", for: .normal)
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        
        view.addSubview(signInButton)
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signInButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        signInButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }

    @objc private func didTapSignIn() {
        viewModel.signIn()
    }
}


