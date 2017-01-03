#import <UIKit/UIKit.h>

@interface JMExtDesc : NSObject

@property (nonatomic, strong) NSString * discount;
@property (nonatomic, strong) NSString * priceBottom;
@property (nonatomic, strong) NSString * skuButton;
@property (nonatomic, strong) NSString * skuTitle;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end