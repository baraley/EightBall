//
//  SecureStorage.swift
//  MagicBall
//
//  Created by Alexander Baraley on 08.10.2019.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

protocol SecureStorageSavable { }

class SecureStorage {

	@discardableResult
	func setValue<T>(_ value: T, forKey key: String) -> Bool where T: SecureStorageSavable {
		let wrapper = KeychainWrapper.standard

		switch value {
		case let boolValue as Bool:
			wrapper.set(boolValue, forKey: key)

		case let integerValue as Int:
			wrapper.set(integerValue, forKey: key)

		case let floatValue as Float:
			wrapper.set(floatValue, forKey: key)

		case let doubleValue as Double:
			wrapper.set(doubleValue, forKey: key)

		case let stringValue as String:
			wrapper.set(stringValue, forKey: key)

		default:
			return false
		}

		return true
	}

	func value<T>(forKey key: String) -> T? where T: SecureStorageSavable {
		let wrapper = KeychainWrapper.standard

		switch T.self {
		case is Bool.Type:
			return wrapper.bool(forKey: key) as? T

		case is Int.Type:
			return wrapper.integer(forKey: key) as? T

		case is Float.Type:
			return wrapper.float(forKey: key) as? T

		case is Double.Type:
			return wrapper.double(forKey: key) as? T

		case is String.Type:
			return wrapper.string(forKey: key) as? T

		default:
			return nil
		}
	}

}

extension Bool: SecureStorageSavable { }
extension Int: SecureStorageSavable { }
extension Float: SecureStorageSavable { }
extension Double: SecureStorageSavable { }
extension String: SecureStorageSavable { }
