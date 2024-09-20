//
//  CustomTableCellView.swift
//  FuelManagementApp
//
//  Created by Arsalan Daud on 05/08/2024.
//

import UIKit

class CustomTableCellView: UITableViewCell {
    let cellView = GradientView()
    let vehicleTitle = Label(textColor: .black)
    let vehicleImage = ImagePickerView()
    let vehicleCostLkm = Label()
    let purchaseDate = Label()

    var didTapDeleteButton: (()->Void)?
    var didTappedDetailsButton: (()->Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        addTargets()
        selectionStyle = .none
        self.backgroundColor = .clear
        self.contentView.isUserInteractionEnabled = false
        self.cellView.isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    private func setupViews() {
        addSubview(cellView)
        cellView.addSubview(vehicleTitle)
        cellView.addSubview(vehicleImage)

        
        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: self.topAnchor),
            cellView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -25.autoSized),
            cellView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            cellView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            vehicleImage.heightAnchor.constraint(equalToConstant: 150.autoSized),
            vehicleImage.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 35.autoSized),
            vehicleImage.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 10.widthRatio),
            vehicleImage.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -10.widthRatio),
            
            vehicleTitle.topAnchor.constraint(equalTo: vehicleImage.bottomAnchor, constant: 10.widthRatio),
            vehicleTitle.centerXAnchor.constraint(equalTo: cellView.centerXAnchor),
            vehicleTitle.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -15.autoSized),
        ])
    }
    @objc func addTargets() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(isTapDetailsButton))
        cellView.addGestureRecognizer(tap)
    }
    @objc func isTapDetailsButton() {
        didTappedDetailsButton?()
        print("Details Button is Tapped")
    }
    @objc func isTapDeletedButton() {
        didTapDeleteButton?()
        print("Delete Button is Tapped")
    }
}
