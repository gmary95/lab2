import Foundation

class FunctionHelper {
    func calcArgument(x: Double) -> Double {
        return 1.0 / x
    }
    
    func transformToX(arg: Double) -> Double {
        return 1.0 / arg
    }
    
    func calcuLateRegression(x: Double, b: Array<Double>) -> Double {
        let n = b.count
        var sum = 0.0
        for i in 0 ..< n {
            sum += b[i] * pow(1.0 / x, Double(i))
        }
        return sum
    }
}
