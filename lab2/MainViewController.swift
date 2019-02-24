import Cocoa
import Charts

class MainViewController: NSViewController {
    @IBOutlet weak var mainTableView: NSTableView!
    @IBOutlet weak var bTableView: NSTableView!
    @IBOutlet weak var seriesChart: LineChartView!
    @IBOutlet weak var minSquareMeanLabel: NSTextFieldCell!
    @IBOutlet weak var R2MeanLabel: NSTextFieldCell!
    @IBOutlet weak var NText: NSTextFieldCell!
    
    
    let xArray = [1, 1.5, 2, 2.5, 3, 3.5, 4, 4.5, 5, 5.5, 6, 6.5, 7, 7.5, 8, 8.5]
    let yArray = [14, 18.222, 18, 17.216, 16.444, 15.778, 15.219, 14.749, 14.352, 14.014, 13.722, 13.469, 13.248, 13.052, 12.879, 12.724]
    let helper = FunctionHelper()
    let minSquareText = "sum((Yreg -Y)^2) = "
    let RText = "R2 = "
    
    var xSelection: Selection!
    var ySelection: Selection!
    var yregSelection: Selection!
    var yreg_ySelection: Selection!
    var yreg_y2Selection: Selection!
    var b = Array<Double>()
    var bMin = Array<Double>()
    var bMax = Array<Double>()
     var t = Array<Double>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.seriesChart.noDataTextColor = .white
        
        xSelection = Selection(order: 1, capacity: xArray.count)
        xSelection.data = xArray
        
        ySelection = Selection(order: 1, capacity: yArray.count)
        ySelection.data = yArray
        
        yregSelection = Selection()
        yreg_ySelection = Selection()
        yreg_y2Selection = Selection()
    }
    
    @IBAction func calculateAllCharacteristics(_ sender: Any) {
        let n = Int(NText.title)
        let xMatrix = createXMatrix(n: n ?? 2)
        let yMatrix = createYMatrix()
        let bMatrix = OrdinaryLeastSquares().calculateParameter(xMatrix: xMatrix, yMatrix: yMatrix)
        b = transformBMatrixToArray(b: bMatrix)
        
        yregSelection = Selection(order: 1, capacity: yArray.count)
        yregSelection.data = loadYreg(b: b)
        
        yreg_ySelection = Selection(order: 1, capacity: yArray.count)
        yreg_ySelection.data = loadYreg_Y()
        
        yreg_y2Selection = Selection(order: 1, capacity: yArray.count)
        yreg_y2Selection.data = loadYreg_Y2()
        
        let d = OrdinaryLeastSquares().calculateDerivation(xMatrix: xMatrix, yreg_y2: yreg_y2Selection)
        let bMinMatrix = bMatrix - d
        let bMaxMatrix = bMatrix + d
        bMin = transformBMatrixToArray(b: bMinMatrix)
        bMax = transformBMatrixToArray(b: bMaxMatrix)
        t = OrdinaryLeastSquares().resultParam(xMatrix: xMatrix, yreg_y2: yreg_y2Selection, b: b)
        
        let sum = calcSum()
        let yAv = ySelection.arithmeticMean()
        let R2 = DeterminationHelper.calcCreteria(y: ySelection, yReg: yregSelection, yAv: yAv)
        representChart(series: yregSelection, chart: seriesChart)
        
        mainTableView.reloadData()
        bTableView.reloadData()
        
        minSquareMeanLabel.title = minSquareText + sum.rounded(toPlaces: 6).description
        R2MeanLabel.title = RText + R2.rounded(toPlaces: 6).description
    }
    
    func representChart(series: Selection, chart: LineChartView){
        var chartSet = Array<ChartDataEntry>()
        for i in 0 ..< series.count {
            chartSet.append(ChartDataEntry(x: Double(i), y: series[i]))
        }
        
        let data = LineChartData()
        let dataSet = LineChartDataSet(values: chartSet, label: "F(x, B)")
        dataSet.colors = [NSUIColor.yellow]
        dataSet.valueColors = [NSUIColor.white]
        data.addDataSet(dataSet)
        
        chart.data = data
        
        chart.gridBackgroundColor = .red
        chart.legend.textColor = .white
        chart.xAxis.labelTextColor = .white
        chart.leftAxis.labelTextColor = .white
        chart.rightAxis.labelTextColor = .white
    }
    
    func createXMatrix(n: Int) -> Matrix {
        var x = Matrix(rows: xSelection.count, columns: n, repeatedValue: 0)
        var array = [[Double]]()
        for i in 0 ..< x.rows {
            var xArr = [Double]()
            for j in 0..<x.columns {
                xArr.append(pow(helper.calcArgument(x: xSelection[i]), Double(j)))
            }
            array.append(xArr)
        }
        x = Matrix(array)
        return x
    }
    
    func createYMatrix() -> Matrix {
        var y = Matrix(rows: ySelection.count, columns: 1, repeatedValue: 0)
        var array = [[Double]]()
        for i in 0 ..< y.rows {
            array.append([ySelection[i]])
        }
        y = Matrix(array)
        return y
    }
    
    func transformBMatrixToArray(b: Matrix) -> [Double] {
        var array = [Double]()
        for i in 0 ..< b.rows {
            array.append(b.array[i][0])
        }
        return array
    }
    
    func loadYreg(b: [Double]) -> [Double] {
        var y = [Double]()
        for i in 0 ..< xSelection.count {
            y.append(helper.calcuLateRegression(x: xSelection[i], b: b).rounded(toPlaces: 6))
        }
        return y
    }
    
    func loadYreg_Y() -> [Double] {
        var dif = [Double]()
        for i in 0 ..< ySelection.count {
            dif.append((yregSelection[i] - ySelection[i]).rounded(toPlaces: 6))
        }
        return dif
    }
    
    func loadYreg_Y2() -> [Double] {
        var arr = [Double]()
        for i in 0 ..< ySelection.count {
            arr.append(pow(yreg_ySelection[i], 2.0).rounded(toPlaces: 6))
        }
        return arr
    }
    
    func calcSum() -> Double {
        var sum = 0.0
        for i in 0 ..< yreg_y2Selection.count {
            sum += yreg_y2Selection[i]
        }
        return sum
    }
}

