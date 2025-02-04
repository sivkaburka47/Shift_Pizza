//
//  SupplementCell.swift
//  Shift_Pizza
//
//  Created by Станислав Дейнекин on 29.01.2025.
//

import UIKit
import SnapKit
import Kingfisher

class SupplementCell: UICollectionViewCell {
    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    private let priceLabel = UILabel()
    private var isSupplementSelected = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.shadowColor = UIColor(red: 26/255, green: 26/255, blue: 30/255, alpha: 1).cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 12
        layer.shadowOpacity = 0.15
        layer.masksToBounds = false
        
        contentView.layer.cornerRadius = 16
        contentView.clipsToBounds = true
        contentView.backgroundColor = .white
        
        
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)
        
        imageView.contentMode = .scaleAspectFit
        
        nameLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        nameLabel.textColor = UIColor(named: "Primary")
        nameLabel.textAlignment = .center
        
        priceLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        priceLabel.textColor = UIColor(named: "Primary")
        priceLabel.textAlignment = .center
        
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(88)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(8)
            make.height.lessThanOrEqualTo(34)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(nameLabel.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().offset(-8)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowPath = UIBezierPath(
            roundedRect: bounds,
            cornerRadius: contentView.layer.cornerRadius
        ).cgPath
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with supplement: PizzaIngredientEntity) {
        nameLabel.text = supplement.nameInRus
        priceLabel.text = "\(supplement.cost) ₽"
        
        if let url = URL(string: BaseURL.shift.baseURL + supplement.img) {
            imageView.kf.setImage(with: url)
        }
    }
    
    func setSelected(_ selected: Bool, animated: Bool = true) {
        let borderColor = selected ? UIColor(named: "Brand")?.cgColor : UIColor.clear.cgColor
        contentView.layer.borderColor = borderColor
        contentView.layer.borderWidth = selected ? 1.0 : 0.0
        
        if animated {
            UIView.animate(withDuration: 0.2) {
                self.layoutIfNeeded()
            }
        }
    }
    
    func toggleSelection() {
        let isSelected = contentView.layer.borderWidth > 0
        setSelected(!isSelected)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contentView.layer.borderWidth = 0
    }
}


