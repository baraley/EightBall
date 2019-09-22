//
//  AnswerLoader.swift
//  MagicBall
//
//  Created by Alexander Baraley on 8/6/19.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import Foundation

private let answerLink = "https://8ball.delegator.com/magic/JSON/end"

final class AnswerLoader {
	
	var isLoading: Bool = false
	
	private let urlRequest: URLRequest = .init(url: URL(string: answerLink)!)
	
	func loadAnswer(_ completionHandler: @escaping (Result<String, NetworkError>) -> Void) {

		let dataTask = URLSession.shared.dataTask(with: urlRequest) { [weak self] (data, _, error) in
			
			self?.isLoading = false
			
			if 	let data = data,
				let jsonData = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
				let magic = (jsonData["magic"] as? [String: String]),
				let answer = magic["answer"] {
				
				completionHandler(.success(answer))
			} else {
				let networkError = NetworkError(error: error)
				completionHandler(.failure(networkError))
			}
			
		}
		dataTask.resume()
		isLoading = true
	}
	
}
