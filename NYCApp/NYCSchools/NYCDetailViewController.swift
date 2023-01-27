//
//  NYCDetailViewController.swift
//  NYCApp
//
//  Created by Alok Jaiswal on 04/01/23.
//

import UIKit

final class NYCSchoolDetailViewController: UIViewController, SchoolImageDataDelegate {
    
    /// Private outlets
    @IBOutlet private weak var backGroundImageView: UIImageView!
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var schoolNameLabel: UILabel!
    @IBOutlet private weak var numberOfTestLabel: UILabel!
    @IBOutlet private weak var readingAvgLabel: UILabel!
    @IBOutlet private weak var writingAvgLabel: UILabel!
    @IBOutlet private weak var mathAvgLabel: UILabel!
    
    var viewModel: NYCSchoolsDetailViewModel?
    
    // MARK:  ViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addObservers()
        viewModel?.getSchoolDetails()
        viewModel?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = NavigationBarTitle.schoolsDetailTitle
        profileImageView.setRoundCornerImage()
        self.backGroundImageView.image = UIImage(named: ImageConstants.backGroundImage.rawValue)
    }
    
    // MARK: bind method & UI update
    /// Method for add observer to response and error
    private func addObservers() {
        viewModel?.selectedSchoolModel.bind { _ in
            DispatchQueue.main.async() {
                self.updateView()
            }
        }
        
        viewModel?.error.bind { error in
            if let error = error {
                DispatchQueue.main.async() {
                    self.showAlert(error)
                }
            }
        }
    }
    
    private func updateView() {
        numberOfTestLabel.text = viewModel?.selectedSchoolModel.value.first?.numOfSatTestTakers
        schoolNameLabel.text = viewModel?.selectedSchoolModel.value.first?.schoolName
        readingAvgLabel.text = viewModel?.selectedSchoolModel.value.first?.satCriticalReadingAvgScore
        writingAvgLabel.text = viewModel?.selectedSchoolModel.value.first?.satWritingAvgScore
        mathAvgLabel.text = viewModel?.selectedSchoolModel.value.first?.satMathAvgScore
    }
    
    func didImageDownload(data: Data?, error: String?) {
        guard let data = data, let image = UIImage(data: data) else {
            return
        }
        DispatchQueue.main.async {
            self.profileImageView.image = image
        }
    }
}
