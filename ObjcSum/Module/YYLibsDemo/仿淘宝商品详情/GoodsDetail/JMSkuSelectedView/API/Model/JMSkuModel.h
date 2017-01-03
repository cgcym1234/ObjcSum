#import <UIKit/UIKit.h>
#import "SkuInfo.h"
#import "SkuGroupInfo.h"

@interface JMSkuModel : NSObject

@property (nonatomic, strong) NSArray<SkuGroupInfo *> * skuGroupInfos;

@property (nonatomic, strong) NSArray<SkuInfo *> *skuInfos;

@property (nonatomic, readonly) NSInteger stock;
@property (nonatomic, strong, readonly) NSString *unit;

/* sku类型key和代表值的字典，比如
 attribute = "颜色",
 size = "尺寸"
 */
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> *skuGroupTypeDict;

/* sku所有值和相应SkuInfo的字典
 "红色" = [xx,xxx],
 "35" = [xx]
 */
@property (nonatomic, strong) NSDictionary<NSString *, NSArray<SkuInfo *> *> *skuValueModelsDict;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end
