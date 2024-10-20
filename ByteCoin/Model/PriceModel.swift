//
//  PriceModel.swift
//  ByteCoin
//
//  Created by Aavhan Chatse on 08/09/24.
//  Copyright © 2024 The App Brewery. All rights reserved.
//

import Foundation

struct PriceModel {
    let currency: String
    let price: Double

    var priceString: String {
        return String(format: "%.4f", price)
    }
}
