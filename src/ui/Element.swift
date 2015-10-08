class Element{
	var skinState:String = "";/*protected*//*This is protected so that sub-classes can access it when setting the initial state*/
	var skin:Skin?
	var width:Number?
	var height:Number?
	var parent : IElement?
	var id : String;/*css selector id*/
	var classId : String;/*css selector class identifier*/
	/**
	 * 
	 */
	public func init(width:Number = NaN, height:Number = NaN, parent:IElement = nil, id:String = nil, classId:String = nil){
	
	}
	/**
	 * 
	 */
	public func resolveSkin(){/*protected*/
		
	}
	/**
	 * 
	 */
	func setSize(width:Number, height:Number){
		width = width;
		self.height = height;
		self.skin.setSize(width, height);
	}
}

//stub code for the Element class

/*
width
height
id
classId
skin
resolveSkin()//Resolves the skin that the this or the sub-class will use
getClassType()
*/

//getters and setters for all variables
//implicit getters and setters for some of the variables

//research how swift handles parent of objects, super.parent etc
//research why you need skinstate in the element class, test with a simple button