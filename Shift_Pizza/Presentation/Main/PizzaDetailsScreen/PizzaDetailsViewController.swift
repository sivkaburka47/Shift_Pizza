//
//  PizzaDetailsViewController.swift
//  Shift_Pizza
//
//  Created by Станислав Дейнекин on 29.01.2025.
//

import UIKit
import SnapKit
import Kingfisher

class PizzaDetailsViewController: UIViewController {
    
    private let viewModel: PizzaDetailsViewModel
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let compositionLabel = UILabel()
    private let sizeButton = SplitButton(style: .sizePicker)
    private let doughButton = SplitButtonDuo(style: .doughPicker)
    private let supplementsLabel = UILabel()
    private let supplementsCollectionView: UICollectionView
    private let confirmButton = LargeCustomButton(style: .orange)
    
    private var supplements: [PizzaIngredientEntity] = []

    init(viewModel: PizzaDetailsViewModel) {
        self.viewModel = viewModel
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.sectionInset = .zero
        
        let itemWidth = (UIScreen.main.bounds.width - 32 - 16) / 3
        layout.itemSize = CGSize(width: itemWidth, height: 172)
        
        self.supplementsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        configureWithData()
        loadSupplements()
        
        supplementsCollectionView.allowsMultipleSelection = true
    }
    
    private func setupUI() {
        view.backgroundColor = .white

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.top)
            make.left.equalTo(scrollView.snp.left)
            make.bottom.equalTo(scrollView.snp.bottom)
            make.right.equalTo(scrollView.snp.right)
            make.width.equalTo(scrollView.snp.width)
        }
        
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(compositionLabel)
        contentView.addSubview(sizeButton)
        contentView.addSubview(doughButton)
        contentView.addSubview(supplementsLabel)
        contentView.addSubview(supplementsCollectionView)
        contentView.addSubview(confirmButton)
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        nameLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        nameLabel.textColor = UIColor(named: "Primary")
        
        descriptionLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        descriptionLabel.textColor = UIColor(named: "Secondary")
        descriptionLabel.numberOfLines = 0
        
        compositionLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        compositionLabel.textColor = UIColor(named: "Secondary")
        compositionLabel.numberOfLines = 0
        
        supplementsLabel.text = "Добавить по вкусу"
        supplementsLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        supplementsLabel.textColor = UIColor(named: "Primary")
        
        
        supplementsCollectionView.backgroundColor = .white
        supplementsCollectionView.register(SupplementCell.self, forCellWithReuseIdentifier: "SupplementCell")
        supplementsCollectionView.dataSource = self
        supplementsCollectionView.delegate = self
        
        confirmButton.setTitle("В корзину за \(viewModel.pizza.sizes.first?.price ?? 0) ₽", for: .normal)
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(24)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(220)
        }

        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(32)
            make.left.right.equalToSuperview().inset(16)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(16)
        }
        
        compositionLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(16)
        }

        sizeButton.snp.makeConstraints { make in
            make.top.equalTo(compositionLabel.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(44)
        }
        
        doughButton.snp.makeConstraints { make in
            make.top.equalTo(sizeButton.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(44)
        }
        
        supplementsLabel.snp.makeConstraints { make in
            make.top.equalTo(doughButton.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(16)
        }
        
        supplementsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(supplementsLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(180)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(supplementsCollectionView.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalTo(contentView.snp.bottom).offset(-24)
        }
        
        supplementsCollectionView.isScrollEnabled = false
        
        supplementsCollectionView.clipsToBounds = false
        supplementsCollectionView.superview?.clipsToBounds = false
        
        scrollView.clipsToBounds = false
        contentView.clipsToBounds = false
    }
    
    private func configureWithData() {
        let pizza = viewModel.pizzaOrder
        
        if let url = URL(string: BaseURL.shift.baseURL + viewModel.pizza.img) {
            imageView.kf.setImage(with: url)
        }
        
        nameLabel.text = pizza.name
        descriptionLabel.text = "\(pizza.size.sizeInCm), \(pizza.doughs.doughsInStr)"
        compositionLabel.text = viewModel.pizza.ingredients.map { $0.nameInRus }.joined(separator: ", ")
    }
    
    private func loadSupplements() {
        supplements = viewModel.pizza.toppings
        supplementsCollectionView.reloadData()
        
        let itemsPerRow = 3
        let rows = ceil(Double(supplements.count) / Double(itemsPerRow))
        let height = (172 * CGFloat(rows)) + (8 * (CGFloat(rows) - 1))
        
        supplementsCollectionView.snp.updateConstraints { make in
            make.height.equalTo(height)
        }
        
        view.layoutIfNeeded()
    }
    
    private func bindViewModel() {
        viewModel.onTextUpdate = { [weak self] text in
            DispatchQueue.main.async {
                self?.descriptionLabel.text = text
            }
        }
        
        viewModel.totalPriceUpdate = { [weak self] text in
            DispatchQueue.main.async {
                self?.confirmButton.setTitle(text, for: .normal)
            }
        }
        
        sizeButton.onSizeSelected = { [weak self] size in
            self?.viewModel.updateSize(size)
        }
        
        doughButton.onDoughSelected = { [weak self] dough in
            self?.viewModel.updateDoughType(dough)
        }
    }
}


// MARK: - UICollectionViewDataSource
extension PizzaDetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return supplements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SupplementCell", for: indexPath) as? SupplementCell else {
            return UICollectionViewCell()
        }
        let supplement = supplements[indexPath.item]
        cell.configure(with: supplement)
        
        let isSelected = viewModel.isSupplementSelected(named: supplement.nameInRus)
        cell.setSelected(isSelected, animated: false)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension PizzaDetailsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let supplement = supplements[indexPath.item]
        
        viewModel.toggleSupplementSelection(supplement)
        
        if let cell = collectionView.cellForItem(at: indexPath) as? SupplementCell {
            cell.toggleSelection()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let supplement = supplements[indexPath.item]
        
        viewModel.toggleSupplementSelection(supplement)
        
        if let cell = collectionView.cellForItem(at: indexPath) as? SupplementCell {
            cell.toggleSelection()
        }
    }

    @objc private func confirmButtonTapped() {
        viewModel.saveOrderToUserDefaults()
    }


}
