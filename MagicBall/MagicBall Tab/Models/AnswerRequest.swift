//
//  AnswerRequest.swift
//  MagicBall
//
//  Created by Alexander Baraley on 29.09.2019.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import Foundation

struct AnswerRequest: NetworkRequest {

	private let question: String

	init(question: String = "Why?") {
		self.question = question
	}

	var urlRequest: URLRequest {
		var urlComponents = URLComponents()
		urlComponents.scheme = "https"
		urlComponents.host = "8ball.delegator.com"
		urlComponents.path = "/magic/JSON/\(question)"
		return .init(url: urlComponents.url!)
	}

	func decode(_ data: Data?, response: URLResponse?, error: Error?) -> Result<NetworkAnswer, NetworkError> {

		if let data = data, let networkAnswer = try? JSONDecoder().decode(NetworkAnswer.self, from: data) {

			return .success(networkAnswer)
		} else {
			let error =	NetworkError(error: error)

			return .failure(error)
		}
	}
}
