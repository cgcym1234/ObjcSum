#import <UIKit/UIKit.h>

@interface JMExtra : NSObject

@property (nonatomic, strong) NSString * timestamp;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end