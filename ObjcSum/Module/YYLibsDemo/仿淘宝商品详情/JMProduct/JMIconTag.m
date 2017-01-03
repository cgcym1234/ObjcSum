//
//	JMIconTag.m
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "JMIconTag.h"

@interface JMIconTag ()
@end
@implementation JMIconTag




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[@"group_num"] isKindOfClass:[NSNull class]]){
		self.groupNum = dictionary[@"group_num"];
	}	
	if(![dictionary[@"label"] isKindOfClass:[NSNull class]]){
		self.label = dictionary[@"label"];
	}	
	if(![dictionary[@"name"] isKindOfClass:[NSNull class]]){
		self.name = dictionary[@"name"];
	}	
	if(![dictionary[@"status"] isKindOfClass:[NSNull class]]){
		self.status = dictionary[@"status"];
	}	
	if(![dictionary[@"text"] isKindOfClass:[NSNull class]]){
		self.text = dictionary[@"text"];
	}	
	if(![dictionary[@"url_tag"] isKindOfClass:[NSNull class]]){
		self.urlTag = dictionary[@"url_tag"];
	}	
	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	if(self.groupNum != nil){
		dictionary[@"group_num"] = self.groupNum;
	}
	if(self.label != nil){
		dictionary[@"label"] = self.label;
	}
	if(self.name != nil){
		dictionary[@"name"] = self.name;
	}
	if(self.status != nil){
		dictionary[@"status"] = self.status;
	}
	if(self.text != nil){
		dictionary[@"text"] = self.text;
	}
	if(self.urlTag != nil){
		dictionary[@"url_tag"] = self.urlTag;
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
	if(self.groupNum != nil){
		[aCoder encodeObject:self.groupNum forKey:@"group_num"];
	}
	if(self.label != nil){
		[aCoder encodeObject:self.label forKey:@"label"];
	}
	if(self.name != nil){
		[aCoder encodeObject:self.name forKey:@"name"];
	}
	if(self.status != nil){
		[aCoder encodeObject:self.status forKey:@"status"];
	}
	if(self.text != nil){
		[aCoder encodeObject:self.text forKey:@"text"];
	}
	if(self.urlTag != nil){
		[aCoder encodeObject:self.urlTag forKey:@"url_tag"];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.groupNum = [aDecoder decodeObjectForKey:@"group_num"];
	self.label = [aDecoder decodeObjectForKey:@"label"];
	self.name = [aDecoder decodeObjectForKey:@"name"];
	self.status = [aDecoder decodeObjectForKey:@"status"];
	self.text = [aDecoder decodeObjectForKey:@"text"];
	self.urlTag = [aDecoder decodeObjectForKey:@"url_tag"];
	return self;

}
@end