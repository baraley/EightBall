import Foundation

let firstQueue = DispatchQueue(label: "first queue")
let secondQueue = DispatchQueue(label: "second queue")

firstQueue.async {
	print("first queue begin execution") // flow 1

	secondQueue.sync {
		print("second queue begin execution") // flow 2

		print("before deadlock")

		firstQueue.sync {
			print("this code will never be executed") // flow 3
		}
	}
	print("this one either")
}
