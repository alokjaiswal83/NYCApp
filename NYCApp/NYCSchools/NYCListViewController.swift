//
//  ViewController.swift
//  NYCApp
//
//  Created by Alok Jaiswal on 03/01/23.
//

import UIKit

class NYCSchoolsViewController: UIViewController {
    
    @IBOutlet private weak var schoolsTableView: UITableView!
    private let viewModel = NYCSchoolsViewModel()

    // MARK:  ViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getSchools()
        addObservers()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = NavigationBarTitle.nycShoolTitle
    }
    
    // MARK:  bind method and UI update
    /// Method for add observer to response and error
    private func addObservers() {
        viewModel.schoolCellViewModels.bind { _ in
            DispatchQueue.main.async() {
                self.schoolsTableView.reloadData()
            }
        }
        viewModel.error.bind { error in
            if let error = error {
                DispatchQueue.main.async() {
                    self.showAlert(error)
                }
            }
        }
    }
}

// MARK: UITableView datasorce methods
extension NYCSchoolsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.schoolCellViewModels.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:
                                                        TableViewCellIdentifier.schoolsTableViewCell) as?
                NYCSchoolTableViewCell else {
            return UITableViewCell()
        }
        cell.configureCell(cellViewModel: viewModel.getCellViewModel(at: indexPath))
        return cell
    }
}

// MARK: UITableView Delegate methods
extension NYCSchoolsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dbn = viewModel.schoolCellViewModels.value[indexPath.row].dbn
        let schoolDetailViewController = NYCSchoolDetailViewController.load(from: .main)
        schoolDetailViewController.viewModel = NYCSchoolsDetailViewModel(dbn: dbn)
        self.navigationController?.pushViewController(schoolDetailViewController, animated: true)
    }
}


