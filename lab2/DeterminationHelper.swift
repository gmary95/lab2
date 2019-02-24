import Foundation

class DeterminationHelper {    
    static func calcVar(y: Selection, yAv: Double) -> Double {
        var sum = 0.0
        y.data.forEach {
            sum += pow($0 - yAv, 2.0)
        }
        return sum / Double(y.count - 1)
    }
    
    static func calcCreteria(y: Selection, yReg: Selection, yAv: Double) -> Double {
        let varY = calcVar(y: y, yAv: yAv)
        let varYreg = calcVar(y: yReg, yAv: yAv)
        let r = sqrt(varYreg / varY)
        return pow(r, 2.0)
    }
}
