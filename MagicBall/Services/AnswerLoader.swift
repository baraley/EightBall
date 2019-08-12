//
//  AnswerLoader.swift
//  MagicBall
//
//  Created by Alexander Baraley on 8/6/19.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import Foundation

private let answerLink = "https://8ball.delegator.com/magic/JSON/end"

class AnswerLoader {
	
	private let urlRequest: URLRequest = {
		var request = URLRequest.init(url: URL(string: answerLink)!)
		request.timeoutInterval = 3
		return request
	}()
	
	var isLoading: Bool = false
	
	func loadAnswer(_ completionHandler: @escaping (String?) -> Void) {

		let dataTask = URLSession.shared.dataTask(with: urlRequest) { [weak self] (data, _, _) in
			
			self?.isLoading = false
			
			if 	let data = data,
				let jsonData = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
				let magic = (jsonData["magic"] as? [String: String]),
				let answer = magic["answer"] {
				
				completionHandler(answer)
			} else {
				completionHandler(nil)
			}
			
		}
		dataTask.resume()
		isLoading = true
	}
}
