//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet var bitcoinLabel: UILabel!

    @IBOutlet var currencyLabel: UILabel!

    @IBOutlet var currencyPicker: UIPickerView!

    var coinManager = CoinManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.dataSource = self
        currencyPicker.delegate = self

        coinManager.delegate = self
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let currency: String = coinManager.currencyArray[row]

        coinManager.getCoinPrice(for: currency)
    }
}

extension ViewController: CoinManagerDelegate {
    func didFailWithError(error: any Error) {
        print(error)
    }

    func didUpdatePrice(_ coinManager: CoinManager, price: PriceModel) {
        DispatchQueue.main.async {
            self.currencyLabel.text = price.currency
            self.bitcoinLabel.text = price.priceString
        }
    }
}
