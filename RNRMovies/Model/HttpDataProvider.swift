//
// Created by Robert Redmond on 05/01/2018.
// Copyright (c) 2018 Robert Redmond. All rights reserved.
//

import Foundation

protocol DataProvider {
    func fetchData(completionHandler: @escaping (Bool, Any?) -> ())
}

class HttpDataProvider: DataProvider {
    init(baseUrl: String) {
        var apiKey = ""
        if let path = Bundle.main.path(forResource: "Keys", ofType: "plist"), let keys = NSDictionary(contentsOfFile: path) as? [String :String] {
            apiKey = keys["ApiKey"] ?? ""
        }
        self.baseUrlAndUrlKey = "\(baseUrl)&api_key=\(apiKey)"
    }

    func fetchData(completionHandler: @escaping (Bool, Any?) -> ()) {
        let url = URL(string: "\(self.baseUrlAndUrlKey)")
        debugPrint(self.baseUrlAndUrlKey)
        let dataTask = defaultSession.dataTask(with: url!) {
            data, response, error in
            if let error = error {
                print(error.localizedDescription)
                completionHandler(false, nil)
            } else if let httpResponse = response as? HTTPURLResponse {
                if let jsonData = data, httpResponse.statusCode == 200 {
                    var json: Any?
                    do {
                        json = try JSONSerialization.jsonObject(with: jsonData)
                        completionHandler(true, json)
                    } catch {
                        completionHandler(false, nil)
                    }
                } else {
                    completionHandler(false, nil)
                }

            }
        }

        dataTask.resume()

    }

    fileprivate let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
    fileprivate let baseUrlAndUrlKey: String
}
