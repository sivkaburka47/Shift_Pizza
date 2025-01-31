//
//  ShoppingCartViewController.swift
//  Shift_Pizza
//
//  Created by Станислав Дейнекин on 28.01.2025.
//

import UIKit
import SnapKit
import Kingfisher

class ShoppingCartViewController: UIViewController {

    private let viewModel: ShoppingCartViewModel
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private let checkoutView = UIView()
    private let totalPriceLabel = UILabel()
    private let titleLabel = UILabel()
    private let confirmButton = LargeCustomButton(style: .orange)

    init(viewModel: ShoppingCartViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTitleLabel()
        setupCheckoutView()
        setupUI()
        
        viewModel.onCartUpdated = { [weak self] in
            self?.loadCartItems()
            self?.updateTotalPrice()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadOrders()
        loadCartItems()
        updateTotalPrice()
    }
    
    

    
    private func configureTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.text = "Корзина"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textColor = UIColor(named: "Primary")
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.left.right.equalToSuperview().inset(16)
        }
    }

    private func setupUI() {
        view.backgroundColor = .white

        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(checkoutView.snp.top)
        }

        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .fill
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(16)
            make.leading.trailing.equalTo(view).inset(16)
            make.width.equalTo(scrollView.snp.width).offset(-32)
        }
        
    }

    private func loadCartItems() {
        let orders = viewModel.getOrders()
        print("Loaded Orders: \(orders)")

        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        if orders.isEmpty {
            let emptyLabel = UILabel()
            emptyLabel.text = "Ваш заказ пуст"
            emptyLabel.textAlignment = .center
            stackView.addArrangedSubview(emptyLabel)
            return
        }

        for (index, order) in orders.enumerated() {
            let cardView = createPizzaCard(for: order, at: index)
            stackView.addArrangedSubview(cardView)

            if index < orders.count - 1 {
                let separator = createSeparator()
                stackView.addArrangedSubview(separator)
            }
        }
    }

    private func createPizzaCard(for order: OrderedPizza, at index: Int) -> UIView {
        let cardView = UIView()
        cardView.backgroundColor = .white

        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.kf.setImage(with: URL(string: BaseURL.shift.baseURL + order.img))
        
        let nameLabel = UILabel()
        nameLabel.text = order.name
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        nameLabel.textColor = UIColor(named: "Primary")
        
        let toppingsText = order.toppings.isEmpty ? "" : " + " + order.toppings.map { $0.nameInRus }.joined(separator: ", ")
        let detailsLabel = UILabel()
        detailsLabel.text = "\(order.size.sizeInCmFull), \(order.doughs.doughsInStr)\(toppingsText)"
        detailsLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        detailsLabel.textColor = UIColor(named: "Secondary")
        detailsLabel.numberOfLines = 2

        let countView = UIView()
        countView.backgroundColor = UIColor(named: "SecondaryBG")
        countView.layer.cornerRadius = 14

        let minusButton = UIButton()
        minusButton.setTitle("-", for: .normal)
        minusButton.setTitleColor(UIColor(named: "Primary"), for: .normal)
        minusButton.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .regular)

        let countLabel = UILabel()
        countLabel.text = "\(order.quantity)"
        countLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        countLabel.textColor = UIColor(named: "Primary")
        countLabel.textAlignment = .center

        let plusButton = UIButton()
        plusButton.setTitle("+", for: .normal)
        plusButton.setTitleColor(UIColor(named: "Primary"), for: .normal)
        plusButton.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .regular)

        let editButton = UIButton()
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14, weight: .regular),
            .foregroundColor: UIColor(named: "Quartenery") ?? UIColor.black,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        let attributedTitle = NSAttributedString(string: "Изменить", attributes: attributes)
        editButton.setAttributedTitle(attributedTitle, for: .normal)

        let priceLabel = UILabel()
        priceLabel.text = "\(order.totalPrice * order.quantity) ₽"
        priceLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        priceLabel.textColor = UIColor(named: "Primary")

        minusButton.addAction(UIAction(handler: { [weak self] _ in
            self?.viewModel.decreaseQuantity(at: index)
        }), for: .touchUpInside)

        plusButton.addAction(UIAction(handler: { [weak self] _ in
            self?.viewModel.increaseQuantity(at: index)
        }), for: .touchUpInside)

        editButton.addAction(UIAction(handler: { [weak self] _ in
            self?.viewModel.editPizza(at: index)
        }), for: .touchUpInside)

        cardView.addSubview(imageView)
        cardView.addSubview(nameLabel)
        cardView.addSubview(detailsLabel)
        cardView.addSubview(countView)
        cardView.addSubview(editButton)
        cardView.addSubview(priceLabel)

        countView.addSubview(minusButton)
        countView.addSubview(countLabel)
        countView.addSubview(plusButton)

        cardView.snp.makeConstraints { make in
            make.height.equalTo(96)
        }

        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(8)
            make.width.height.equalTo(66)
        }

        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(imageView.snp.trailing).offset(16)
            make.trailing.equalToSuperview().offset(-12)
        }

        detailsLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.leading.equalTo(nameLabel)
            make.trailing.equalToSuperview().offset(-12)
        }

        countView.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel)
            make.bottom.equalToSuperview()
            make.height.equalTo(24)
            make.width.equalTo(84)
        }

        minusButton.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
            make.width.height.equalTo(32)
        }

        countLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(32)
        }

        plusButton.snp.makeConstraints { make in
            make.trailing.centerY.equalToSuperview()
            make.width.height.equalTo(32)
        }

        editButton.snp.makeConstraints { make in
            make.leading.equalTo(countView.snp.trailing).offset(16)
            make.centerY.equalTo(countView)
        }

        priceLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalTo(countView)
        }

        return cardView
    }

    
    private func createSeparator() -> UIView {
        let separatorContainer = UIView()

        let separator = UIView()
        separator.backgroundColor = UIColor(named: "BorderLight")
        separatorContainer.addSubview(separator)

        separator.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }

        separatorContainer.snp.makeConstraints { make in
            make.height.equalTo(49)
        }

        return separatorContainer
    }
    
    private func setupCheckoutView() {
        checkoutView.backgroundColor = .white
        checkoutView.layer.shadowColor = UIColor.black.cgColor
        checkoutView.layer.shadowOpacity = 0.1
        checkoutView.layer.shadowOffset = CGSize(width: 0, height: -2)
        checkoutView.layer.shadowRadius = 4
        view.addSubview(checkoutView)

        checkoutView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(128)
        }

        let priceStack = UIStackView()
        priceStack.axis = .horizontal
        priceStack.spacing = 16
        priceStack.alignment = .center
        checkoutView.addSubview(priceStack)

        priceStack.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
        }

        let priceTitleLabel = UILabel()
        priceTitleLabel.text = "Стоимость заказа:"
        priceTitleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        priceTitleLabel.textColor = UIColor(named: "Primary")

        totalPriceLabel.font = .systemFont(ofSize: 16, weight: .medium)
        totalPriceLabel.textColor = UIColor(named: "Primary")

        priceStack.addArrangedSubview(priceTitleLabel)
        priceStack.addArrangedSubview(totalPriceLabel)

        confirmButton.setTitle("Оформить заказ", for: .normal)
        confirmButton.addTarget(self, action: #selector(checkoutButtonTapped), for: .touchUpInside)

        checkoutView.addSubview(confirmButton)

        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(priceStack.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }

    @objc private func checkoutButtonTapped() {
        let orders = viewModel.getOrders()
        if orders.isEmpty {
            let alert = UIAlertController(title: "Корзина пуста", message: "Добавьте пиццу в корзину, прежде чем оформить заказ.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ОК", style: .default))
            present(alert, animated: true)
        } else {
            viewModel.confirmOrder()
        }
    }


    private func updateTotalPrice() {
        let orders = viewModel.getOrders()
        let totalPrice = orders.reduce(0) { $0 + $1.totalPrice * $1.quantity}
        totalPriceLabel.text = "\(totalPrice) ₽"
    }

}
