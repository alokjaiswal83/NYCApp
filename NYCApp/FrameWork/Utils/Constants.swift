import Foundation


/// Tableview cell identifier
struct TableViewCellIdentifier {
    static let schoolsTableViewCell = "NVCSchoolTableViewCell"
}

/// Navigation bar titile
struct NavigationBarTitle {
    static let nycShoolTitle = "NVC High School"
    static let schoolsDetailTitle = "Schools details"
}

/// Image constants
enum ImageConstants: String {
    case backGroundImage = "background"
    case placeHolderImage = "placeholder"
}

///Mock Image data and url for the app. randomly selected
let schoolImage = ["school1", "school2", "school3", "school4", "school5"]
let booksImagesUrl = ["https://png.pngtree.com/element_our/20190528/ourmid/pngtree-book-icon-image_1144607.jpg",
                      "https://png.pngtree.com/png-vector/20190505/ourmid/pngtree-vector-book-icon-png-image_1022249.jpg",
                      "https://png.pngtree.com/png-vector/20190417/ourmid/pngtree-vector-book-icon-png-image_947973.jpg",
                      "https://png.pngtree.com/png-vector/20190505/ourmid/pngtree-vector-book-icon-png-image_1022249.jpg"
                      ,
                      "https://png.pngtree.com/png-vector/20190419/ourmid/pngtree-vector-book-icon-png-image_958564.jpg"
]
