//
//  ConverterService.swift
//  P9
//
//  Created by Mac Book Pro on 21/02/2019.
//  Copyright © 2019 dylan. All rights reserved.
//


import Foundation

class ConverterService {
    
    // contains the full name and rate of the destination currency
    private var _rateValueDestination = 0.0
    
    var rateValueDestination: Double {
        return _rateValueDestination
    }
    
    //URL base
    private let _url = "http://data.fixer.io/api/latest?"
    
    // the session
    private var session: URLSession
    
    init(session: URLSession = URLSession(configuration: .default)) {
        self.session = session
    }
    
    // allow create request
    func getRates(callback: @escaping (Bool, Rates?, String?) -> Void) {
        
        // parameters
        let accessKey = "access_key=\(APIKey.shared.apiKeyConverter)"
        // parameters
        let symbols = "&symbols=CAD,EUR,USD,BTC,AUD,GBP,ILS,CHF,COP,HKD"
        // all parameters
        let parameters = accessKey + symbols
        
        // complete URL
        guard let urlComplete = URL(string: _url + parameters) else {
            print(ErrorMessages.errorURLComplete_Converter)
            return
        }
        
        // the request
        var request = URLRequest(url: urlComplete)
        request.httpMethod = Constants.getMethod
        
        // the task
        let task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                
                guard let data = data, error == nil else {
                    print(ErrorMessages.errorDataNilOrError_Converter)
                    callback(false, nil, nil)
                    return
                }
                
                guard let response = response as? HTTPURLResponse else {
                    print(ErrorMessages.errorResponseIsNotHTTPURLResponse_Converter)
                    callback(true, nil, nil)
                    return
                }
                
                guard response.statusCode != 500 else {
                    print(ErrorMessages.errorStatusCode500_Converter)
                    callback(true, nil, nil)
                    return
                }
                
                guard response.statusCode == 200 else {
                    print(ErrorMessages.errorStatusCode_Converter)
                    callback(false, nil, nil)
                    return
                }
                
                // we decode the JSON
                let dataJSON = try? JSONDecoder().decode(Result.self, from: data)
                
                // we check that the dataJSON is not nil
                guard let json = dataJSON else {
                    print(ErrorMessages.errorJSONDecoder_Converter)
                    callback(false, nil, nil)
                    return
                }
                
                // we check that the rates is not nil
                guard let rates = json.rates else {
                    print(ErrorMessages.errorJSONRatesIsNil_Converter)
                    callback(false, nil, nil)
                    return
                }
                
                let dateRates = self._getUpdateDateOfRates(responseJSON: json)
                
                callback(true, rates, dateRates)
                return
            }
        }
        task.resume()
    }
    
    // retrieve the date of the last update of the rates
    private func _getUpdateDateOfRates(responseJSON: Result) -> String? {
        
        guard let timestamp = responseJSON.timestamp else {
            print(ErrorMessages.noTimestamp)
            return nil
        }
        
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let dateFormat = date.returnDateFormat() // ex: 15/06/2019 20:10
        let dateString = "les taux ont été mis à jour le: \(dateFormat)"
        
        return dateString
    }
    
    // allows you to change the values of the tuple rateValueDestination .name and .rates
    func changeValueOfRateDestination(rate: Double) {
        _rateValueDestination = rate
    }
    
    // is used to calculate and return the result
    private func _convert(moneyToConvert: Double) -> Double {
        // contains the rate of the destination currency
        let rateValueDestination = _rateValueDestination
        // contains the result of the operation
        let result = moneyToConvert * rateValueDestination
        return result
    }
    
    // simply returns the private method convert()
    func convert(moneyToConvert: Double) -> Double {
        return _convert(moneyToConvert: moneyToConvert)
    }
    
}
