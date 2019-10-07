import Foundation

let secondsToPrint = 3

let backgroundQueue = DispatchQueue(label: "com.my.backgroundQueue", qos: .background, attributes: .concurrent)

var infinitePrintWorkItem: DispatchWorkItem?

infinitePrintWorkItem = DispatchWorkItem {
	var iteration = 0
	while infinitePrintWorkItem?.isCancelled == false {
		print(iteration)
		iteration += 1
		sleep(1)
	}
}

backgroundQueue.async(execute: infinitePrintWorkItem!)

backgroundQueue.asyncAfter(deadline: DispatchTime.now() + .seconds(secondsToPrint)) {
	print("infinitePrintWorkItem was canceled after \(secondsToPrint) seconds")
	infinitePrintWorkItem?.cancel()
}
