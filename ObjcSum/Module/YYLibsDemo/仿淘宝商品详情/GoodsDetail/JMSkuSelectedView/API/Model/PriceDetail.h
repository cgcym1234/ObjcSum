#import <UIKit/UIKit.h>

@interface PriceDetail : NSObject

/*
 'price_detail' => dict(
     'title' => '价格详情',
     'desp' => '货价 521.74 + 税价 228.26'
 ),
 */
@property (nonatomic, strong) NSString * desp;
@property (nonatomic, strong) NSString * title;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end
