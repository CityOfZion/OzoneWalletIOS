//
//  O3Client.swift
//  O3
//
//  Created by Apisit Toompakdee on 9/17/17.
//  Copyright © 2017 drei. All rights reserved.
//

import UIKit

typealias JSONDictionary = [String: Any]

public enum O3ClientError: Error {
    case  invalidBodyRequest, invalidData, invalidRequest, noInternet

    var localizedDescription: String {
        switch self {
        case .invalidBodyRequest:
            return "Invalid body Request"
        case .invalidData:
            return "Invalid response data"
        case .invalidRequest:
            return "Invalid server request"
        case .noInternet:
            return "No Internet connection"
        }
    }
}

public enum O3ClientResult<T> {
    case success(T)
    case failure(O3ClientError)
}

public class O3Client {

    enum O3Endpoints: String {
        case getPriceHistory = "/v1/price/"
        case getPortfolioValue = "/v1/historical"
        case getNewsFeed = "/v1/feed/"
        case getFeatureFeed = "/v1/features"
        case getTokenSales = "https://s3-ap-northeast-1.amazonaws.com/network.o3.cdn/data/___tokensale.json"
    }

    enum HTTPMethod: String {
        case GET
    }
    var baseURL = "https://api.o3.network"

    public static let shared = O3Client()

    func sendRequest(_ endpointURL: String, method: HTTPMethod, data: [String: Any?]?,
        noBaseURL: Bool = false, completion: @escaping (O3ClientResult<JSONDictionary>) -> Void) {
        var urlString = ""
        if noBaseURL {
            urlString = endpointURL
        } else {
            urlString = baseURL + endpointURL
        }
        let url = URL(string: urlString)
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("application/json-rpc", forHTTPHeaderField: "Content-Type")

        if data != nil {
            guard let body = try? JSONSerialization.data(withJSONObject: data!, options: []) else {
                completion(.failure(.invalidBodyRequest))
                return
            }
            request.httpBody = body
        }

        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, _, err) in
            if err != nil {
                completion(.failure(.invalidRequest))
                return
            }

            guard let dataUnwrapped = data,
                let json = (try? JSONSerialization.jsonObject(with: dataUnwrapped, options: [])) as? JSONDictionary else {
                    completion(.failure(.invalidData))
                    return
            }

            let result = O3ClientResult.success(json)
            completion(result)
        }
        task.resume()
    }

    func getPriceHistory(_ symbol: String, interval: String, completion: @escaping (O3ClientResult<History>) -> Void) {
        let endpoint = O3Endpoints.getPriceHistory.rawValue + symbol + String(format: "?i=%@", interval)
        sendRequest(endpoint, method: .GET, data: nil) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let response):
                let decoder = JSONDecoder()
                guard let result = response["result"] as? JSONDictionary,
                    let data = result["data"] as? JSONDictionary,
                    let responseData = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted),
                    let block = try? decoder.decode(History.self, from: responseData) else {
                        completion(.failure(.invalidData))
                        return
                }

                let clientResult = O3ClientResult.success(block)
                completion(clientResult)
            }
        }
    }

    func getPortfolioValue(_ assets: [TransferableAsset], interval: String, completion: @escaping (O3ClientResult<PortfolioValue>) -> Void) {

        var queryString = String(format: "?i=%@", interval)
        for asset in assets {
            queryString += String(format: "&%@=%@", asset.symbol, asset.balance.description)
        }
        queryString += String(format: "&currency=%@", UserDefaultsManager.referenceFiatCurrency.rawValue)

        let endpoint = O3Endpoints.getPortfolioValue.rawValue + queryString
        print (endpoint)
        sendRequest(endpoint, method: .GET, data: nil) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let response):
                let decoder = JSONDecoder()
                guard let result = response["result"] as? JSONDictionary,
                    let data = result["data"] as? JSONDictionary,
                    let responseData = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted),
                    let block = try? decoder.decode(PortfolioValue.self, from: responseData) else {
                        completion(.failure(.invalidData))
                        return
                }

                let clientResult = O3ClientResult.success(block)
                completion(clientResult)
            }
        }
    }

    func getNewsFeed(completion: @escaping(O3ClientResult<FeedData>) -> Void) {
        let endpoint = O3Endpoints.getNewsFeed.rawValue
        sendRequest(endpoint, method: .GET, data: nil) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let response):
                let decoder = JSONDecoder()
                guard let result = response["result"] as? JSONDictionary,
                    let data = result["data"] as? JSONDictionary,
                    let responseData = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted),
                    let feedData = try? decoder.decode(FeedData.self, from: responseData) else {
                        completion(.failure(.invalidData))
                        return
                }

                let clientResult = O3ClientResult.success(feedData)
                completion(clientResult)
            }
        }
    }

    func getFeatures(completion: @escaping(O3ClientResult<FeatureFeed>) -> Void) {
        let endpoint = "https://cdn.o3.network/data/featured.json"
        sendRequest(endpoint, method: .GET, data: nil, noBaseURL: true) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let response):
                let decoder = JSONDecoder()
                guard let data = try? JSONSerialization.data(withJSONObject: response, options: .prettyPrinted),
                    let featureFeed = try? decoder.decode(FeatureFeed.self, from: data) else {
                        return
                }
                completion(.success(featureFeed))
            }
        }
    }

    func getTokens(completion: @escaping(O3ClientResult<[NEP5Token]>) -> Void) {
        var endpoint = "https://cdn.o3.network/data/nep5.json"
        #if TESTNET
        endpoint = "https://o3.network/settings/nep5.test.json"
        #endif
        #if PRIVATENET
        endpoint = "https://s3-ap-northeast-1.amazonaws.com/network.o3.cdn/data/nep5.private.json"
        #endif
      
        sendRequest(endpoint, method: .GET, data: nil, noBaseURL: true) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let response):
                let decoder = JSONDecoder()
                guard let data = try? JSONSerialization.data(withJSONObject: response["nep5tokens"]!, options: .prettyPrinted),
                    let list = try? decoder.decode([NEP5Token].self, from: data) else {
                        return
                }
                completion(.success(list))
            }
        }
    }

    func getTokenSales(completion: @escaping(O3ClientResult<TokenSales>) -> Void) {
        var endpoint = "https://cdn.o3.network/data/tokensales.json"
        #if PRIVATENET
        endpoint = "https://s3-ap-northeast-1.amazonaws.com/network.o3.cdn/data/___tokensale.json"
        #endif
        sendRequest(endpoint, method: .GET, data: nil, noBaseURL: true) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let response):
                let decoder = JSONDecoder()
                guard let data = try? JSONSerialization.data(withJSONObject: response, options: .prettyPrinted),

                    let liveSales = try? decoder.decode(TokenSales.self, from: data) else {
                        return
                }
                completion(.success(liveSales))
            }
        }
    }
}
