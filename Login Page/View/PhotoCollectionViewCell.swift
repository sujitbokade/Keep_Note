//
//  PhotoCollectionViewCell.swift
//  Login Page
//
//  Created by Macbook on 27/12/22.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "photoCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var namelbl:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .left
        return label
    }()
    
    
    lazy var agelbl:UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.textAlignment = .left
        label.numberOfLines = 0
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(namelbl)
        contentView.addSubview(agelbl)
        
        namelbl.translatesAutoresizingMaskIntoConstraints = false
        namelbl.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        namelbl.topAnchor.constraint(equalTo: topAnchor,constant: 20).isActive = true
        namelbl.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        
        agelbl.translatesAutoresizingMaskIntoConstraints = false
        agelbl.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        agelbl.topAnchor.constraint(equalTo: namelbl.topAnchor, constant: 20).isActive = true
        agelbl.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        namelbl.frame = contentView.bounds
        agelbl.frame = contentView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
