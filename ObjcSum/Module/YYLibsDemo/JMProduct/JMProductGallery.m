//
//	JMProductGallery.m
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "JMProductGallery.h"

@interface JMProductGallery ()
@end
@implementation JMProductGallery




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[@"rgb"] isKindOfClass:[NSNull class]]){
		self.rgb = dictionary[@"rgb"];
	}	
	if(![dictionary[@"url"] isKindOfClass:[NSNull class]]){
		self.url = [[JMDetail alloc] initWithDictionary:dictionary[@"url"]];
	}

	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	if(self.rgb != nil){
		dictionary[@"rgb"] = self.rgb;
	}
	if(self.url != nil){
		dictionary[@"url"] = [self.url toDictionary];
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
	if(self.rgb != nil){
		[aCoder encodeObject:self.rgb forKey:@"rgb"];
	}
	if(self.url != nil){
		[aCoder encodeObject:self.url forKey:@"url"];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.rgb = [aDecoder decodeObjectForKey:@"rgb"];
	self.url = [aDecoder decodeObjectForKey:@"url"];
	return self;

}
@end