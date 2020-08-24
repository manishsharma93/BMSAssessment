//
//  MovieDetailsViewController.swift
//  BMSAssessment
//
//  Created by Manish Kumar on 23/08/20.
//  Copyright © 2020 Manish Kumar. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    @IBOutlet weak var movieDetailsTableView: UITableView!
    @IBOutlet weak var movieVoteCountLabel: UILabel!
    @IBOutlet weak var movieInterestedButton: UIButton!
    
    var movieDetailsDataArray : [MovieDetailsSection]? = []
    var movieDetails: MovieResults?
    
    let reachability = Reachability()!
    let jsonDecoder = JSONDecoder()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        movieDetailsTableView.rowHeight = UITableView.automaticDimension
        movieDetailsTableView.estimatedRowHeight = 180
        movieDetailsTableView.tableFooterView = UIView()
        
        movieVoteCountLabel?.text = "\(movieDetails?.vote_count ?? 0)"
        
        movieInterestedButton.layer.cornerRadius = 4.0
        movieInterestedButton.layer.masksToBounds = true
        movieInterestedButton.layer.borderColor = UIColor.systemBlue.cgColor
        movieInterestedButton.layer.borderWidth = 1.0
        
        registerCells()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = movieDetails?.title ?? ""
    }
    
    func registerCells() {
        movieDetailsTableView.register(UINib(nibName: "MoviePosterTableViewCell", bundle: nil), forCellReuseIdentifier: "MoviePosterTableViewCell")
        movieDetailsTableView.register(UINib(nibName: "MovieSynopsisTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieSynopsisTableViewCell")
        movieDetailsTableView.register(UINib(nibName: "MovieReviewsTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieReviewsTableViewCell")
        movieDetailsTableView.register(UINib(nibName: "MovieCreditsTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieCreditsTableViewCell")
        movieDetailsTableView.register(UINib(nibName: "SimilarMoviesTableViewCell", bundle: nil), forCellReuseIdentifier: "SimilarMoviesTableViewCell")

    }
    
    func fetchData() {
        
        movieDetailsDataArray?.append(MovieDetailsSection(type: .poster, data:movieDetails))

        fetchSynopsis()
    }
    
    func fetchSynopsis() {
        
        if reachability.currentReachabilityStatus == .notReachable {
            return
        }
        
        let params = [
            "api_key" : Appkeys.APP_API_KEY,
            "language" : Appkeys.APP_SERVICE_LANGUAGE,
            ] as [String : Any]
        
        let methodName = "\(movieDetails?.id ?? 0)"
        
        Webservices().callGetService(methodName: methodName, params: params, successBlock: { (data) in
            do {
                let synopsisResponse = try self.jsonDecoder.decode(MovieSynopsisResponse.self, from: data)

                self.movieDetailsDataArray?.append(MovieDetailsSection(type: .synopsis, data: synopsisResponse))
                
                self.fetchReviews()

                DispatchQueue.main.async {
                    self.movieDetailsTableView.reloadData()
                }
            } catch {
                
            }
        }) { (error) in
            self.fetchReviews()
        }
        
    }
    
    func fetchReviews() {
        
        if reachability.currentReachabilityStatus == .notReachable {
            return
        }
        
        let params = [
            "api_key" : Appkeys.APP_API_KEY,
            "language" : Appkeys.APP_SERVICE_LANGUAGE,
            ] as [String : Any]
        
        let methodName = "\(movieDetails?.id ?? 0)/\(WebServiceMethods.WS_REVIEWS)"
        
        Webservices().callGetService(methodName: methodName, params: params, successBlock: { (data) in
            do {
                let reviewsResponse = try self.jsonDecoder.decode(MovieReviewsResponse.self, from: data)

                if reviewsResponse.results?.count ?? 0 > 0 {
                    self.movieDetailsDataArray?.append(MovieDetailsSection(type: .reviews, data: reviewsResponse))
                }
                
                self.fetchCredits()
                
                DispatchQueue.main.async {
                    self.movieDetailsTableView.reloadData()
                }
            } catch {
                
            }
        }) { (error) in
            self.fetchCredits()
        }
    }
    
    func fetchCredits() {
        
        if reachability.currentReachabilityStatus == .notReachable {
            return
        }
        
        let params = [
            "api_key" : Appkeys.APP_API_KEY,
            "language" : Appkeys.APP_SERVICE_LANGUAGE,
            ] as [String : Any]
        
        let methodName = "\(movieDetails?.id ?? 0)/\(WebServiceMethods.WS_CREDITS)"
        
        Webservices().callGetService(methodName: methodName, params: params, successBlock: { (data) in
            do {
                let creditsResponse = try self.jsonDecoder.decode(MovieCreditResponse.self, from: data)

                if creditsResponse.cast?.count ?? 0 > 0 {
                    self.movieDetailsDataArray?.append(MovieDetailsSection(type: .credits, data: creditsResponse))
                }
                
                self.fetchSimilarData()
                
                DispatchQueue.main.async {
                    self.movieDetailsTableView.reloadData()
                }
            } catch {
                
            }
        }) { (error) in
            self.fetchSimilarData()
        }
    }
    
    func fetchSimilarData() {
        
        if reachability.currentReachabilityStatus == .notReachable {
            return
        }
        
        let params = [
            "api_key" : Appkeys.APP_API_KEY,
            "language" : Appkeys.APP_SERVICE_LANGUAGE,
            ] as [String : Any]
        
        let methodName = "\(movieDetails?.id ?? 0)/\(WebServiceMethods.WS_SIMILAR)"

        Webservices().callGetService(methodName: methodName, params: params, successBlock: { (data) in
            do {
                let similarDataResponse = try self.jsonDecoder.decode(MovieSimilarResponse.self, from: data)

                if similarDataResponse.results?.count ?? 0 > 0 {
                    self.movieDetailsDataArray?.append(MovieDetailsSection(type: .similar, data: similarDataResponse))
                }
                
                DispatchQueue.main.async {
                    self.movieDetailsTableView.reloadData()
                }
            } catch {
                
            }
        }) { (error) in
            
        }
    }

    @IBAction func movieInterestedButtonPressed(_ sender: Any) {
        
    }
}

extension MovieDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieDetailsDataArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cellType = movieDetailsDataArray?[indexPath.row].type  {
            
            switch cellType {
            case .poster :
                let cell = tableView.dequeueReusableCell(withIdentifier: "MoviePosterTableViewCell", for: indexPath) as! MoviePosterTableViewCell
                cell.selectionStyle = .none
                
                cell.moviePosterImageView.loadImage(movieDetails?.backdrop_path ?? "", type: .original)
                
                return cell
                
            case .synopsis:
                let cell = tableView.dequeueReusableCell(withIdentifier: "MovieSynopsisTableViewCell", for: indexPath) as! MovieSynopsisTableViewCell
                cell.selectionStyle = .none
                
                let synopsisData = movieDetailsDataArray?[indexPath.row].data as? MovieSynopsisResponse
                
                cell.movieNameLabel.text = synopsisData?.title ?? ""
                cell.movieReleaseDateLabel.text = synopsisData?.release_date ?? ""
                
                let genreString = synopsisData?.genres?.reduce("", { (result: String, genre: Genres) -> String in
                    if result == "" {
                        return (genre.name ?? "")
                    } else {
                        return result + ", " + (genre.name ?? "")
                    }
                })
                
                cell.movieGenreLabel.text = genreString ?? ""
                
                let languagesString = synopsisData?.spoken_languages?.reduce("", { (result: String, language: Spoken_languages) -> String in
                    if result == "" {
                        return (language.name ?? "")
                    } else {
                        return result + ", " + (language.name ?? "")
                    }
                })
                
                cell.movieLanguageLabel.text = languagesString ?? ""
                cell.movieDescriptionLabel.text = synopsisData?.overview ?? ""

                return cell
            
            case .reviews:
                let cell = tableView.dequeueReusableCell(withIdentifier: "MovieReviewsTableViewCell", for: indexPath) as! MovieReviewsTableViewCell
                cell.selectionStyle = .none
                
                cell.data = movieDetailsDataArray?[indexPath.row].data as? MovieReviewsResponse

                return cell
                
            case .credits:
                let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCreditsTableViewCell", for: indexPath) as! MovieCreditsTableViewCell
                cell.selectionStyle = .none

                cell.data = movieDetailsDataArray?[indexPath.row].data as? MovieCreditResponse

                return cell
                
            case .similar:
                let cell = tableView.dequeueReusableCell(withIdentifier: "SimilarMoviesTableViewCell", for: indexPath) as! SimilarMoviesTableViewCell
                cell.selectionStyle = .none
                
                cell.data = movieDetailsDataArray?[indexPath.row].data as? MovieSimilarResponse

                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell")
            cell!.backgroundColor = .lightGray
            
            return cell!
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

