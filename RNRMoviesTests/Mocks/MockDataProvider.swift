//
// Created by Robert Redmond on 07/01/2018.
// Copyright (c) 2018 Robert Redmond. All rights reserved.
//

import Foundation

class MockDataProvider: DataProvider {
    func fetchData(completionHandler: @escaping (Bool, Any?) -> ()) {
        guard let dict = dict else {
            completionHandler(false, nil)
            return
        }
        completionHandler(true, dict)
    }

    var dict: [String: Any]?
}