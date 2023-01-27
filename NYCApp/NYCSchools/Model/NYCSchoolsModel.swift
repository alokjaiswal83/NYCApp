import Foundation

typealias NYCSchools = [NYCSchoolModel]
// MARK: - NYC School
struct NYCSchoolModel: Codable {
    let dbn, schoolName, boro, buildingCode: String
    let sharedSpace, phoneNumber: String
    let primaryAddressLine1: String
    let city, stateCode, zip: String
    let website: String
    let totalStudents, overviewParagraph: String

    enum CodingKeys: String, CodingKey {
        case dbn
        case schoolName = "school_name"
        case boro
        case buildingCode = "building_code"
        case sharedSpace = "shared_space"
        case phoneNumber = "phone_number"
        case primaryAddressLine1 = "primary_address_line_1"
        case city
        case stateCode = "state_code"
        case zip, website
        case totalStudents = "total_students"
        case overviewParagraph = "overview_paragraph"
    }
}
