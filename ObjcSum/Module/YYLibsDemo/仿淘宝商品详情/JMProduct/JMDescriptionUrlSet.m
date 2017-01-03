//
//	JMDescriptionUrlSet.m
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "JMDescriptionUrlSet.h"

@interface JMDescriptionUrlSet ()
@end
@implementation JMDescriptionUrlSet




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[@"detail"] isKindOfClass:[NSNull class]]){
		self.detail = [[JMDetail alloc] initWithDictionary:dictionary[@"detail"]];
	}

	if(![dictionary[@"pictures"] isKindOfClass:[NSNull class]]){
		self.pictures = [[JMDetail alloc] initWithDictionary:dictionary[@"pictures"]];
	}

	if(![dictionary[@"product"] isKindOfClass:[NSNull class]]){
		self.product = [[JMDetail alloc] initWithDictionary:dictionary[@"product"]];
	}

	if(![dictionary[@"union"] isKindOfClass:[NSNull class]]){
//		self.union = [[JMDetail alloc] initWithDictionary:dictionary[@"union"]];
	}

	if(![dictionary[@"usage"] isKindOfClass:[NSNull class]]){
		self.usage = [[JMDetail alloc] initWithDictionary:dictionary[@"usage"]];
	}

	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	if(self.detail != nil){
		dictionary[@"detail"] = [self.detail toDictionary];
	}
	if(self.pictures != nil){
		dictionary[@"pictures"] = [self.pictures toDictionary];
	}
	if(self.product != nil){
		dictionary[@"product"] = [self.product toDictionary];
	}
//	if(self.union != nil){
//		dictionary[@"union"] = [self.union toDictionary];
//	}
	if(self.usage != nil){
		dictionary[@"usage"] = [self.usage toDictionary];
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
	if(self.detail != nil){
		[aCoder encodeObject:self.detail forKey:@"detail"];
	}
	if(self.pictures != nil){
		[aCoder encodeObject:self.pictures forKey:@"pictures"];
	}
	if(self.product != nil){
		[aCoder encodeObject:self.product forKey:@"product"];
	}
//	if(self.union != nil){
//		[aCoder encodeObject:self.union forKey:@"union"];
//	}
	if(self.usage != nil){
		[aCoder encodeObject:self.usage forKey:@"usage"];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.detail = [aDecoder decodeObjectForKey:@"detail"];
	self.pictures = [aDecoder decodeObjectForKey:@"pictures"];
	self.product = [aDecoder decodeObjectForKey:@"product"];
//	self.union = [aDecoder decodeObjectForKey:@"union"];
	self.usage = [aDecoder decodeObjectForKey:@"usage"];
	return self;

}
@end
