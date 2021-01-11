//
//  MainCell.swift
//  Prueba-Search-API
//
//  Created by Javier Cueto on 11/01/21.
//  Copyright © 2021 Osvaldo. All rights reserved.
//

import UIKit
import SDWebImage

class ProductCell: UICollectionViewCell {
    var viewModel: ProductCellViewModel? {
        didSet{
            configureCell()
        }
    }
    
    private let productImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.image = #imageLiteral(resourceName: "download")
        return iv
    }()
    
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "Nombre y descripcio"
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let priceLabel : UILabel = {
        let label = UILabel()
        label.text = "$ 56.00"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        layer.cornerRadius = 10
        layer.shadowColor = UIColor.systemGray2.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1.0)
        layer.shadowRadius = 2.0
        layer.shadowOpacity = 0.5
        
        
        
        addSubview(priceLabel)
        priceLabel.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingLeft: 10, paddingBottom: 10, paddingRight: 10)

        
        
        let stack = UIStackView(arrangedSubviews: [titleLabel])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .top
        
        addSubview(stack)

        stack.anchor(left: leftAnchor, bottom: priceLabel.topAnchor ,right: rightAnchor ,paddingLeft: 10, paddingBottom: 10, paddingRight: 10, height: 34)
        

        addSubview(productImageView)
   
        productImageView.anchor(top: topAnchor,left: leftAnchor, bottom: titleLabel.topAnchor ,right: rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 10 )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCell(){
        guard let viewModel = viewModel else {return}
        titleLabel.text = viewModel.title
        priceLabel.text = viewModel.price
        productImageView.sd_setImage(with: viewModel.image)
    }
    
}
