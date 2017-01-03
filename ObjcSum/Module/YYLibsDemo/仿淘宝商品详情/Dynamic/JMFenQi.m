//
//	JMFenQi.m
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "JMFenQi.h"

@interface JMFenQi ()
@end
@implementation JMFenQi




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[@"period"] isKindOfClass:[NSNull class]]){
		self.period = dictionary[@"period"];
	}	
	if(![dictionary[@"quota_msg"] isKindOfClass:[NSNull class]]){
		self.quotaMsg = dictionary[@"quota_msg"];
	}	
	if(![dictionary[@"sale_msg"] isKindOfClass:[NSNull class]]){
		self.saleMsg = dictionary[@"sale_msg"];
	}	
	if(![dictionary[@"status"] isKindOfClass:[NSNull class]]){
		self.status = dictionary[@"status"];
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
	if(self.period != nil){
		dictionary[@"period"] = self.period;
	}
	if(self.quotaMsg != nil){
		dictionary[@"quota_msg"] = self.quotaMsg;
	}
	if(self.saleMsg != nil){
		dictionary[@"sale_msg"] = self.saleMsg;
	}
	if(self.status != nil){
		dictionary[@"status"] = self.status;
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
	if(self.period != nil){
		[aCoder encodeObject:self.period forKey:@"period"];
	}
	if(self.quotaMsg != nil){
		[aCoder encodeObject:self.quotaMsg forKey:@"quota_msg"];
	}
	if(self.saleMsg != nil){
		[aCoder encodeObject:self.saleMsg forKey:@"sale_msg"];
	}
	if(self.status != nil){
		[aCoder encodeObject:self.status forKey:@"status"];
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
	self.period = [aDecoder decodeObjectForKey:@"period"];
	self.quotaMsg = [aDecoder decodeObjectForKey:@"quota_msg"];
	self.saleMsg = [aDecoder decodeObjectForKey:@"sale_msg"];
	self.status = [aDecoder decodeObjectForKey:@"status"];
	self.urlTag = [aDecoder decodeObjectForKey:@"url_tag"];
	return self;

}
@end