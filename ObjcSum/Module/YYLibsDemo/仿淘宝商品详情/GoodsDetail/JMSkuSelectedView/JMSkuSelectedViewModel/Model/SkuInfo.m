//
//	SkuList.m
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "SkuInfo.h"
#import "NSObject+Additionals.h"
#import "JMDataUtility.h"

@interface SkuInfo ()
@end
@implementation SkuInfo




/*
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
     ]
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary skuTypeKeys:(NSArray <NSString *> *)skuTypeKeys
{
	self = [super init];
    self.discount = stringInDictionaryForKey(dictionary, @"discount");
    self.img = stringInDictionaryForKey(dictionary, @"img");
    self.jumeiPrice = stringInDictionaryForKey(dictionary, @"jumei_price");
    self.name = stringInDictionaryForKey(dictionary, @"name");
    
    self.priceDetail = [[PriceDetail alloc] initWithDictionary:dictionaryInDictionaryForKey(dictionary, @"price_detail")];
    
    self.refundPolicy = arrayInDictionaryForKey(dictionary, @"refund_policy");
    self.skuId = stringInDictionaryForKey(dictionary, @"sku");
    self.stock = [stringInDictionaryForKey(dictionary, @"stock") integerValue];
    
    if (skuTypeKeys.count > 0) {
        NSMutableDictionary *skuTypeValus = [NSMutableDictionary new];
        for (NSString *key in skuTypeKeys) {
            [skuTypeValus setSafeObject:stringInDictionaryForKey(dictionary, key) forKey:key];
        }
        self.skuTypeValus = skuTypeValus;
    }
    
	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	if(self.skuId != nil){
		dictionary[@"sku"] = self.skuId;
	}
	if(self.discount != nil){
		dictionary[@"discount"] = self.discount;
	}
	if(self.img != nil){
		dictionary[@"img"] = self.img;
	}
	if(self.jumeiPrice != nil){
		dictionary[@"jumei_price"] = self.jumeiPrice;
	}
	if(self.name != nil){
		dictionary[@"name"] = self.name;
	}
	if(self.priceDetail != nil){
		dictionary[@"price_detail"] = [self.priceDetail toDictionary];
	}
	if(self.refundPolicy != nil){
		dictionary[@"refund_policy"] = self.refundPolicy;
	}
//	if(self.stock != nil){
//		
//	}
    dictionary[@"stock"] = @(self.stock);
    if(self.skuTypeValus != nil){
        dictionary[@"skuTypeValus"] = self.skuTypeValus;
    }
	return dictionary;

}

@end
