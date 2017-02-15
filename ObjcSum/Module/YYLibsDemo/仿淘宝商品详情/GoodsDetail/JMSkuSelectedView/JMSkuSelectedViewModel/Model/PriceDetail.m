//
//	PriceDetail.m
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "PriceDetail.h"
#import "JMDataUtility.h"

@interface PriceDetail ()
@end
@implementation PriceDetail




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
    self.desp = stringInDictionaryForKey(dictionary, @"desp");
    self.title = stringInDictionaryForKey(dictionary, @"title");

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
