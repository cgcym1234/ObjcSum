//
//	JMSpecialTag.m
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "JMSpecialTag.h"

@interface JMSpecialTag ()
@end
@implementation JMSpecialTag




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[@"book"] isKindOfClass:[NSNull class]]){
		self.book = dictionary[@"book"];
	}	
	if(![dictionary[@"jm_owner"] isKindOfClass:[NSNull class]]){
		self.jmOwner = dictionary[@"jm_owner"];
	}	
	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	if(self.book != nil){
		dictionary[@"book"] = self.book;
	}
	if(self.jmOwner != nil){
		dictionary[@"jm_owner"] = self.jmOwner;
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
	if(self.book != nil){
		[aCoder encodeObject:self.book forKey:@"book"];
	}
	if(self.jmOwner != nil){
		[aCoder encodeObject:self.jmOwner forKey:@"jm_owner"];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.book = [aDecoder decodeObjectForKey:@"book"];
	self.jmOwner = [aDecoder decodeObjectForKey:@"jm_owner"];
	return self;

}
@end