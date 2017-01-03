//
//	JMVideoInfo.m
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "JMVideoInfo.h"

@interface JMVideoInfo ()
@end
@implementation JMVideoInfo




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[@"post_id"] isKindOfClass:[NSNull class]]){
		self.postId = dictionary[@"post_id"];
	}	
	if(![dictionary[@"short_video_cover_url"] isKindOfClass:[NSNull class]]){
		self.shortVideoCoverUrl = [[JMDetail alloc] initWithDictionary:dictionary[@"short_video_cover_url"]];
	}

	if(![dictionary[@"short_video_url"] isKindOfClass:[NSNull class]]){
		self.shortVideoUrl = dictionary[@"short_video_url"];
	}	
	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	if(self.postId != nil){
		dictionary[@"post_id"] = self.postId;
	}
	if(self.shortVideoCoverUrl != nil){
		dictionary[@"short_video_cover_url"] = [self.shortVideoCoverUrl toDictionary];
	}
	if(self.shortVideoUrl != nil){
		dictionary[@"short_video_url"] = self.shortVideoUrl;
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
	if(self.postId != nil){
		[aCoder encodeObject:self.postId forKey:@"post_id"];
	}
	if(self.shortVideoCoverUrl != nil){
		[aCoder encodeObject:self.shortVideoCoverUrl forKey:@"short_video_cover_url"];
	}
	if(self.shortVideoUrl != nil){
		[aCoder encodeObject:self.shortVideoUrl forKey:@"short_video_url"];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.postId = [aDecoder decodeObjectForKey:@"post_id"];
	self.shortVideoCoverUrl = [aDecoder decodeObjectForKey:@"short_video_cover_url"];
	self.shortVideoUrl = [aDecoder decodeObjectForKey:@"short_video_url"];
	return self;

}
@end