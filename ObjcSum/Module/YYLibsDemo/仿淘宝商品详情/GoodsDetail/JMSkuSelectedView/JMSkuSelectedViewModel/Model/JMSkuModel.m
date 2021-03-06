//
//	JMSkuInfo.m
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "JMSkuModel.h"
#import "NSObject+Additionals.h"
#import "JMDataUtility.h"

@interface JMSkuModel ()
@end
@implementation JMSkuModel



/*
{
    "attr_list":[
                 {
                     "title":"颜色",
                     "type":"attribute",
                     "item":[
                             "红色",
                             "黄色",
                             "蓝色"
                             ]
                 },
                 {
                     "title":"尺码",
                     "type":"size",
                     "item":[
                             "33",
                             "34",
                             "35",
                             "36"
                             ]
                 }
                 ],
    "size":[
            {
                "sku":"1049890",
                "name":"个",
                "stock":"1",
                "refund_policy":[
                                 "interantion_shipping",
                                 "genuine_guarantee"
                                 ],
                "jumei_price":"100.18",
                "discount":"-1",
                "price_detail":{
                    "title":"价格详情",
                    "desp":"货价 521.74 + 税价 228.26"
                },
                "img":"http1://mp1.jmstatic.com/c_zoom,w_150/1123.jpg",
                "attribute":"红色",
                "size":"33"
            },
            {
                "sku":"1049891",
                "name":"个",
                "stock":"1",
                "refund_policy":[
                                 "interantion_shipping",
                                 "genuine_guarantee"
                                 ],
                "jumei_price":"100.18",
                "discount":"-1",
                "price_detail":{
                    "title":"价格详情",
                    "desp":"货价 521.74 + 税价 228.26"
                },
                "img":"http1://mp1.jmstatic.com/c_zoom,w_150/1123.jpg",
                "attribute":"红色",
                "size":"34"
            },
            ]
}
*/

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	
    NSArray * skuGroupDictionaries = arrayInDictionaryForKey(dictionary, @"attr_list");
    if (skuGroupDictionaries.count > 0) {
        NSMutableArray * skuGroupItems = [NSMutableArray array];
        NSMutableDictionary * skuTypeDict = [NSMutableDictionary new];
        for(NSDictionary * skuGroupDictionary in skuGroupDictionaries){
            SkuGroupInfo * skuGroupItem = [[SkuGroupInfo alloc] initWithDictionary:skuGroupDictionary];
            [skuGroupItems addSafeObject:skuGroupItem];
            [skuTypeDict setSafeObject:skuGroupItem.title forKey:skuGroupItem.type];
        }
        self.skuGroupInfos = skuGroupItems;
        self.skuGroupTypeDict = skuTypeDict;
    }

    
    NSArray * skuInfoDictionaries = arrayInDictionaryForKey(dictionary, @"size");
    if (skuInfoDictionaries.count > 0) {
        NSArray *skuTypeKeys = [self.skuGroupTypeDict allKeys];
        NSMutableArray * skuInfoItems = [NSMutableArray array];
        int stock = 0;
        for(NSDictionary * skuInfoDictionary in skuInfoDictionaries){
            SkuInfo * skuInfoItem = [[SkuInfo alloc] initWithDictionary:skuInfoDictionary skuTypeKeys:skuTypeKeys];
            [skuInfoItems addSafeObject:skuInfoItem];
            stock += skuInfoItem.stock;
        }
        self.skuInfos = skuInfoItems;
        _stock = stock;
        
        NSMutableDictionary *skuValueModelsDict = [NSMutableDictionary new];
        for (SkuInfo *skuInfo in skuInfoItems) {
            NSArray *skuValues = [skuInfo.skuTypeValus allValues];
            for (NSString *skuValue in skuValues) {
                NSMutableArray *valueModels = skuValueModelsDict[skuValue];
                if (!valueModels) {
                    valueModels = [@[skuInfo] mutableCopy];
                    skuValueModelsDict[skuValue] = valueModels;
                } else {
                    [valueModels addSafeObject:skuInfo];
                }
            }
        }
        self.skuValueModelsDict = skuValueModelsDict;
    }

	return self;
}


- (NSString *)unit {
    return _skuInfos.count > 0 ? _skuInfos.firstObject.name : nil;
}


@end
