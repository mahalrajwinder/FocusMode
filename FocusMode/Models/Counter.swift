//
//  Copyright © 2020 Rajwinder Singh. All rights reserved.
//

struct Counter {
    private var initial: Int // seconds
    private var left: Int // seconds
    
    init(_ minutes: Int) {
        self.initial = minutes * 60
        self.left = minutes * 60
    }
    
    init(_ dictObj: [String: Int]) {
        self.initial = dictObj["initial"]!
        self.left = dictObj["left"]!
    }
}

// MARK: - Accessor Methods

extension Counter {
    func toDict() -> [String: Int] {
        return ["initial": initial,
                "left": left]
    }
    
    func toString() -> String {
        var seconds = left % 60
        var minutes = left / 60
        var hours = minutes / 60
        minutes %= 60
        
        var format = "%02d:%02d:%02d"
        if seconds < 0 || minutes < 0 || hours < 0 {
            format = "- %02d:%02d:%02d"
            seconds = abs(seconds)
            minutes = abs(minutes)
            hours = abs(hours)
        }
        return String(format: format, hours, minutes, seconds)
    }
    
    func used() -> Int {
        if left >= 0 {
            let offset = initial - left
            return offset / 60
        }
        return left / 60
    }
}

// MARK: - Mutator Methods

extension Counter {
    mutating func decrement() {
        self.left -= 1
    }
}
