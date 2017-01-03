//
//	JMShareInfo.m
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "JMShareInfo.h"

@interface JMShareInfo ()
@end
@implementation JMShareInfo




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[@"image_url_set"] isKindOfClass:[NSNull class]]){
		self.imageUrlSet = [[JMImageUrlSet alloc] initWithDictionary:dictionary[@"image_url_set"]];
	}

	if(![dictionary[@"link"] isKindOfClass:[NSNull class]]){
		self.link = dictionary[@"link"];
	}	
	if(![dictionary[@"platform"] isKindOfClass:[NSNull class]]){
		self.platform = dictionary[@"platform"];
	}	
	if(![dictionary[@"text"] isKindOfClass:[NSNull class]]){
		self.text = dictionary[@"text"];
	}	
	if(![dictionary[@"title"] isKindOfClass:[NSNull class]]){
		self.title = dictionary[@"title"];
	}	
	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	if(self.imageUrlSet != nil){
		dictionary[@"image_url_set"] = [self.imageUrlSet toDictionary];
	}
	if(self.link != nil){
		dictionary[@"link"] = self.link;
	}
	if(self.platform != nil){
		dictionary[@"platform"] = self.platform;
	}
	if(self.text != nil){
		dictionary[@"text"] = self.text;
	}
	if(self.title != nil){
		dictionary[@"title"] = self.title;
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
	if(self.imageUrlSet != nil){
		[aCoder encodeObject:self.imageUrlSet forKey:@"image_url_set"];
	}
	if(self.link != nil){
		[aCoder encodeObject:self.link forKey:@"link"];
	}
	if(self.platform != nil){
		[aCoder encodeObject:self.platform forKey:@"platform"];
	}
	if(self.text != nil){
		[aCoder encodeObject:self.text forKey:@"text"];
	}
	if(self.title != nil){
		[aCoder encodeObject:self.title forKey:@"title"];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.imageUrlSet = [aDecoder decodeObjectForKey:@"image_url_set"];
	self.link = [aDecoder decodeObjectForKey:@"link"];
	self.platform = [aDecoder decodeObjectForKey:@"platform"];
	self.text = [aDecoder decodeObjectForKey:@"text"];
	self.title = [aDecoder decodeObjectForKey:@"title"];
	return self;

}
@end