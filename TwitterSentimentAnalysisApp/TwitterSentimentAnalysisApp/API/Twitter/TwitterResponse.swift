import Foundation


struct TwitterUser: Codable {
    let data: [Datum]
    
    struct Datum: Codable {
        let id, name, username: String
    }
}


struct TwitterResponse: Codable {

    
    let data: [Datum]?
    let meta: Meta
    
    
    struct Datum: Codable {
        let createdAt, id, text: String
        
        enum CodingKeys: String, CodingKey {
            case createdAt = "created_at"
            case id = "id"
            case text = "text"
        }
    }
    
    struct Meta: Codable {
        let nextToken: String?
        let resultCount: Int
        let newestID: String?
        let oldestID: String?
        
        enum CodingKeys: String, CodingKey {
            case nextToken = "next_token"
            case resultCount = "result_count"
            case newestID = "newest_id"
            case oldestID = "oldest_id"
        }
    }
}


