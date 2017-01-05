#import <UIKit/UIKit.h>
#import "PriceDetail.h"

@interface SkuInfo : NSObject

/*
 dict(
 'sku' => '1049890',
 'name' => '个',
 'stock' => '1',
 'refund_policy' => array('interantion_shipping', 'genuine_guarantee'),
 'jumei_price' => '100.18',
 'discount'  => '-1',
 'price_detail' => dict(
     'title' => '价格详情',
     'desp' => '货价 521.74 + 税价 228.26'
 ),
 'img' =>  'http1://mp1.jmstatic.com/c_zoom,w_150/1123.jpg', // SKU级别图片
 'attribute' => '红色', // 规格
 'size' => '33', // 尺码
 ),
 */
@property (nonatomic, strong) NSString * skuId;
@property (nonatomic, strong) NSString * name;
@property (nonatomic) NSInteger stock;

@property (nonatomic, strong) NSArray<NSString *> * refundPolicy;
@property (nonatomic, strong) NSString * jumeiPrice;
@property (nonatomic, strong) PriceDetail * priceDetail;
@property (nonatomic, strong) NSString * discount;
@property (nonatomic, strong) NSString * img;

/*
 'attribute' => '红色', // 规格
 'size' => '33', // 尺码
 。。。
 */
@property (nonatomic, strong) NSDictionary *skuTypeValus;




-(instancetype)initWithDictionary:(NSDictionary *)dictionary skuTypeKeys:(NSArray <NSString *> *)skuTypeKeys;

-(NSDictionary *)toDictionary;
@end
