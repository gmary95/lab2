import Cocoa
import Charts

class MainViewController: NSViewController {
    @IBOutlet weak var mainTableView: NSTableView!
    @IBOutlet weak var seriesChart: LineChartView!
    @IBOutlet weak var minSquareMeanLabel: NSTextFieldCell!
    
    
    let xArray = [1, 1.5, 2, 2.5, 3, 3.5, 4, 4.5, 5, 5.5, 6, 6.5, 7, 7.5, 8, 8.5]
    let yArray = [14, 18.222, 18, 17.216, 16.444, 15.778, 15.219, 14.749, 14.352, 14.014, 13.722, 13.469, 13.248, 13.052, 12.879, 12.724]
    let minSquareText = "sum((Yreg -Y)^2) = "
    
    var xSelection: Selection!
    var ySelection: Selection!
    var yregSelection: Selection!
    var yreg_ySelection: Selection!
    var yreg_y2Selection: Selection!
    
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
        let xMatrix = Matrix
        let yMatrix = Matrix
        OrdinaryLeastSquares().calculateParameter(xMatrix: xMatrix, yMatrix: yMatrix)
        
        mainTableView.reloadData()
        
        minSquareMeanLabel.title = minSquareText
    }
}

extension MainViewController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        if tableView == mainTableView {
            let numberOfRows:Int = xSelection.count
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
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if tableView == mainTableView {
            return self.loadSelection(tableView, viewFor: tableColumn, row: row)
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
                text = "\(ySelection[row].rounded(toPlaces: 6))"
                cellIdentifier = CellIdentifiersSelectionTable.YregCell
            }
        } else if tableColumn == tableView.tableColumns[3] {
            if yreg_ySelection.count > 0 {
                text = "\(ySelection[row].rounded(toPlaces: 6))"
                cellIdentifier = CellIdentifiersSelectionTable.Yreg_YCell
            }
        } else if tableColumn == tableView.tableColumns[4] {
            if yreg_y2Selection.count > 0 {
                text = "\(ySelection[row].rounded(toPlaces: 6))"
                cellIdentifier = CellIdentifiersSelectionTable.Yreg_Y2Cell
            }
        }
        
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
            return cell
        }
        return nil
    }
}

