
import Foundation

struct MovieSimilarResults : Codable {
    
	let id : Int?
	let video : Bool?
	let vote_count : Int?
	let vote_average : Double?
	let title : String?
	let release_date : String?
	let original_language : String?
	let original_title : String?
	let genre_ids : [Int]?
	let backdrop_path : String?
	let adult : Bool?
	let overview : String?
	let poster_path : String?
	let popularity : Double?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case video = "video"
		case vote_count = "vote_count"
		case vote_average = "vote_average"
		case title = "title"
		case release_date = "release_date"
		case original_language = "original_language"
		case original_title = "original_title"
		case genre_ids = "genre_ids"
		case backdrop_path = "backdrop_path"
		case adult = "adult"
		case overview = "overview"
		case poster_path = "poster_path"
		case popularity = "popularity"
	}

	init(from decoder: Decoder) throws {
        
		let values = try decoder.container(keyedBy: CodingKeys.self)
        
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		video = try values.decodeIfPresent(Bool.self, forKey: .video)
		vote_count = try values.decodeIfPresent(Int.self, forKey: .vote_count)
		vote_average = try values.decodeIfPresent(Double.self, forKey: .vote_average)
		title = try values.decodeIfPresent(String.self, forKey: .title)
		release_date = try values.decodeIfPresent(String.self, forKey: .release_date)
		original_language = try values.decodeIfPresent(String.self, forKey: .original_language)
		original_title = try values.decodeIfPresent(String.self, forKey: .original_title)
		genre_ids = try values.decodeIfPresent([Int].self, forKey: .genre_ids)
		backdrop_path = try values.decodeIfPresent(String.self, forKey: .backdrop_path)
		adult = try values.decodeIfPresent(Bool.self, forKey: .adult)
		overview = try values.decodeIfPresent(String.self, forKey: .overview)
		poster_path = try values.decodeIfPresent(String.self, forKey: .poster_path)
		popularity = try values.decodeIfPresent(Double.self, forKey: .popularity)
	}

}
