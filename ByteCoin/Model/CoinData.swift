//
//  CoinData.swift
//  ByteCoin
//
//  Created by Andrew Indayang on 26/03/23.
//  Copyright © 2023 The App Brewery. All rights reserved.
//

import Foundation


struct CoinData :Codable{
    let time:String
    let asset_id_base: String
    let asset_id_quote: String
    let rate: Double
}
