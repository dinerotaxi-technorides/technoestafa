package com
import com.Product
class Catalog {
	static belongsTo = [parent:Catalog];
	static hasMany = [children:Catalog,product:Product,orderDetails:com.OrderDetails];
	String name;
	String description;

	static constraints = {
		parent(nullable: true);
		name(nullable:false,blank:false,maxSize:50)
		description(nullable:true,blank:true,maxSize:5000)
//		price (nullable:true ,validator: { val, obj ->
//			if((!val && !obj.parent )|| ( val && obj.parent)||( !val && obj.parent && obj?.parent?.price)||( !val && obj.parent && obj?.parent?.parent?.price)){
//				return true
//			}else{
//				return false
//			}
//		})
	}
	String toString(){
		return name
	}
}