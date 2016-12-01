#import <UIKit/UIKit.h>
#import "JMDetail.h"

@interface JMVideoInfo : NSObject

@property (nonatomic, strong) NSString * postId;
@property (nonatomic, strong) JMDetail * shortVideoCoverUrl;
@property (nonatomic, strong) NSString * shortVideoUrl;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end