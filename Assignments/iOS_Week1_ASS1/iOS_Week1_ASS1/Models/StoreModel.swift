import Foundation

struct StoreModel: Codable {
    let type: String
    let name: String
    let features: [Feature]
}

struct Feature : Codable {
    let type : String
    let properties : StoreProperties
    let geometry : Geometry
}

struct StoreProperties : Codable {
    let Seq : String
    let Sotre_nm: String
    let Address: String
    let Telephone : String
    let Category: String
    let Ycoordinate: Double
    let Xcoordinate: Double
}

struct Geometry : Codable{
    let type : String
    let coordinates : [Double]
}
