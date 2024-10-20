//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdatePrice(_ coinManager: CoinManager, price: PriceModel)
    func didFailWithError(error: Error)
}

struct CoinManager {
    var delegate: CoinManagerDelegate?
    
    let baseURL: String = "https://rest.coinapi.io/v1/exchangerate/BTC/"

    let apiKey = "B95E0CAA-60ED-4AC2-903A-BD5A01F87FA8"

    let currencyArray = ["AUD", "BRL", "CAD", "CNY", "EUR", "GBP", "HKD", "IDR", "ILS", "INR", "JPY", "MXN", "NOK", "NZD", "PLN", "RON", "RUB", "SEK", "SGD", "USD", "ZAR"]

    func getCoinPrice(for currency: String) {
        print("currency: \(currency)")

        let urlString = "\(baseURL)\(currency)"
        
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        // 1. create URL
        
        if let url = URL(string: urlString) {
            // 2. create URLSession
//            let session = URLSession(configuration: .default)
            
            // 3. give session a task
//           let task: URLSessionDataTask = session.dataTask(with: url, completionHandler: handle(data:respons*/e:error:))
            
            var request = URLRequest(url: url, timeoutInterval: Double.infinity)
            
            request.addValue(apiKey, forHTTPHeaderField: "X-CoinAPI-Key")

            request.httpMethod = "GET"
            
            let task: URLSessionDataTask = URLSession.shared.dataTask(with: request) { data, _, error in
                if error != nil {
//                    print(error!)
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
//                    let dataString = String(data: safeData, encoding: .utf8)
//                    print("dataString: \(dataString)")
//                    print("data: \(data)")
                    
                    if let price = parseJson(priceData: safeData) {
                        self.delegate?.didUpdatePrice(self, price: price)
                    }
                }
            }
            
            // 4. start task
            task.resume()
        }
    }
    
    func parseJson(priceData: Data) -> PriceModel? {
        let decoder = JSONDecoder()
        
        do {
            let parsedData: PriceData = try decoder.decode(PriceData.self, from: priceData)
            
            let currency: String = parsedData.assetIDQuote
            let price: Double = parsedData.rate
            
            let priceModel = PriceModel(currency: currency, price: price)
            
            return priceModel
            
        } catch {
            print(error)
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
