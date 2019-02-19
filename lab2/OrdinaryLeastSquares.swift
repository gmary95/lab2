class OrdinaryLeastSquares {
    func calculateParameter(xMatrix:Matrix, yMatrix: Matrix) -> Matrix {
        var paramArray = Matrix([])
        let xTransponMatrix = xMatrix.transpose()
        let xAndXtransMatrix = xTransponMatrix * xMatrix
        let xAndXtransReverseMatrix = xAndXtransMatrix.inverse()
        let xAndXtransReverseAndXTransponMatrix = xAndXtransReverseMatrix * xTransponMatrix
        let xAndXtransReverseAndXTransponAndYMatrix =  xAndXtransReverseAndXTransponMatrix * yMatrix
        paramArray = xAndXtransReverseAndXTransponAndYMatrix
        return paramArray
    }
    
   
}
