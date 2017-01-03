#import <UIKit/UIKit.h>
#import "JMFenQi.h"
#import "JMSize.h"

@interface JMProduct : NSObject

/*
 "item_id": "df1611242420p1832146",
 同静态
 */
@property (nonatomic, strong) NSString * itemId;

/*
 "type": "jumei_pop",
 同静态
 */
@property (nonatomic, strong) NSString * type;

/*
 "status": "onsell",
 
 秒杀商品有个额外判断，//v3.7 解决心愿结束转在售时，api的缓存问题
 NSString *statusString = stringInDictionaryForKey(productJson, @"status");
 if ([stringInDictionaryForKey(productJson, @"show_category") isEqualToString:@"seckill"]) {
     product_.isReloadSkuWhenAddCart = YES;
     [product_ judgeProductDetailStatus:statusString];
 }
 else {
     [product_ judgeProductStatus:statusString];
 }
 @property(nonatomic) MADProductStatus productStatus;                ///< 商品状态
 */
@property (nonatomic, strong) NSString * status; ///< 商品状态


/*
 "is_sellable": "1",
 
 @property(nonatomic) BOOL nonSellable;                      ///< 不可售
 */
@property (nonatomic, strong) NSString * isSellable; ///< 是否在售


/*
 "selling_forms": "normal",
 
 typedef NS_ENUM(NSInteger, MAProductSellingForms) {
     MAProductSellingFormsNormal = 0,     //正常销售
     MAProductSellingFormsPreSale = 1,     //预售
     MAProductSellingFormsGroupOn = 2,     // 凑团
     MAProductSellingFormsRedemption = 3, //换购
 };
 @property (nonatomic) MAProductSellingForms selling_forms;
 */
@property (nonatomic, strong) NSString * sellingForms;


/*
 "discount": "-1",
 @property(nonatomic, copy) NSString *productDiscount;      ///< 产品的当前折扣率
 */
@property (nonatomic, strong) NSString * discount; ///< 产品的当前折扣率


/*
 "market_price": "2590",
 @property(nonatomic, copy) NSString *productOriginalPrice; ///< 产品的原价
 */
@property (nonatomic, strong) NSString * marketPrice; ///< 产品的原价


/*
 "size": [
     {
         "sku": "df1832146020624650",
         "name": "20\u5bf8 \u9ed1\u8272",
         "stock": "1",
         "refund_policy": ""
     }, 
 
     {
     ...
     },
 ],
 
 
 //global商品解析不同
 NSArray *AllSKUs = arrayInDictionaryForKey(productJson, @"size");
 if (product_.productCountryType == MAGlobalProductType) {
     product_.productAllSKUs = [MADealDetailApiRequest globalProductSizeWithJson:AllSKUs isStock:NO];
 } else {
     product_.productAllSKUs = [MADealDetailApiRequest productSizeWithJson:AllSKUs];
 }
 
 @property(nonatomic, copy) NSArray<MASKU *> *productAllSKUs; ///< 产品的SKU列表
 */
@property (nonatomic, strong) NSArray * size; ///< 产品的SKU列表

/*
 "default_sku": "df188914417932162338",
 
 @property(nonatomic, copy) NSString *productCurrentSku;             ///< 展示的sku
 */
@property (nonatomic, strong) NSString * defaultSku; ///< 展示的sku

/*
 "show_sku": "1",
 
 @property(nonatomic) BOOL productShowSKU;    ///< 是否显示sku控制选项
 */
@property (nonatomic, strong) NSString * showSku; ///< 是否显示sku控制选项


/*
 "show_category": "media", 同静态
 */
//NSString *statusString = stringInDictionaryForKey(productJson, @"status");
//if ([stringInDictionaryForKey(productJson, @"show_category") isEqualToString:@"seckill"]) {
//    product_.isReloadSkuWhenAddCart = YES; //秒杀
//    [product_ judgeProductDetailStatus:statusString];
//}
//else {
//    [product_ judgeProductStatus:statusString];
//}
//NSString *typeString = stringInDictionaryForKey(productJson, @"type");
//[product_ judgeProductType:typeString];
@property (nonatomic, strong) NSString * showCategory;


