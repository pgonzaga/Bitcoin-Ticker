//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by Angela Yu on 23/01/2016.
//  Copyright © 2016 London App Brewery. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = [
        "AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"
    ]

    //Pre-setup IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
       
    }

//MARK: - UIPicker delegates
/***************************************************************/

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        setBitcoin(currencyCode: currencyArray[row])
    }

//MARK: - URL helpers
/***************************************************************/

    func createApiURL(currencyCode: String) -> String {
        return "\(baseURL)\(currencyCode)"
    }

//MARK: - Networking
/***************************************************************/

    func setBitcoin(currencyCode: String) {
        let url = createApiURL(currencyCode: currencyCode)

        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if response.result.isSuccess {
                    let bitcoinJSON: JSON = JSON(response.result.value!)
                    self.bitcoinPriceLabel.text = self.getBitcoin(json: bitcoinJSON)
                } else {
                    self.bitcoinPriceLabel.text = "error"
                }
            }

    }

//MARK: - JSON Parsing
/***************************************************************/
    func getBitcoin(json: JSON) -> String {
        return json["ask"].stringValue
    }
}

