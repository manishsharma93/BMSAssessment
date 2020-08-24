
import Foundation

struct MovieSimilarResponse : Codable {
    
	let page : Int?
	let results : [MovieSimilarResults]?
	let total_pages : Int?
	let total_results : Int?

	enum CodingKeys: String, CodingKey {

		case page = "page"
		case results = "results"
		case total_pages = "total_pages"
		case total_results = "total_results"
	}

	init(from decoder: Decoder) throws {
        
		let values = try decoder.container(keyedBy: CodingKeys.self)
        
		page = try values.decodeIfPresent(Int.self, forKey: .page)
		results = try values.decodeIfPresent([MovieSimilarResults].self, forKey: .results)
		total_pages = try values.decodeIfPresent(Int.self, forKey: .total_pages)
		total_results = try values.decodeIfPresent(Int.self, forKey: .total_results)
	}

}
