//
//  MainViewController.swift
//  Shift_Pizza
//
//  Created by Станислав Дейнекин on 28.01.2025.
//

import UIKit
import SnapKit
import Kingfisher

class MainViewController: UIViewController {

    private let viewModel: MainViewModel
    private let pizzaLabel = UILabel()
    private let scrollView = UIScrollView()
    private let contentStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 24
        return stack
    }()
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configureTitleLabel()
        setupScrollView()
        
        viewModel.onPizzasUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.updatePizzaViews()
            }
        }
        
        viewModel.fetchPizzas()
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentStackView)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(pizzaLabel.snp.bottom).offset(16)
            make.left.right.bottom.equalToSuperview()
        }
        
        contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
            make.width.equalTo(scrollView).offset(-32)
        }
    }
    
    private func configureTitleLabel() {
        view.addSubview(pizzaLabel)
        pizzaLabel.text = "Пицца"
        pizzaLabel.font = UIFont.boldSystemFont(ofSize: 24)
        pizzaLabel.textColor = UIColor(named: "Primary")
        
        pizzaLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.left.right.equalToSuperview().inset(16)
        }
    }
    
    private func updatePizzaViews() {
        contentStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for pizza in viewModel.pizzas {
            let cardView = UIView()
            cardView.backgroundColor = .white
            
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 12
            imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

            if !pizza.img.isEmpty {
                let urlString = BaseURL.shift.baseURL + pizza.img
                if let encoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                   let url = URL(string: encoded) {
                    imageView.kf.setImage(
                        with: url,
                        options: [.transition(.fade(0.2))]
                    )
                }
            }

            let nameLabel = UILabel()
            nameLabel.text = pizza.name
            nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            nameLabel.textColor = UIColor(named: "Primary")
            nameLabel.numberOfLines = 1

            let descLabel = UILabel()
            descLabel.text = pizza.description
            descLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
            descLabel.textColor = UIColor(named: "Secondary")
            descLabel.numberOfLines = 0

            let priceLabel = UILabel()
            priceLabel.text = "От \(pizza.sizes.first?.price ?? 0) ₽"
            priceLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            priceLabel.textColor = UIColor(named: "Primary")
            
            let textContainer = UIStackView(arrangedSubviews: [nameLabel, descLabel, priceLabel])
            textContainer.axis = .vertical
            textContainer.spacing = 8
            textContainer.alignment = .leading
            
            cardView.addSubview(imageView)
            cardView.addSubview(textContainer)

            imageView.snp.makeConstraints { make in
                make.left.top.bottom.equalToSuperview()
                make.height.width.equalTo(116)
                make.bottom.lessThanOrEqualToSuperview()
            }
            
            textContainer.snp.makeConstraints { make in
                make.left.equalTo(imageView.snp.right).offset(24)
                make.top.equalToSuperview()
                make.right.equalToSuperview()
            }
            
            contentStackView.addArrangedSubview(cardView)
        }
        
        contentStackView.setCustomSpacing(24, after: contentStackView.arrangedSubviews.last ?? UIView())
    }


}
