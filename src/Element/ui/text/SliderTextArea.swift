import Cocoa
@testable import Utils
/**
 * 13.05.21 15:00 - Added support for mousewheel, and replaced scrollbars with sliders
 * NOTE: it seems difficult to align the HSlider thumb in a relative but correct way, since offsetting the HSlider it self is difficult when thumb is positioned by absolute values
 * TODO: ⚠️️ could possible use a setHtmlText function??!?
 * TODO: ⚠️️ you may need to access gestures to get hold of horzontal mouse delta, when you want to use gestures to scroll horizontally
 * TODO: ⚠️️ the horizontal scroller isn't thourghouly testes. Make sure you set wordwrap to false to test this, and that the input text has break tags \n or br tags
 * TODO: ⚠️️ Impliment a failsafe so that the slider.thumb doesnt get smaller than its width, do the same for both sliders
 */
class SliderTextArea:TextArea{
    let linesPerScroll:UInt = 1/*The number of lines the scroller scrolls at every scroll up or down*/// :TODO: this cant be set higher unless you add code to the eventhandlers that allow it
    var scrollBarSize:CGFloat//TODO: ⚠️️ rename to: scrollBarThickness
    lazy var vSlider:Slider = createVSlider()
    lazy var hSlider:Slider? = createHSlider()
	var vSliderInterval:Int?
	var hInterval:Int?
    init(text:String = "defaultText", scrollBarThickness:CGFloat = 24,size:CGSize,id:String? = nil) {
        self.scrollBarSize = scrollBarThickness
        super.init(text: text, size: size, id: id)
    }
	override func resolveSkin() {
		super.resolveSkin()
		_ = vSlider
        _ = hSlider
	}
	/**
	 * Updates the sizes of the h and v sliders
	 * TODO: ⚠️️ Can be further refactored
	 */
	func updateScrollBarThumbSizes() {
		let hSliderThumbWidth:CGFloat = Utils.hSliderThumbWidth(text.getTextField(), hSlider!)
		hSlider!.setThumbSide(hSliderThumbWidth)
		hInterval = Utils.hScrollBarInterpolation(text.getTextField())
		let verticalThumbSize:CGFloat =  Utils.vSliderThumbHeight(text.getTextField(), vSlider, linesPerScroll)
		vSlider.setThumbSide(verticalThumbSize)
		vSliderInterval = Utils.vSliderinterval(text.getTextField())
	}	
	func onSliderChange(_ event:SliderEvent){
		if(event.origin === vSlider) {
            //TextFieldModifier.vScrollTo(text.getTextField(), event.progress)
        }else {
            //TextFieldModifier.hScrollTo(text.getTextField(), event.progress)
        }
	}
	func onMouseWheel(_ event:MouseEvent) {
		let scrollAmount:CGFloat = 0//event.delta/vSliderInterval/*_scrollBar.interval*/;
		var currentScroll:CGFloat = vSlider.progress - scrollAmount/*the minus sign makes sure the scroll works like in OSX LION*/
		currentScroll = NumberParser.minMax(currentScroll, 0, 1)
		vSlider.setProgressValue(currentScroll)
		//TextFieldModifier.vScrollTo(text.getTextField(), currentScroll) /*Sets the target item to correct y, according to the current scrollBar progress*/
	}	
	override func onEvent(_ event:Event){
		if(event.type == SliderEvent.change || event.origin === vSlider){}
		else if(event.type == SliderEvent.change || event.origin === hSlider){}
		/*also listen for mouseWheel events*/
	}
	/**
	 * Returns "TextArea"
	 * NOTE: This function is used to find the correct class type when synthezing the element stack
	 */
	override func getClassType() -> String {
		return "\(TextArea.self)"
	}
	/**
	 * Sets the size of the ScrollTextArea
	 * NOTE: Horizontatal must be set first because of an unknown bug, if you do not use the maxScrollH before maxScrollV the maxScrollV gives old values (Adobe bug)
	 * TODO: ⚠️️ this may not work since thumbsizes is updated in sliders and in this class
	 */
	override func setSize(_ width:CGFloat, _ height:CGFloat) {
		super.setSize(width, height)
		hSlider!.setSize(width, scrollBarSize)
		vSlider.setSize(scrollBarSize, height)
		updateScrollBarThumbSizes()
	}
	override func setTextValue(_ text:String) {
		super.setTextValue(text)
		updateScrollBarThumbSizes()
	}
    required init(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    //dep
    init(_ width:CGFloat,_ height:CGFloat, _ text:String = "defaultText", _ scrollBarSize:CGFloat = 24, _ parent:ElementKind? = nil, _ id:String? = nil){
        self.scrollBarSize = scrollBarSize
        super.init(width,height,text,parent,id)
    }
}
private class Utils{
	static func vSliderinterval(_ textField:NSTextField) -> Int {
		let verticalInterval:Int = /*textField.maxScrollV*/ -1
		return verticalInterval
	}
	static func vSliderThumbHeight(_ textField:NSTextField, _ slider:Slider, _ linesPerScroll:UInt = 1) -> CGFloat {
		let numOfVisibleLines:Int = 0//(textField.numLines-textField.maxScrollV)
        _ = numOfVisibleLines
		let verticalScalar:CGFloat = 0//textField.maxScrollV == 1 ? 1:numOfVisibleLines/textField.numLines
//		var tempInterval:Int = textField.maxScrollV == 1 ? 1:textField.maxScrollV / linesPerScroll
		let verticalThumbSize:CGFloat = SliderParser.thumbSize(verticalScalar, slider.skinSize.h)
		return min(slider.skinSize.h,verticalThumbSize)/*the Math.min is a temp fix*/
	}
	static func hScrollBarInterpolation(_ textField:NSTextField, _ scrollDistance:CGFloat = 50) -> Int{
		return 0//textField.width >= textField.maxScrollH ? 0:textField.maxScrollH / scrollDistance
	}
	static func hSliderThumbWidth(_ textField:NSTextField, _ slider:Slider) -> CGFloat {
		let horizontalScalar:CGFloat = 0//textField.maxScrollH == 0 ? 1:textField.width/textField.maxScroll
        _ = horizontalScalar
//		var horizontalInterval:int = ScrollTextAreaUtil.hScrollBarInterpolation(textField);
		let horizontalThumbSize:CGFloat = 0//SliderParser.thumbSize(horizontalScalar, slider.width
		return min(slider.skinSize.w,horizontalThumbSize)/*the Math.min is a temp fix*/
	}
}
extension SliderTextArea{
    func createVSlider()->Slider{
        self.vSliderInterval = Utils.vSliderinterval(self.text.getTextField())
        let vSlider:Slider = self.addSubView(Slider(6/*_scrollBarSize*/,self.skinSize.h,.ver,CGSize(6,24),0,self))
        let vSliderThumbHeight:CGFloat = Utils.vSliderThumbHeight(self.text.getTextField(), vSlider, self.linesPerScroll)
        _ = vSliderThumbHeight
        vSlider.setThumbSide(45)
        return vSlider
        //vSlider.thumb.visible = SliderParser.assertSliderVisibility(vSliderThumbHeight/text.height)/*isVSliderVisible*/
    }
    func createHSlider() -> Slider?{
        
            //hInterval = Utils.hScrollBarInterpolation(text!.getTextField())
            //hSlider = addSubView(HSlider(width/*_scrollBarSize*/,24,24,0,self))
            //let hSliderThumbWidth:CGFloat = Utils.hSliderThumbWidth(text!.getTextField(), hSlider!)
            //hSlider!.setThumbWidthValue(hSliderThumbWidth)
            //hSlider.thumb.visible = SliderParser.assertSliderVisibility(hSliderThumbWidth/text.width)/*isHSliderVisible*/
            return nil
        
    }
}
