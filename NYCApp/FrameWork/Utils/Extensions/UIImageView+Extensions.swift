import Foundation
import UIKit

extension UIImageView {
    /// Use this function to set round corner image
    func setRoundCornerImage() {
        self.layer.cornerRadius = self.frame.size.height/2
        self.clipsToBounds = true
        self.layer.borderWidth = 2.0
        self.layer.borderColor = UIColor.white.cgColor
    }
}
