//
//	PriceDetail.m
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "PriceDetail.h"

@interface PriceDetail ()
@end
@implementation PriceDetail




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[@"desp"] isKindOfClass:[NSNull class]]){
		self.desp = dictionary[@"desp"];
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
	if(self.desp != nil){
		dictionary[@"desp"] = self.desp;
	}
	if(self.title != nil){
		dictionary[@"title"] = self.title;
	}
	return dictionary;

}

@end
