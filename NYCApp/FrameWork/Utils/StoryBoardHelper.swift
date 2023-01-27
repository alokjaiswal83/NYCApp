import Foundation
import UIKit

/// Protocol for view controller to conform.
public protocol StoryboardIdentifiable: AnyObject {
    static var controllerName: String { get }
}

/// Enum for all storyboards in the app whose view controllers needs to be accessed from different storyboards or initialised from code.
public enum Storyboard: String {
    case main

    /// returns storyboard name.
    public var name: String {
        switch self {
        case .main:
            return "Main"
        }
    }
}

// MARK: - UIViewController extension to initialize view controller
extension StoryboardIdentifiable where Self: UIViewController {
    public static var controllerName: String {
        return String(describing: self)
    }
    
    public static func load(from: Storyboard) -> Self {
        let storyboard = UIStoryboard(name: from.name, bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: controllerName) as? Self else {
            fatalError("view controller initialization failed. Please check for storyboard name and indetifiers.")
        }
        return viewController
    }
}

extension UIViewController: StoryboardIdentifiable { }
