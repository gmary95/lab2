import Foundation

struct Interval {
    public var min: Double
    public var max: Double
}

struct Characteristic {
    public var value: Double
    public var standartDeviation: Double
    public var confidenceInterval: Interval
}

struct  QuantitativeCharacteristics {
    public var arithmeticMean: Characteristic
    public var variance: Characteristic
    public var skewness: Characteristic
    public var kurtosis: Characteristic
}

class Selection {
    public var data: Array<Double>
    public var count: Int
    public var order: Int
    
    init() {
        self.data = Array<Double>()
        self.count = 0
        self.order = 1
    }
    
    init(order: Int, capacity: Int)
    {
        if order < 1 {
            print("Order should be an integer number greater than zero!")
        }
        
        self.data = Array<Double>()
        self.count = capacity
        self.order = order
        
        for _ in 0 ..< self.count {
            data.append(0.0)
        }
    }
    
    subscript(index: Int) -> Double {
        get
        {
            if ((index >= 0) && (index < self.count)) {
                return (self.data[index])
            } else {
                print("Ivalid index!")
            }
            return 0.0
        }
        set
        {
            data[index] = newValue
        }
    }
    
    
    public func append() {
        data.append(0.0)
        
        count += 1
    }
    
    public func append(item: Double) {
        data.append(item)
        
        count += 1
    }
    
    public func arithmeticMean() -> Double {
        var result: Double
        var sum: Double
        
        sum = 0
        for item in data {
            sum += item
        }
        
        result = sum / Double(data.count)
        
        return result
    }
    
    public func variance() -> Double {
        var result: Double
        var sum: Double
        var arithMeam: Double
        
        arithMeam = arithmeticMean()
        
        sum = 0
        for item in data {
            sum += pow((item - arithMeam), 2)
        }
        
        result = sum / Double((data.count - 1))
        
        return (result);
    }
    
    private func _variance() -> Double {
        var result: Double
        var sum: Double
        var arithMeam: Double
        
        arithMeam = arithmeticMean()
        
        sum = 0
        for item in data {
            sum += pow(item, 2) - pow(arithMeam, 2)
        }
        
        result = sum / Double(data.count)
        
        return result
    }
    
    public func Skewness() -> Double {
        var result: Double
        var sum: Double
        var arithMeam: Double
        var variance: Double
        var _a: Double
        
        arithMeam = arithmeticMean()
        variance = pow(_variance(), 1.0 / 2.0)
        
        sum = 0
        for item in data {
            sum += pow((item - arithMeam), 3.0)
        }
        
        _a = sum / (Double(data.count) * pow(variance, 3.0))
        
        result = _a * (sqrt(Double(data.count * (data.count - 1))) / Double(data.count - 2))
        
        return result
    }
    
    public func Kurtosis() -> Double {
        var result: Double
        var sum: Double
        var arithMeam: Double
        var variance: Double
        var _e: Double
        
        arithMeam = arithmeticMean();
        variance = pow(_variance(), 1.0 / 2.0);
        
        sum = 0
        for item in data {
            sum += pow((item - arithMeam), 4.0)
        }
        
        _e = sum / (Double(data.count) * pow(variance, 4.0))
        
        result = ((pow(Double(data.count), 2.0) - 1) / Double((data.count - 2) * (data.count - 3))) * ((_e - 3) + (6 / Double(data.count + 1)))
        
        return result
    }
    
    
    public static func getDisp(dH: (Double, Double), dX: (Double, Double), cov: Double) -> Double {
        var result = 0.0
        result = pow(dH.0, 2) * dX.0 + pow(dH.1, 2) * dX.1 + 2 * dH.0 * dH.1 * cov
        return result
    }
}