extension MainViewController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        if tableView == mainTableView {
            let numberOfRows:Int = xSelection.count
            return numberOfRows
        }
        if tableView == bTableView {
            let numberOfRows:Int = b.count
            return numberOfRows
        }
        return 1
    }
}

extension MainViewController: NSTableViewDelegate {
    
    fileprivate enum CellIdentifiersSelectionTable {
        static let XCell = "XID"
        static let YCell = "YID"
        static let YregCell = "YregID"
        static let Yreg_YCell = "Yreg_YID"
        static let Yreg_Y2Cell = "Yreg_Y2ID"
    }
    
    fileprivate enum CellIdentifiersBTable {
        static let BCell = "BID"
        static let BMinCell = "BMinID"
        static let BMaxCell = "BMaxID"
        static let tCell = "tID"
        static let tkrCell = "tkrID"
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if tableView == mainTableView {
            return self.loadSelection(tableView, viewFor: tableColumn, row: row)
        }
        if tableView == bTableView {
            return self.loadParam(tableView, viewFor: tableColumn, row: row)
        }
        return nil
    }
    
    func loadSelection(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSTableCellView? {
        
        var text: String = ""
        var cellIdentifier: String = ""
        
        if tableColumn == tableView.tableColumns[0] {
            if xSelection.count > 0 {
                text = "\(xSelection[row].rounded(toPlaces: 6))"
                cellIdentifier = CellIdentifiersSelectionTable.XCell
            }
        } else if tableColumn == tableView.tableColumns[1] {
            if ySelection.count > 0 {
                text = "\(ySelection[row].rounded(toPlaces: 6))"
                cellIdentifier = CellIdentifiersSelectionTable.YCell
            }
        } else if tableColumn == tableView.tableColumns[2] {
            if yregSelection.count > 0 {
                text = "\(yregSelection[row].rounded(toPlaces: 6))"
                cellIdentifier = CellIdentifiersSelectionTable.YregCell
            }
        } else if tableColumn == tableView.tableColumns[3] {
            if yreg_ySelection.count > 0 {
                text = "\(yreg_ySelection[row].rounded(toPlaces: 6))"
                cellIdentifier = CellIdentifiersSelectionTable.Yreg_YCell
            }
        } else if tableColumn == tableView.tableColumns[4] {
            if yreg_y2Selection.count > 0 {
                text = "\(yreg_y2Selection[row].rounded(toPlaces: 6))"
                cellIdentifier = CellIdentifiersSelectionTable.Yreg_Y2Cell
            }
        }
        
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
            return cell
        }
        return nil
    }
    
    func loadParam(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSTableCellView? {
        
        var text: String = ""
        var cellIdentifier: String = ""
        
        if tableColumn == tableView.tableColumns[0] {
            if b.count > 0 {
                text = "\(b[row].rounded(toPlaces: 6))"
                cellIdentifier = CellIdentifiersBTable.BCell
            }
        } else if tableColumn == tableView.tableColumns[1] {
            if bMin.count > 0 {
                text = "\(bMin[row].rounded(toPlaces: 6))"
                cellIdentifier = CellIdentifiersBTable.BMinCell
            }
        } else if tableColumn == tableView.tableColumns[2] {
            if bMax.count > 0 {
                text = "\(bMax[row].rounded(toPlaces: 6))"
                cellIdentifier = CellIdentifiersBTable.BMaxCell
            }
        }
//        } else if tableColumn == tableView.tableColumns[3] {
//            if t.count > 0 {
//                text = "\(t[row].rounded(toPlaces: 6))"
//                cellIdentifier = CellIdentifiersBTable.tCell
//            }
//        } else if tableColumn == tableView.tableColumns[4] {
//            let p = 0.05
//            let v = (yreg_y2Selection.count - b.count - 1)
//            let tkr = Quantil.StudentQuantil(p: p, v: Double(v))
//                text = "\(tkr.rounded(toPlaces: 6))"
//                cellIdentifier = CellIdentifiersBTable.tkrCell
//        }
        
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
            return cell
        }
        return nil
    }
}

