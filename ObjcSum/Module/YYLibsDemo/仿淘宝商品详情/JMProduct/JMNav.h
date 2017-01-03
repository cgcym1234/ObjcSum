#import <UIKit/UIKit.h>

@interface JMNav : NSObject

@property (nonatomic, strong) NSString * defaultField;
@property (nonatomic, strong) NSString * wifi;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end