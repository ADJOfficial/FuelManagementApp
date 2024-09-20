//
//  BaseViewController.swift
//  FuelManagementApp
//
//  Created by Arsalan Daud on 03/09/2024.
//

import UIKit
import CoreData

class BaseViewController: UIViewController {
    private let backgroundImageView = BackgroundImageView()
    let backButton = BackButton()
    let actionButton = Button(setTitle: "")
    let screenTitleText = Label()
    
    private var screenTitle: String
    private var actionTitle: String
    private var isBackButtonVisible: Bool
    private var isActionButtonVisible: Bool
    private var actionButtonBottomConstraints: NSLayoutConstraint?
    
    init(screenTitle: String = "", actionTitle: String = "", isBackButtonVisible: Bool = true, isActionButtonVisible: Bool = true) {
        self.screenTitle = screenTitle
        self.actionTitle = actionTitle
        self.isActionButtonVisible = isActionButtonVisible
        self.isBackButtonVisible = isBackButtonVisible
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        addTargets()
        addObserver()
        setupTitle()
        configureActionButtonVisibility()
    }
    func setupViews() {
        view.addSubview(backgroundImageView)
        view.addSubview(screenTitleText)
        view.addSubview(backButton)
        view.addSubview(actionButton)
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            screenTitleText.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            screenTitleText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10.widthRatio),
            
            actionButton.heightAnchor.constraint(equalToConstant: 50),
            actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25.widthRatio),
            actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25.widthRatio),
        ])
        actionButtonBottomConstraints = actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5.autoSized)
        actionButtonBottomConstraints?.isActive = true
    }
    func addTargets() {
        backButton.addTarget(self, action: #selector(didBackButtonTapped), for: .touchUpInside)
    }
    
    private func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShowNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHideNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    private func setupTitle() {
        screenTitleText.text = screenTitle
        actionButton.setTitle(actionTitle, for: .normal)
    }
    private func configureActionButtonVisibility() {
        backButton.isHidden = !isBackButtonVisible
        actionButton.isHidden = !isActionButtonVisible
    }
    
    @objc func didBackButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    @objc func keyboardShowNotification(keyboardShowNotification notification: Notification) {
        if let userInfo = notification.userInfo, let keyboardRectangle = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            actionButtonBottomConstraints?.isActive = false
            actionButtonBottomConstraints?.constant = -keyboardRectangle.height
            actionButtonBottomConstraints?.isActive = true
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    @objc func keyboardHideNotification(keyboardHideNotification notification: Notification) {
        actionButtonBottomConstraints?.isActive = false
        actionButtonBottomConstraints?.constant = -5
        actionButtonBottomConstraints?.isActive = true
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
    }
}
