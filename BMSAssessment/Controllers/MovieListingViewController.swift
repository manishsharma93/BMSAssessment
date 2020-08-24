//
//  ViewController.swift
//  BMSAssessment
//
//  Created by Manish Kumar on 22/08/20.
//  Copyright © 2020 Manish Kumar. All rights reserved.
//

import UIKit

class MovieListingViewController: UIViewController {
    
    @IBOutlet weak var movieListingTableView: UITableView!
    @IBOutlet weak var movieSearchBar: UISearchBar!
    
    let reachability = Reachability()!
    
    var movieResponse: MovieListingResponse?
    
    var originalMovieDataArray: [MovieResults]? = []
    var filteredMovieDataArray: [MovieResults]? = []

    var currentPage: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.movieSearchBar.delegate = self
        
        movieListingTableView.tableFooterView = UIView()
        
        registerCells()
        fetchMovieData(page_number: currentPage)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func registerCells() {
        movieListingTableView.register(UINib(nibName: "MovieListingTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieListingTableViewCell")
    }
    
    func fetchMovieData(page_number: Int) {
        
        if reachability.currentReachabilityStatus == .notReachable {
            return
        }
        
        let params = [
            "api_key" : Appkeys.APP_API_KEY,
            "language" : Appkeys.APP_SERVICE_LANGUAGE,
            "page" : page_number
            ] as [String : Any]
        
        Webservices().callGetService(methodName: WebServiceMethods.WS_NOW_PLAYING, params: params, successBlock: { (data) in
            do {
                let jsonDecoder = JSONDecoder()
                self.movieResponse = try jsonDecoder.decode(MovieListingResponse.self, from: data)
                print("Response received Count :\(self.movieResponse?.results?.count ?? 0)")
                
                self.originalMovieDataArray = self.originalMovieDataArray?.count == 0 ? self.movieResponse?.results : (self.originalMovieDataArray ?? []) + (self.movieResponse?.results ?? [])
                
                self.filteredMovieDataArray = self.originalMovieDataArray
                
                DispatchQueue.main.async {
                    self.movieListingTableView.reloadData()
                }
            } catch {
                
            }
        }) { (error) in
            
        }
    }
    
    func getSearchString(searchText: String) -> String {
        var searchString = searchText
        
        searchString = searchString.capitalized
        
        return searchString
    }
    
    func showInitialData() {
        filteredMovieDataArray = self.originalMovieDataArray
        DispatchQueue.main.async {
            self.movieListingTableView.reloadData()
        }
    }
}

extension MovieListingViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            showInitialData()
        } else {
            let searchString = getSearchString(searchText: searchText)

            filteredMovieDataArray = movieResponse?.results?.filter( { "\($0.title ?? "") \($0.title ?? "")".range(of: searchString, options: .literal) != nil}) ?? []
        }
                
        DispatchQueue.main.async {
            self.movieListingTableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        
        showInitialData()
    }
}

extension MovieListingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMovieDataArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 154
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieListingTableViewCell", for: indexPath) as! MovieListingTableViewCell
        
        let movieData = filteredMovieDataArray?[indexPath.row]
        
        cell.movieNameLabel.text = movieData?.title ?? ""
        cell.movieDescriptionLabel.text = movieData?.overview ?? ""
        cell.movieReleaseDateLabel.text = "Release Date: \(movieData?.release_date ?? "")"
        cell.movieRatingsLabel.text = "Rating: \(movieData?.vote_average ?? 0.0)"
        cell.moviePosterImageView.loadImage(movieData?.poster_path ?? "", type: .portrait)
        cell.movieBookButton.tag = indexPath.row
        cell.delegate = self
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailsViewController") as! MovieDetailsViewController
        movieDetailsVC.movieDetails = filteredMovieDataArray?[indexPath.row]
//        BMSPreferences.addMovieToPreference(data: filteredMovieDataArray?[indexPath.row] ?? nil)
        self.navigationController?.pushViewController(movieDetailsVC, animated: true)
    }
    
}

// MARK:- UIScrollView Delegates
extension MovieListingViewController: UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        // UITableView only moves in one direction, y axis
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        // Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 10.0 {
            fetchMovieData(page_number: currentPage + 1)
        }
    }
}

extension MovieListingViewController: MovieListingTableViewDelegate {
    func movieBookButtonPressed(sender: UIButton) {
        
        let movieData = filteredMovieDataArray?[sender.tag]

        let message = "Are you sure you want to book \(movieData?.title ?? "")?"
        
        let alert = UIAlertController(title: "BMSAssessment", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Book", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}


