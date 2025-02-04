//
//  SuccesViewController.swift
//  Shift_Pizza
//
//  Created by Станислав Дейнекин on 01.02.2025.
//

import UIKit
import SnapKit

class SuccesViewController: UIViewController {
    
    private let viewModel: SuccesViewModel
    
    private let scrollView = UIScrollView()
    private let contentStackView = UIStackView()
    private let successImageView = UIImageView()
    private let titleLabel = UILabel()
    private let infoLabel = UILabel()
    private let addressView = OrderDetailView()
    private let totalPriceView = OrderDetailView()
    private let mainButton = LargeCustomButton(style: .orange)
    private let detailButton = LargeCustomButton(style: .white)
    
    init(viewModel: SuccesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureContent()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        

        
        scrollView.showsVerticalScrollIndicator = false
        
        contentStackView.axis = .vertical
        contentStackView.spacing = 16
        contentStackView.alignment = .fill
        
        successImageView.image = UIImage(named: "Succes")
        successImageView.contentMode = .scaleAspectFit
        successImageView.snp.makeConstraints { $0.size.equalTo(80) }
        
        titleLabel.text = "Оплата прошла успешно!"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textColor = UIColor(named: "Primary")
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        
        addressView.configure(title: "Адрес доставки", value: "ул. \(viewModel.address.street), д. \(viewModel.address.house), кв. \(viewModel.address.apartment) ")
        totalPriceView.configure(title: "Сумма заказа", value: "\(viewModel.totalPrice) ₽")
        
        infoLabel.text = "Вся информация была продублирована в SMS"
        infoLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        infoLabel.textColor = UIColor(named: "Quartenery")
        infoLabel.textAlignment = .center
        infoLabel.numberOfLines = 0
        
        mainButton.setTitle("На главную", for: .normal)
        mainButton.addTarget(self, action: #selector(mainButtonTapped), for: .touchUpInside)
        detailButton.setTitle("Детали заказа", for: .normal)
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentStackView)
        
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
            $0.width.equalToSuperview().offset(-32)
        }
        
    }
    
    private func configureContent() {
        let ordersDetailView = OrderDetailView()
        
        let mainText = NSMutableAttributedString()
        
        viewModel.orders.forEach { order in
            for _ in 0..<order.quantity {
                let titleAttr = NSAttributedString(
                    string: order.name,
                    attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .regular),
                                 .foregroundColor: UIColor(named: "Primary") ?? .black]
                )

                let detailsAttr = NSAttributedString(
                    string: ", \(order.size.sizeInCmFull), \(order.doughs.doughsInStr)",
                    attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .regular),
                                 .foregroundColor: UIColor(named: "Primary") ?? .black]
                )

                var toppingsAttr = NSAttributedString()
                if !order.toppings.isEmpty {
                    toppingsAttr = NSAttributedString(
                        string: " + \(order.toppings.map { $0.nameInRus }.joined(separator: ", "))",
                        attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .regular),
                                     .foregroundColor: UIColor(named: "Primary") ?? .black]
                    )
                }

                mainText.append(titleAttr)
                mainText.append(detailsAttr)
                mainText.append(toppingsAttr)
                mainText.append(NSAttributedString(string: "\n"))
            }
        }
        
        ordersDetailView.configure(title: "Заказы", value: mainText.string)
        contentStackView.addArrangedSubview(successImageView)
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(ordersDetailView)

        contentStackView.addArrangedSubview(addressView)
        contentStackView.addArrangedSubview(totalPriceView)
        contentStackView.addArrangedSubview(infoLabel)
        contentStackView.addArrangedSubview(detailButton)
        contentStackView.addArrangedSubview(mainButton)
        
        detailButton.snp.makeConstraints {
            $0.height.equalTo(48)
        }
        
        mainButton.snp.makeConstraints {
            $0.height.equalTo(48)
        }

    }


    
    @objc private func mainButtonTapped() {
        viewModel.appRouterDelegate?.navigateToMain()
    }
}



class OrderDetailView: UIView {
    private let titleLabel = UILabel()
    private let valueLabel = UILabel()
    
    init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        let stack = UIStackView()
        stack.axis = .vertical
        
        titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        titleLabel.textColor = UIColor(named: "Tertiary")
        valueLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        valueLabel.textColor = UIColor(named: "Primary")
        valueLabel.numberOfLines = 0
        
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(valueLabel)
        
        addSubview(stack)
        stack.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configure(title: String, value: String) {
        titleLabel.text = title
        valueLabel.text = value
    }
}
