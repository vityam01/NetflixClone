//
//  APICaller.swift
//  NetflixClone
//
//  Created by Vitya Mandryk on 19.05.2022.
//

import Foundation


struct Constants {
    static let key = "54ce5f60fcdf29d742b96ec86585b9a1"
    static let baseURL = "https://api.themoviedb.org"
    static let imageURL = "https://image.tmdb.org/t/p/w500/"
    static let youTubeKey = "AIzaSyAHcxmgf8fW8iG0TwXmp1AIljnZGX5abhc"
    static let youtubeBaseURL = "https://youtube.googleapis.com/youtube/v3/search?"
}

enum ApiError: Error {
    case failedTogetData
}

class APICaller {
    
    static let shared = APICaller()
    
    func getMovies(keyValue: String ,completion: @escaping (Result<[Title], Error>) -> Void ) {
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/\(keyValue)/day?api_key=\(Constants.key)&language=en-US&page=1") else { return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil  else { return }
            do {
                let result = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(result.results))
            } catch  {
                completion(.failure(ApiError.failedTogetData))
            }
        }
        task.resume()
    }
    
    func getDiscoverMovies(completion: @escaping (Result<[Title], Error>) -> Void ) {
        guard let url = URL(string: "\(Constants.baseURL)/3/discover/movie?api_key=\(Constants.key)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate") else { return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil  else { return }
            do {
                let result = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(result.results))
            } catch  {
                completion(.failure(ApiError.failedTogetData))
            }
        }
        task.resume()
    }

    func search(with query: String,completion: @escaping (Result<[Title], Error>) -> Void ) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        guard let url = URL(string: "\(Constants.baseURL)/3/search/movie?api_key=\(Constants.key)&query=\(query)") else { return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil  else { return }
            do {
                let result = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(result.results))
            } catch  {
                completion(.failure(ApiError.failedTogetData))
            }
        }
        task.resume()
    }
    
    func getYouTubeMovie(with query: String, completion: @escaping (Result<VideoElement, Error>) -> Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        guard let url = URL(string: "\(Constants.youtubeBaseURL)q=\(query)&key=\(Constants.youTubeKey)") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil  else { return }
            do {
                let result = try JSONDecoder().decode(YouTubeSearchResponse.self, from: data )
                completion(.success(result.items[0]))
            } catch  {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func getMovie(with query: String, completion: @escaping (Result<VideoElement, Error>) -> Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        guard let url = URL(string: "\(Constants.youtubeBaseURL)q=\(query)&key=\(Constants.youTubeKey)") else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let results = try JSONDecoder().decode(YouTubeSearchResponse.self, from: data)
                
                completion(.success(results.items[0]))
                

            } catch {
                completion(.failure(error))
                print(error.localizedDescription)
            }

        }
        task.resume()
    }
    
}

