#import <UIKit/UIKit.h>
#import "JMImageUrlSet.h"

@interface JMShareInfo : NSObject

@property (nonatomic, strong) JMImageUrlSet * imageUrlSet;
@property (nonatomic, strong) NSString * link;
@property (nonatomic, strong) NSString * platform;
@property (nonatomic, strong) NSString * text;
@property (nonatomic, strong) NSString * title;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end