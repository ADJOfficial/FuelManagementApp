//
//  TableView.swift
//  FuelManagementApp
//
//  Created by Arsalan Daud on 05/08/2024.
//

import UIKit

class TableView: UITableView {
    init(backgroundColor: UIColor = .clear, seperatorStyle: UITableViewCell.SeparatorStyle = .none) {
        super.init(frame: .zero, style: .plain)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = backgroundColor
        self.separatorStyle = seperatorStyle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


