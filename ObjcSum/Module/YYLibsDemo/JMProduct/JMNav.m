//
//	JMNav.m
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "JMNav.h"

@interface JMNav ()
@end
@implementation JMNav




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[@"default"] isKindOfClass:[NSNull class]]){
		self.defaultField = dictionary[@"default"];
	}	
	if(![dictionary[@"wifi"] isKindOfClass:[NSNull class]]){
		self.wifi = dictionary[@"wifi"];
	}	
	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	if(self.defaultField != nil){
		dictionary[@"default"] = self.defaultField;
	}
	if(self.wifi != nil){
		dictionary[@"wifi"] = self.wifi;
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
	if(self.defaultField != nil){
		[aCoder encodeObject:self.defaultField forKey:@"default"];
	}
	if(self.wifi != nil){
		[aCoder encodeObject:self.wifi forKey:@"wifi"];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.defaultField = [aDecoder decodeObjectForKey:@"default"];
	self.wifi = [aDecoder decodeObjectForKey:@"wifi"];
	return self;

}
@end