/*
 "product_id": "1832146", 同静态
 
 @property(nonatomic, copy) NSString *productID;     ///< 产品在商场中的ID
 */
@property (nonatomic, strong) NSString * productId; ///< 产品在商场中的ID


/*
 "brand_id": "5754", 同静态
 
 @property(nonatomic, copy) NSString *productBrandID;        ///< 品牌id
 */
@property (nonatomic, strong) NSString * brandId; ///< 品牌id


/*
 "jumei_price": "399",
 
 @property(nonatomic, copy) NSString *productSalePrice;     ///< 产品当前售价
 @property(nonatomic, copy) NSString *productJuMeiPrice;    ///< 产品当前聚美售价
 */
@property (nonatomic, strong) NSString * jumeiPrice;


/*
 "start_time": "1480039200",
 "end_time": "1480125599",
 "second_kill_time": "1480039200",
 
 @property(nonatomic) NSTimeInterval productStartTimeIntervalSince1970; ///< 产品开售时间
 @property(nonatomic) NSTimeInterval productEndTimeIntervalSince1970;   ///< 产品停售时间
 */
@property (nonatomic, strong) NSString * startTime;
@property (nonatomic, strong) NSString * endTime;
@property (nonatomic, strong) NSString * secondKillTime;


/*
 "buyer_number": "820",
 
 //buyer_number,wish_number为@“”时不转换为@0
 NSString *productSalesVolumeStr = stringInDictionaryForKey(productJson, @"buyer_number");
 if ([NSString isValide:productSalesVolumeStr]) {
     product_.productSalesVolume = numberInDictionaryForKey(productJson, @"buyer_number");
 }else{
     product_.productSalesVolume = nil;
 }
 
 @property(nonatomic, copy) NSNumber *productSalesVolume;   ///< 产品热销量
 */
@property (nonatomic, strong) NSString * buyerNumber; //购买人数


/*
 "wish_number": "477",
 
 NSString *productAmountOfMakewishStr = stringInDictionaryForKey(productJson, @"wish_number");
 if ([NSString isValide:productAmountOfMakewishStr]) {
     product_.productAmountOfMakewish = numberInDictionaryForKey(productJson, @"wish_number");
 }else{
     product_.productAmountOfMakewish = nil;
 }
 
 @property(nonatomic, copy) NSNumber *productAmountOfMakewish;     ///< 许愿总数
 */


/*
 "cart_action": "add_cart",
 
 NSString *cartAction = stringInDictionaryForKey(productJson, @"cart_action");
 if ([cartAction isEqualToString:@"direct_pay"]) {
     product_.isDirectPay = YES;
 }
 
 @property (nonatomic) BOOL isDirectPay;
 
 */


/*
 "cart_action_title": "加入购物车",
 
 // 购买按钮文案
 product_.cartActionTitle = stringInDictionaryForKey(productJson, @"cart_action_title");
 @property (nonatomic, copy) NSString *cartActionTitle; ///<  新的购买按钮文案
 */


/*
 "is_dm": "0",
 
 @property (nonatomic) BOOL isDM; ///< 是否直邮
 */



/*
 "show_sku": "1",
 
 @property(nonatomic) BOOL productShowSKU;    ///< 是否显示sku控制选项
 */


/*
 "stocks_alarm": "0",
 
 @property (nonatomic, assign) BOOL stockAlarm; ///< 库存余量告警
 */


/*
 "status_tag": "",
 
 @property (nonatomic, copy) NSString *statusTag; ///<即将抢光/已抢光文案
 */


/*
 "right_top_icon": "",
 
 @property(nonatomic, copy) NSURL *rightTopTagURL;          ///< 产品右上角的标签  如：双十一商品
 */


/*
 "is_show_score": "0", // V3.45 是否显示商品评价
 
 @property (nonatomic) BOOL productIsShowScore;
 */



