import UIKit

final class NYCSchoolTableViewCell: UITableViewCell {
    /// Private outlets
    @IBOutlet private weak var schoolImageView: UIImageView!
    @IBOutlet private weak var schoolNameLabel: UILabel!
    @IBOutlet private weak var schoolDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    /// Configure cell with data
    /// - Parameter cellViewModel: SchoolCell viewmodel
    func configureCell(cellViewModel: SchoolsDataViewModel?) {
        schoolNameLabel.text = cellViewModel?.title
        schoolDescriptionLabel.text = cellViewModel?.subtitle
        //cellViewModel?.delegate = self
        self.schoolImageView.image = cellViewModel?.getImage()
    }
}

// MARK: TableViewCell Delegate method
extension NYCSchoolTableViewCell: SchoolsDataViewModelDelegate {
    func didImageDownload(data: Data?, error: String?) {
        guard let data = data, let image = UIImage(data: data) else {
            return
        }
        DispatchQueue.main.async {
            self.schoolImageView.image = image
        }
    }
}
