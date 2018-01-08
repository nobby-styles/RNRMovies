//
// Created by Robert Redmond on 08/01/2018.
// Copyright (c) 2018 Robert Redmond. All rights reserved.
//

import Foundation

class MockMutableDataProvider: MutableDataProvider {
    func fetchData(completionHandler: @escaping (Bool, Any?) -> ()) {
        guard let dict = dict else {
            completionHandler(false, nil)
            return
        }
        completionHandler(true, dict)
    }

    func fetchData(urlString: String, completionHandler: @escaping (Bool, Any?) -> ()) {
        guard let dict = urlDict else {
            completionHandler(false, nil)
            return
        }
        completionHandler(true, dict)
    }

    var dict: [String: Any]?
    var urlDict : [String: Any]?
}