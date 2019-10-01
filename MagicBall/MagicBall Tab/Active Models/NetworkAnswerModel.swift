//
//  NetworkAnswerModel.swift
//  MagicBall
//
//  Created by Alexander Baraley on 29.09.2019.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import Foundation

protocol NetworkServiceProtocol {

	func performRequest(_ request: AnswerRequest, with completionHandler: @escaping NetworkAnswerModel.CompletionHandler)

}

final class NetworkAnswerModel {

	typealias CompletionHandler = (Result<AnswerRequest.ResultModel, AnswerRequest.ResultError>) -> Void

	private let answerRequest: AnswerRequest
	private let networkService: NetworkServiceProtocol

	init(answerRequest: AnswerRequest = AnswerRequest(), networkService: NetworkServiceProtocol = NetworkService()) {
		self.answerRequest = answerRequest
		self.networkService = networkService
	}

	func loadAnswer(with completionHandler: @escaping CompletionHandler) {

		networkService.performRequest(answerRequest) { (result) in
			completionHandler(result)
		}
	}
}
