//
//  GoogleAPIService.swift
//  TwitterSentimentAnalysisApp
//
//  Created by Alekhya Gandu on 4/20/22.
//

import Foundation

enum GoogleAPIServiceError: Error {
    case InvalidURL
    case UserNotFound
    case Unauthorized
}

struct bodyData: Codable {
    let document: [String: String]
    let key: String
}

struct GoogleAPIService {
    
    let GoogleapiKey = Bundle.main.object(forInfoDictionaryKey: "GOOGLE_API_KEY")
    let baseURL = "https://language.googleapis.com/v1/documents:analyzeSentiment?key="
    
    
    func fetchUserSentiment(content: String) async throws -> UserSentiment {
        
        struct Document: Encodable {
            let type: String
            let content: String
        }

        struct PostData: Encodable {
            //let encodingType: String
            let document: Document
        }

        let encoder = JSONEncoder()

        let postData = PostData(document: Document(type: "PLAIN_TEXT", content: content))

        let payload = try! encoder.encode(postData)
        
//        let payload: [String: [String: String]] = [
////            "encodingType": "UTF8",
//            "document" : [
//                "type": "PLAIN_TEXT",
//                "content": "Enjoy your vacation"
//            ]
//        ]
        
        guard let key = GoogleapiKey else {
            print("key is not being assigned GoogleapiKey")
            throw GoogleAPIServiceError.Unauthorized
        }
        
        //let body: bodyData = bodyData(document: document, key: key as! String)

        guard let url = URL(string: "\(baseURL)\(key)") else {
            throw GoogleAPIServiceError.InvalidURL
        }
//
////        guard let url = URL(string: "https://eojq0xp4f3qisv.m.pipedream.net") else { //To inspect what I was sending in my paylaod
////            throw GoogleAPIServiceError.InvalidURL
////        }
//
        var urlRequest = URLRequest(url: url)
        
        
        
//        let parameters = "{\"document\": {\"type\": \"PLAIN_TEXT\",\"content\": \"Hey yo youre crazy. Omg this is not cool.\"}}"
//        //let postData = parameters.data(using: .utf8)
//
//        var request = URLRequest(url: URL(string: "https://language.googleapis.com/v1/documents:analyzeSentiment?key=\(key)")!,timeoutInterval: Double.infinity)
//
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        request.httpMethod = "POST"
//        request.httpBody = payload
//
//        print(String(data: payload, encoding: String.Encoding.ascii)!)
        
        
        
        //print("The URL Request is: ")
        //print(urlRequest)
        
//        print(JSONSerialization.isValidJSONObject(document))
        
        //let JsonObj = try JSONEncoder().encode(payload)
//        let jsonString = String(data: JsonObj, encoding: String.Encoding.ascii)!//To Print out the string
//        print(jsonString)
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = payload
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        
        let outputStr = String(data: data, encoding: String.Encoding.ascii)!
        
        let decoder = JSONDecoder()
        return try decoder.decode(UserSentiment.self, from: data)

    }
    
}
