import Foundation
/**
 * @Note this is a basic Table, its not fully featured yet
 * // :TODO: Obviously more stuff need to be added To TableModifier and TableParser  this is just the basic design, we need to connect the database to update the table on changes to the database etc
 * // :TODO: create ScrollTable.as in the future, consider how columns will work though?, since they containe a List instance which is has its own mask and height, how do we begin to scroll all of them in tandem? do we redesign column to contain selectButtons and remove list? Think  it through and draw it out on paper
 * // :TODO: Table header needs to be a SelectableCheckButton, since it needs both be selectable and checkable
 */
class Table:Element{
    private var node:Node
    private var columns:Array<Column> = []
    private var columnContainer:Container?
    init(_ width:CGFloat, _ height:CGFloat, _ node:Node, _ parent:IElement? = nil, _ id:String = "") {
        self.node = node
        super.init(width,height,parent,id)
        
    }
    override func resolveSkin() {
        super.resolveSkin()
        columnContainer = addSubView(Container(width,height,self,"column"))
        let childCount:Int = node.xml.children!.count
        for var i = 0; i < childCount; ++i{
            var child : XMLNode = _database.xml.children[i]
            var itemData = XMLParser.attributes(child)
            if(itemData["hasChildren"] || child.children().length() > 0) columns.append(columnContainer.addSubView(Column(NaN,NaN,itemData["title"],DataProvider(child),columnContainer,String(i))))/*we add the columns index to the id so we can set individual css properties to each column*/
        }
    }
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
}
