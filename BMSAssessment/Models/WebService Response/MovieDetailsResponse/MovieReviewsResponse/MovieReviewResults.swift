
import Foundation

struct MovieReviewResults : Codable {
    
	let author : String?
	let content : String?
	let id : String?
	let url : String?

	enum CodingKeys: String, CodingKey {

		case author = "author"
		case content = "content"
		case id = "id"
		case url = "url"
	}

	init(from decoder: Decoder) throws {
        
		let values = try decoder.container(keyedBy: CodingKeys.self)
        
		author = try values.decodeIfPresent(String.self, forKey: .author)
		content = try values.decodeIfPresent(String.self, forKey: .content)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		url = try values.decodeIfPresent(String.self, forKey: .url)
	}

}
