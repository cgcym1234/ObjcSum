//
//	JMExtDesc.m
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "JMExtDesc.h"

@interface JMExtDesc ()
@end
@implementation JMExtDesc




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[@"discount"] isKindOfClass:[NSNull class]]){
		self.discount = dictionary[@"discount"];
	}	
	if(![dictionary[@"price_bottom"] isKindOfClass:[NSNull class]]){
		self.priceBottom = dictionary[@"price_bottom"];
	}	
	if(![dictionary[@"sku_button"] isKindOfClass:[NSNull class]]){
		self.skuButton = dictionary[@"sku_button"];
	}	
	if(![dictionary[@"sku_title"] isKindOfClass:[NSNull class]]){
		self.skuTitle = dictionary[@"sku_title"];
	}	
	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	if(self.discount != nil){
		dictionary[@"discount"] = self.discount;
	}
	if(self.priceBottom != nil){
		dictionary[@"price_bottom"] = self.priceBottom;
	}
	if(self.skuButton != nil){
		dictionary[@"sku_button"] = self.skuButton;
	}
	if(self.skuTitle != nil){
		dictionary[@"sku_title"] = self.skuTitle;
	}
	return dictionary;

}

/**
 * Implementation of NSCoding encoding method
 */
/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
- (void)encodeWithCoder:(NSCoder *)aCoder
{
	if(self.discount != nil){
		[aCoder encodeObject:self.discount forKey:@"discount"];
	}
	if(self.priceBottom != nil){
		[aCoder encodeObject:self.priceBottom forKey:@"price_bottom"];
	}
	if(self.skuButton != nil){
		[aCoder encodeObject:self.skuButton forKey:@"sku_button"];
	}
	if(self.skuTitle != nil){
		[aCoder encodeObject:self.skuTitle forKey:@"sku_title"];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.discount = [aDecoder decodeObjectForKey:@"discount"];
	self.priceBottom = [aDecoder decodeObjectForKey:@"price_bottom"];
	self.skuButton = [aDecoder decodeObjectForKey:@"sku_button"];
	self.skuTitle = [aDecoder decodeObjectForKey:@"sku_title"];
	return self;

}
@end