//
//	JMSize.m
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "JMSize.h"

@interface JMSize ()
@end
@implementation JMSize




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[@"name"] isKindOfClass:[NSNull class]]){
		self.name = dictionary[@"name"];
	}	
	if(![dictionary[@"refund_policy"] isKindOfClass:[NSNull class]]){
		self.refundPolicy = dictionary[@"refund_policy"];
	}	
	if(![dictionary[@"sku"] isKindOfClass:[NSNull class]]){
		self.sku = dictionary[@"sku"];
	}	
	if(![dictionary[@"stock"] isKindOfClass:[NSNull class]]){
		self.stock = dictionary[@"stock"];
	}	
	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	if(self.name != nil){
		dictionary[@"name"] = self.name;
	}
	if(self.refundPolicy != nil){
		dictionary[@"refund_policy"] = self.refundPolicy;
	}
	if(self.sku != nil){
		dictionary[@"sku"] = self.sku;
	}
	if(self.stock != nil){
		dictionary[@"stock"] = self.stock;
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
	if(self.name != nil){
		[aCoder encodeObject:self.name forKey:@"name"];
	}
	if(self.refundPolicy != nil){
		[aCoder encodeObject:self.refundPolicy forKey:@"refund_policy"];
	}
	if(self.sku != nil){
		[aCoder encodeObject:self.sku forKey:@"sku"];
	}
	if(self.stock != nil){
		[aCoder encodeObject:self.stock forKey:@"stock"];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.name = [aDecoder decodeObjectForKey:@"name"];
	self.refundPolicy = [aDecoder decodeObjectForKey:@"refund_policy"];
	self.sku = [aDecoder decodeObjectForKey:@"sku"];
	self.stock = [aDecoder decodeObjectForKey:@"stock"];
	return self;

}
@end