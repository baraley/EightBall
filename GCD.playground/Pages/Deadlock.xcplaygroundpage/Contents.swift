import Foundation

let firstQueue = DispatchQueue(label: "com.my.firstQueue")
let secondQueue = DispatchQueue(label: "com.my.secondQueue")

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
