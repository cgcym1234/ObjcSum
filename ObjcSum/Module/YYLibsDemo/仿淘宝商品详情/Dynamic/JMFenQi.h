#import <UIKit/UIKit.h>

@interface JMFenQi : NSObject

@property (nonatomic, strong) NSArray * period;
@property (nonatomic, strong) NSString * quotaMsg;
@property (nonatomic, strong) NSString * saleMsg;
@property (nonatomic, strong) NSString * status;
@property (nonatomic, strong) NSString * urlTag;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end