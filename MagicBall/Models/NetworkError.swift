//
//  NetworkError.swift
//  MagicBall
//
//  Created by Alexander Baraley on 8/13/19.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import Foundation

enum NetworkError: Error, LocalizedError, Equatable {
	case noInternet
	case unknown(String)
	
	init(error: Error?) {
		if let error = error as NSError?, error.code == -1009 {
			self = .noInternet
		}
		self = .unknown(error?.localizedDescription ?? "Unknown error")
	}
	
	var errorDescription: String {
		switch self {
		case .noInternet:
			return "There is no internet conection. Please, try to use answers from answer sets."
			
		case .unknown(let message):
			return message
		}
	}
}
