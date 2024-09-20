//
//  DateTimePicker.swift
//  TodoListApp
//
//  Created by ADJ on 14/07/2024.
//

import UIKit

class DateTimePicker: UIDatePicker {
    init(minimumDate: Date? = Date(), maximumDate: Date? = Date(), backgroundColor: UIColor = .systemGreen.withAlphaComponent(0.5)){
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.locale = Locale(identifier: "en_US")
        self.minimumDate = minimumDate
        self.maximumDate = maximumDate
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.backgroundColor = backgroundColor
        self.tintColor = .systemGreen
        self.preferredDatePickerStyle = .compact
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
