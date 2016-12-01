#import <UIKit/UIKit.h>
#import "JMDetail.h"

@interface JMProductGallery : NSObject

@property (nonatomic, strong) NSString * rgb;
@property (nonatomic, strong) JMDetail * url;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end