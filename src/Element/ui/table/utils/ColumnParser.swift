import Cocoa
@testable import Utils

class ColumnParser {
    /**
     * Returns the indices in a a spessific sort order
     */
    static func sortOrder(_ column:Column,_ isAscending:Bool)->[Int] {
        let list: IList = column.list
        let children:[SelectTextButton] = NSViewParser.childrenOfType(list.lableContainer!, SelectTextButton.self)
        var sortList:[[String:Any]] = []//Swift 3 update, use Any instead of AnyObject
        for selectTextButton  in children {
            sortList.append(["text":selectTextButton.text.getText() != "" ? selectTextButton.text.getText() : "~","index":list.lableContainer!.indexOf(selectTextButton)])
        }
        if(isAscending){
            sortList.sort(by: {$0["text"] as! String > $1["text"] as! String})
        }else{
            sortList.sort(by: {$1["text"] as! String > $0["text"] as! String})
        }
        var indices:Array<Int> = []
        for i in 0..<sortList.count{//<--swift 3.0 for-loop support
            indices.append(sortList[i]["index"] as! Int)
        }
        return indices
    }
}
