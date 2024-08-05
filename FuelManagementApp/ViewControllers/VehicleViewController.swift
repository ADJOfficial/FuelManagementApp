//
//  FuelViewController.swift
//  FuelManagementApp
//
//  Created by Arsalan Daud on 01/08/2024.
//

import UIKit

class VehicleViewController: UIViewController {
    
    private let backgroundView = ImageView()
    private let screenTitle = Label(text: "Fuel Management")
    private let backButton = BackButton()
    private let tableView = TableView()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        addTargets()
    }
    
    private func setUpViews() {
        view.addSubview(backgroundView)
        view.addSubview(screenTitle)
        view.addSubview(backButton)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            screenTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            screenTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            backButton.topAnchor.constraint(equalTo: screenTitle.bottomAnchor, constant: 25),
            backButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            
            tableView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 20),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25)
        ])
    }
    private func addTargets() {
        backButton.addTarget(self, action: #selector(didBackButtonTapped), for: .touchUpInside)
    }
    
//    // Core Data Crud Operation
//    private func getAllItems() {
//        do {
//            let items = try DataBaseHandler.context.fetch(User.fetchRequest())
//        } catch {
//            print("Error While Fetching Data")
//        }
//    }
//    private func createItem(name: String) {
//        let newItem = User(context: DataBaseHandler.context)
//        newItem.username = name
////        newItem.createdAt = Date
//        do {
//            try DataBaseHandler.context.save()
//        } catch {
//            print("Error While Saving Data")
//        }
//    }
//    private func deleteItem(item: User) {
//        DataBaseHandler.context.delete(item)
//        do {
//            try DataBaseHandler.context.save()
//        } catch {
//            print("Error While Deleting Object")
//        }
//    }
//    private func updateItem(item: User, newName: String) {
//        item.username = newName
//        do {
//           try DataBaseHandler.context.save()
//        } catch {
//            print("Error While Updating Data")
//        }
//    }
    @objc func didBackButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

//extension FuelViewController: UITableViewDataSource, UITableViewDelegate {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }
//    
//}
