//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate{
    func didUpdateCoin(price: Double, currency:String)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "1A969134-4D5C-480C-9354-7FDAB4F769F5"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    var delegate:CoinManagerDelegate?
    
    func getCoinPrice(for currency:String){
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        performRequest(urlString, currency)
    }
    
    
    func performRequest(_ urlString: String, _ currency: String){
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil{
                    delegate?.didFailWithError(error: error!)
                    return
                }
                print(data!)
                if let safeData = data{
//                    conversi json ke string
//                    let coinData = String(data: safeData, encoding: .utf8)
                    
                    if let bitcoinPrice = self.parseJson(safeData) {
                        delegate?.didUpdateCoin(price: bitcoinPrice, currency: currency)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJson(_ coinData:Data) -> Double?{
        let decoder = JSONDecoder()
        do{
            let decodeData = try decoder.decode(CoinData.self, from: coinData )
            let lastPrice = decodeData.rate
            return lastPrice
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
