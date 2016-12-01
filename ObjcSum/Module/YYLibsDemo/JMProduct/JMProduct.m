//
//	JMProduct.m
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "JMProduct.h"

@interface JMProduct ()
@end
@implementation JMProduct




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[@"action"] isKindOfClass:[NSNull class]]){
		self.action = dictionary[@"action"];
	}	
	if(![dictionary[@"code"] isKindOfClass:[NSNull class]]){
		self.code = dictionary[@"code"];
	}	
	if(![dictionary[@"data"] isKindOfClass:[NSNull class]]){
		self.data = [[JMData alloc] initWithDictionary:dictionary[@"data"]];
	}

	if(![dictionary[@"extra"] isKindOfClass:[NSNull class]]){
		self.extra = [[JMExtra alloc] initWithDictionary:dictionary[@"extra"]];
	}

	if(![dictionary[@"message"] isKindOfClass:[NSNull class]]){
		self.message = dictionary[@"message"];
	}	
	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	if(self.action != nil){
		dictionary[@"action"] = self.action;
	}
	if(self.code != nil){
		dictionary[@"code"] = self.code;
	}
	if(self.data != nil){
		dictionary[@"data"] = [self.data toDictionary];
	}
	if(self.extra != nil){
		dictionary[@"extra"] = [self.extra toDictionary];
	}
	if(self.message != nil){
		dictionary[@"message"] = self.message;
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
	if(self.action != nil){
		[aCoder encodeObject:self.action forKey:@"action"];
	}
	if(self.code != nil){
		[aCoder encodeObject:self.code forKey:@"code"];
	}
	if(self.data != nil){
		[aCoder encodeObject:self.data forKey:@"data"];
	}
	if(self.extra != nil){
		[aCoder encodeObject:self.extra forKey:@"extra"];
	}
	if(self.message != nil){
		[aCoder encodeObject:self.message forKey:@"message"];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.action = [aDecoder decodeObjectForKey:@"action"];
	self.code = [aDecoder decodeObjectForKey:@"code"];
	self.data = [aDecoder decodeObjectForKey:@"data"];
	self.extra = [aDecoder decodeObjectForKey:@"extra"];
	self.message = [aDecoder decodeObjectForKey:@"message"];
	return self;

}
@end