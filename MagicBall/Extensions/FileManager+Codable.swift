//
//  FileManager+Codable.swift
//  MagicBall
//
//  Created by Alexander Baraley on 8/12/19.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import Foundation

extension FileManager {

	static func pathForFileInDocumentDirectory(withName name: String) -> String {
		let documentDirectory = FileManager.default.urls(for: .documentDirectory,
														 in: .userDomainMask).first!
		let archiveURL = documentDirectory.appendingPathComponent(name)
		return archiveURL.path
	}

	func saveContent<T: Codable>(_ content: T, atPath path: String) {
		do {
			let data = try JSONEncoder().encode(content)
			if FileManager.default.fileExists(atPath: path) {
				try FileManager.default.removeItem(atPath: path)
			}
			FileManager.default.createFile(atPath: path, contents: data, attributes: nil)
		} catch {
			fatalError(error.localizedDescription)
		}
	}

	func loadSavedContent<T: Codable>(atPath path: String) -> T? {
		guard let data = FileManager.default.contents(atPath: path) else { return nil }

		let decoder = JSONDecoder()

		return (try? decoder.decode(T.self, from: data))
	}

	func loadContentFromBundle<T: Codable>(withName name: String) -> T {
		let decoder = JSONDecoder()

		if 	let source = Bundle.main.path(forResource: name, ofType: nil),
			let data = FileManager.default.contents(atPath: source),
			let content = (try? decoder.decode(T.self, from: data)) {

			return content
		} else {
			fatalError("Can not load content with name: \(name)")
		}
	}
}
