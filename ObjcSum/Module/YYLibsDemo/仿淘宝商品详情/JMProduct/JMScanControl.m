//
//	JMScanControl.m
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "JMScanControl.h"

@interface JMScanControl ()
@end
@implementation JMScanControl




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[@"is_allow_add_scan"] isKindOfClass:[NSNull class]]){
		self.isAllowAddScan = dictionary[@"is_allow_add_scan"];
	}	
	if(![dictionary[@"is_show_scan_btn"] isKindOfClass:[NSNull class]]){
		self.isShowScanBtn = dictionary[@"is_show_scan_btn"];
	}	
	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	if(self.isAllowAddScan != nil){
		dictionary[@"is_allow_add_scan"] = self.isAllowAddScan;
	}
	if(self.isShowScanBtn != nil){
		dictionary[@"is_show_scan_btn"] = self.isShowScanBtn;
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
	if(self.isAllowAddScan != nil){
		[aCoder encodeObject:self.isAllowAddScan forKey:@"is_allow_add_scan"];
	}
	if(self.isShowScanBtn != nil){
		[aCoder encodeObject:self.isShowScanBtn forKey:@"is_show_scan_btn"];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.isAllowAddScan = [aDecoder decodeObjectForKey:@"is_allow_add_scan"];
	self.isShowScanBtn = [aDecoder decodeObjectForKey:@"is_show_scan_btn"];
	return self;

}
@end