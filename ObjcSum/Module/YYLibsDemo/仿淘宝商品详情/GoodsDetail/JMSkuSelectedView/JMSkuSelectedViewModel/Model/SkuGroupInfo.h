#import <UIKit/UIKit.h>



@interface SkuGroupInfo : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *type;
/* "item":["红色","黄色","蓝色"] */
@property (nonatomic, strong) NSArray<NSString *> *items;


-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end
