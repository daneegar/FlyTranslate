//
//  API.swift
//  FlyTranslate
//
//  Created by Denis Garifyanov on 03/12/2018.
//  Copyright © 2018 Denis Garifyanov. All rights reserved.
//

import Foundation

struct AnswerWithTranslate: Codable {
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

struct AnswerWithDetectedLanguage: Codable {
    let code: Int
    let lang: String
    
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case lang = "lang"
    }
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.code = try valueContainer.decode(Int.self, forKey: CodingKeys.code)
        self.lang = try valueContainer.decode(String.self, forKey: CodingKeys.lang)
    }
}

class translateWithYandex {
    let stringUrlForTranslate: String
    let stringUrlDetectLang: String
    let urlForTranslate: URL
    let UrlDetectLang: URL
    init () {
        self.stringUrlForTranslate = "https://translate.yandex.net/api/v1.5/tr.json/translate"
        self.stringUrlDetectLang = "https://translate.yandex.net/api/v1.5/tr.json/detect"
        self.urlForTranslate = URL(string: self.stringUrlForTranslate)!
        self.UrlDetectLang = URL(string: self.stringUrlDetectLang)!
    }
    
    func translateWithDetectingLanguage (it text: String, inDirection fromEnToRu: Bool, completion: ((AnswerWithTranslate?, URLResponse?, Error?) -> Void)?){
        checkLanguage(thisText: text) { (detectedLanguage, response, error) in
            let directionToTranslateIsEnRu: Bool
            guard let catchedAnswer = detectedLanguage else { return }
            if catchedAnswer.lang == "en"{
                directionToTranslateIsEnRu = true
            } else if catchedAnswer.lang == "ru" {
                directionToTranslateIsEnRu = false
            } else { directionToTranslateIsEnRu = fromEnToRu }
            self.translate(it: text, inDirection: directionToTranslateIsEnRu, completion: { (answer, response, error) in
                DispatchQueue.main.async {
                    completion?(answer, response ,nil)
                }
            })
        }
    }
    
    func translate (it text: String, inDirection fromEnToRu: Bool, completion: ((AnswerWithTranslate?, URLResponse?, Error?) -> Void)?){
        var resultURL = self.urlForTranslate.append("key", value: APIKey.instance.key)
        let lang = fromEnToRu ? "en-ru" : "ru-en"
        resultURL = resultURL.append("lang", value: lang)
        resultURL = resultURL.append("text", value: text)
        let task = URLSession.shared.dataTask(with: resultURL) { (data, urlResponse, error) in
            let jsonDecoder = JSONDecoder()
            if let catchedData = data, let answer = try? jsonDecoder.decode(AnswerWithTranslate.self, from: catchedData)
                {
                    DispatchQueue.main.async {
                        completion?(answer, urlResponse ,nil)
                    }
                }
//            if let urlResponse = urlResponse {
//                //print(urlResponse)
//            }
            if let error = error {
                print(error)
            }
        }
        task.resume()
    }
    
    func checkLanguage (thisText text: String, completion: ((AnswerWithDetectedLanguage?, URLResponse?, Error?) -> Void)?){
        var resultURL = self.UrlDetectLang.append("key", value: APIKey.instance.key)
        let hint = "en,ru"
        resultURL = resultURL.append("text", value: text)
        resultURL = resultURL.append("lang", value: hint)
        let task = URLSession.shared.dataTask(with: resultURL) { (data, urlResponse, error) in
//            let string = String(data: data!, encoding: .utf8)
//            print(string)
            let jsonDecoder = JSONDecoder()
            if let catchedData = data, let answer = try? jsonDecoder.decode(AnswerWithDetectedLanguage.self, from: catchedData)
            {
                DispatchQueue.main.async {
                    completion?(answer, urlResponse ,nil)
                }
            }
//            if let urlResponse = urlResponse {
//                //print(urlResponse)
//            }
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
