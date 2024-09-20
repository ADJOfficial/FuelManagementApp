//
//  FuelViewController.swift
//  FuelManagementApp
//
//  Created by Arsalan Daud on 01/08/2024.
//

import UIKit

class VehicleViewController: BaseViewController {
    private let tableView = TableView()
    
    private let cellIdentifier = "cell"
    private var isSelected = false
    private var vehicleList: [Vehicle] = []
    private let vehicleViewModel = VehicleViewModel()
    
    init() {
        super.init(screenTitle: "Manage Vehicle", actionTitle: "Add New Vehicle")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchVehicles()
    }
    override func setupViews() {
        super.setupViews()
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 20.autoSized),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10.widthRatio),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10.widthRatio),
            tableView.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -15.autoSized),
        ])
    }
    override func addTargets() {
        super.addTargets()
        actionButton.addTarget(self, action: #selector(didAddVehicleButtonTapped), for: .touchUpInside)
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CustomTableCellView.self, forCellReuseIdentifier: cellIdentifier)
        tableView.showsVerticalScrollIndicator = false
    }
    private func fetchVehicles() {
        vehicleViewModel.fetchVehicles(emptyRecords: {
            self.popupAlert(title: "Empty Records", message: "You have not vehicle yet Try to purchase Now!", actionTitles: ["logout","Purchase Now"], actionStyles: [.cancel,.default], actions: [{ _ in self.navigationController?.popViewController(animated: true)
            }, { _ in self.navigationController?.pushViewController(VehicleAddViewController(), animated: true)}])
        }, completion: { vehicles in
            DispatchQueue.main.async {
                self.vehicleList = vehicles
                self.tableView.reloadData()
            }
        })
    }
    
    @objc func didAddVehicleButtonTapped() {
        navigationController?.pushViewController(VehicleAddViewController(), animated: true)
    }
}
extension VehicleViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vehicleList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CustomTableCellView
        let task = vehicleList[indexPath.row]
        vehicleViewModel.cellForRowAt(task: task, cell: cell, tableView: tableView as! TableView, push: { controller in
            self.navigationController?.pushViewController(controller, animated: true)
        })
        return cell
    }
}