/*
 "is_show_koubei": "0",
 
 @property (nonatomic) BOOL isShowKoubei; ///< 是否显示口碑header
 */



/*
 "is_show_comment": "0",
 
 @property (nonatomic) BOOL isShowComment; ///< 是否显示口碑tab
 */


/*
 "shop_info": [],
 
 @property (nonatomic, strong) MAProductDetailShopInfo *productShopInfo;// V3.45商家信息  V_3.88店铺入口
 */


/*
 "activity_list": [],
 
 @property (nonatomic, copy) NSArray<MAProductDetailActivity *> *arrActiviesList;
 */



/*
 "promotion_set": "item_id%3Ddf1611242420p1832146%26product_id%3D1832146%26brand_id%3D5754%26status%3Donsell%26display_price%3D%26show_category%3Dmedia%26category_ids%3D485%252C517%252C518%252C519%26sale_type%3D1%26sale_forms%3Dnormal%26warehouse_name%3D%26default_price%3D399",
 
 @property (nonatomic, copy) NSString *promotion_set;                ///< 详情页现金劵接口所需入参
 */



/*
 "detail_page_show_promocard": "0",
 
 @property(nonatomic, assign) BOOL    detail_page_show_promocard;    ///< 是否显示详情页现金劵文本
 */


/*
 "price_des": [],
 
 @property (nonatomic, copy) NSString *priceDescTitle; ///<价格描述标题
 @property (nonatomic, copy) NSString *priceDescText;  ///<价格描述文案
 @property (nonatomic, copy) NSString *priceDescName;  ///<价格描述按钮文案
 */


/*
 "product_desc": "820人已购买",
 
//产品描述，可能是以下字段中其中一个：新品上线、已售55555、已许愿55555
@property (nonatomic, copy) NSString * product_desc;
 */




/*
 "relate_deal": [],
 
 @property (nonnull, strong) MAProductDetailDeal *deal; //关联Deal
 */



/*
 "fen_qi": {
     "period": [],
     "quota_msg": "",
     "sale_msg": "",
     "url_tag": "",
     "status": "0"
 }
 
 @property (nonatomic, strong)JMProductDetailInstallment *productInstallment;///<分期购数据源
 */

#pragma mark - 无用
/*
 "tag_ids": [],
 无用
 */
@property (nonatomic, strong) NSArray * tagIds;

/*
 "warehouse_code": "",
 无用
 */
@property (nonatomic, strong) NSString * warehouseCode;


/*
 "sale_type": "1",
 无用
 */
@property (nonatomic, strong) NSString * saleType;


/*
 "status_num": "1",
 无用
 */
@property (nonatomic, strong) NSString * statusNum;


/*
 "extra_data": "eyJzdGFyX3Nob3BfaWQiOiIiLCJzdGFyX3Nob3BfbmFtZSI6IiJ9",
 无用
 */


@property (nonatomic, strong) NSArray * activityList;


@property (nonatomic, strong) NSString * cartAction;
@property (nonatomic, strong) NSString * cartActionTitle;

@property (nonatomic, strong) NSString * detailPageShowPromocard;


@property (nonatomic, strong) NSString * extraData;
@property (nonatomic, strong) JMFenQi * fenQi;
@property (nonatomic, strong) NSString * isDm;

@property (nonatomic, strong) NSString * isShowComment;
@property (nonatomic, strong) NSString * isShowKoubei;
@property (nonatomic, strong) NSString * isShowScore;



@property (nonatomic, strong) NSArray * priceDes;
@property (nonatomic, strong) NSString * productDesc;

@property (nonatomic, strong) NSString * promotionSet;
@property (nonatomic, strong) NSArray * relateDeal;
@property (nonatomic, strong) NSString * rightTopIcon;



@property (nonatomic, strong) NSArray * shopInfo;






@property (nonatomic, strong) NSString * statusTag;
@property (nonatomic, strong) NSString * stocksAlarm;



@property (nonatomic, strong) NSString * wishNumber;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end
