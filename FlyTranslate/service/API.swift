//
//  API.swift
//  FlyTranslate
//
//  Created by Denis Garifyanov on 03/12/2018.
//  Copyright © 2018 Denis Garifyanov. All rights reserved.
//

import Foundation
struct Answer: Codable {
    let code: Int
    let lang: String
    let text: [String]
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case lang = "lang"
        case text = "text"
    }
    
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.code = try valueContainer.decode(Int.self, forKey: CodingKeys.code)
        self.lang = try valueContainer.decode(String.self, forKey: CodingKeys.lang)
        self.text = try valueContainer.decode(Array<String>.self, forKey: CodingKeys.text)
    }
}
class translateWithYandex {
    let stringURL: String
    let url: URL
    init () {
        self.stringURL = "https://translate.yandex.net/api/v1.5/tr.json/translate"
        self.url = URL(string: self.stringURL)!
    }
    func translate (it text: String?, inDirection fromEnToRu: Bool?){
        var resultURL = self.url.append("key", value: APIKey.instance.key)
        resultURL = resultURL.append("lang", value: "en-ru")
        resultURL = resultURL.append("text", value: "Hello World!")
        let task = URLSession.shared.dataTask(with: resultURL) { (data, urlResponse, error) in
            let jsonDecoder = JSONDecoder()
            if let catchedData = data, let translate = try? jsonDecoder.decode(Answer.self, from: catchedData)
                {
                    print(translate)
                }
            if let urlResponse = urlResponse {
                print(urlResponse)
            }
            if let error = error {
                print(error)
            }
        }
        task.resume()
    }
}


extension URL {
    
    @discardableResult
    func append(_ queryItem: String, value: String?) -> URL {
        
        guard var urlComponents = URLComponents(string:  absoluteString) else { return absoluteURL }
        
        // create array of existing query items
        var queryItems: [URLQueryItem] = urlComponents.queryItems ??  []
        
        // create query item if value is not nil
        guard let value = value else { return absoluteURL }
        let queryItem = URLQueryItem(name: queryItem, value: value)
        
        // append the new query item in the existing query items array
        queryItems.append(queryItem)
        
        // append updated query items array in the url component object
        urlComponents.queryItems = queryItems// queryItems?.append(item)
        
        // returns the url from new url components
        return urlComponents.url!
    }
}
