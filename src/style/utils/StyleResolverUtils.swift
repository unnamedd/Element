import Foundation

class StyleResolverUtils {
    /**
     * Return an array of WeightedStyle instances
     * @Note while loading the Basic.css flat structure queries 97656  vs treestructure queries 13324 (this is why we use a treestructure querey technique)
     */
    static func query(querySelectors:[ISelector],_ searchTree:[String:Any],_ cursor:Int = 0) -> [IStyle]{
        var styles:[IStyle] = []
        for key in searchTree.keys {
            //print("key: " + key + " object: "+searchTree[key] + " at cursor: "+cursor);
            if(key == "style") {styles.append(searchTree[key] as! IStyle)}
            else{
                for (var i : Int = cursor; i < querySelectors.count; i++) {
                    var querySelector:ISelector = querySelectors[i]
                    if(key == querySelector.element){
                        //print("matching element found, keep digging deeper");
                        let result:[IStyle] = query(querySelectors, searchTree[key] as! [String:Any],i+1)
                        if(result.count > 0) {styles += result}
                    }
                }
            }
        }
        return styles
    }
}
