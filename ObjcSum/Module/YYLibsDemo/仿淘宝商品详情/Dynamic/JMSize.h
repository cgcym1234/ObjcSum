#import <UIKit/UIKit.h>

@interface JMSize : NSObject

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * refundPolicy;
@property (nonatomic, strong) NSString * sku;
@property (nonatomic, strong) NSString * stock;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end