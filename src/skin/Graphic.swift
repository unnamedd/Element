import Foundation
/*
* The graphic class is an Element DataObject class that holds the lineshape, lineStyle and fillStyle
* // :TODO: possibly get rid of the setters for the fillStyle and Line style and use implicit setFillStyle and setLineStyle?
* NOTE: We dont need a line mask, just subclass the Graphics class so it supports masking of the line aswell (will require some effort)
*/
class Graphic:IGraphic{//this will extend Graphics in the future or just have it
    var fillStyle:IFillStyle?
    var lineStyle:ILineStyle?
    var graphics:Graphics
    var path:CGPath = CGPathCreateMutable()
    //var linePath:CGPath = CGPathCreateMutable()
    //var lineOffsetType:OffsetType
    init(_ fillStyle:IFillStyle? = nil, _ lineStyle:ILineStyle? = nil/*, _ lineOffsetType:OffsetType = OffsetType()*/){
        self.fillStyle = fillStyle
        self.lineStyle = lineStyle
        /*self.lineOffsetType = lineOffsetType*/
        graphics = Graphics()
        CGContextSaveGState(graphics.context);
    }
    func setPosition(position:CGPoint){
        //TODO:translate the graphics to position
        CGPathModifier.translate(&path,position.x,position.y)//Transformations
    }
    func setProperties(fillStyle:IFillStyle? = nil, lineStyle:ILineStyle? = nil){// :TODO: remove this and replace with setLineStyle and setFillStyle ?
        self.fillStyle = fillStyle;
        self.lineStyle = lineStyle;
    }
}