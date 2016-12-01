#import <UIKit/UIKit.h>
#import "JMDescriptionUrlSet.h"
#import "JMExtDesc.h"
#import "JMIconTag.h"
#import "JMImageUrlSet.h"
#import "JMNav.h"
#import "JMProperty.h"
#import "JMScanControl.h"
#import "JMShareInfo.h"
#import "JMSpecialTag.h"
#import "JMVideoInfo.h"

@interface JMData : NSObject

/*
 商品区域类型：
 普通团购 : 团购API获取到的数据,type = jumei_deal
 普通POP : POPAPI获取到的数据,type = jumei_pop
 普通商城 : 商城API获取到的数据,type = jumei_mall
 海淘团购 : 团购API获取到的数据,type = global_deal
 海淘POP : POPAPI获取到的数据,type = global_pop
 海淘商城 : 商城API获取到的数据,type = global_mall
 组合售卖 : 商城API获取到的数据,type = combination
 
 "type": "jumei_pop",
 
 @property(nonatomic) MAProductAreaType productAreaType;             ///< 新的商品类型判断，现在只支持6个
 @property(nonatomic, copy) NSString *productAreaTypeString;         ///< 新的商品类型
 */
@property (nonatomic, strong) NSString * type; ///< 新的商品类型

/*
 "item_id": "df1611242420p1832146",
 
 @property(nonatomic, copy) NSString *productItemID; ///< 产品的itemID，这是一个统一的ID，现在还列表页用
 */
@property (nonatomic, strong) NSString * itemId; ///< 产品的itemID，这是一个统一的ID，现在还列表页用

/*
 "name": "【源自法国巴黎】DELSEY法国大使 拉杆箱20寸/25寸/28寸（5色可选）都只要399！【欧洲箱包品牌，遍布110多个国家】【5年质保放心购！】装再多万向轮也没负重感，加厚铝化拉杆高承重力，耐压PC材质不怕行李被摔烂！3种尺寸同价格任性选，28寸超大箱体更超值！数量有限哦"
 
 @property(nonatomic, copy) NSString *productName;        ///< 产品名称
 */
@property (nonatomic, strong) NSString * name; ///< 产品名称

/*
 "qrshare_product_name": "【源自巴黎】DELSEY法国大使拉杆箱,简约耐用大容量,20/25/28寸同价格任意选"
 
 @property(nonatomic, copy) NSString *productQRShareName; ///< 产品详情页二维码分享用标题
 */
@property (nonatomic, strong) NSString * qrshareProductName; ///< 产品详情页二维码分享用标题

/*
 "short_name": "全系列可扩容  PC材质箱面"
 
 @property(nonatomic, copy) NSString *productShortName;   ///< 产品短名称
 */
@property (nonatomic, strong) NSString * shortName; ///< 产品短名称

/*
 "product_id": "1832146",
 
 @property(nonatomic, copy) NSString *productID;     ///< 产品在商场中的ID
 */
@property (nonatomic, strong) NSString * productId; ///< 产品在商场中的ID

/*
 "brand_id": "5754",
 
 @property(nonatomic, copy) NSString *productBrandID;        ///< 品牌id
 */
@property (nonatomic, strong) NSString * brandId; ///< 品牌id

/*
 "category_id": "107",
 
 @property(nonatomic, copy) NSString *productCategoryID;     ///< 商品所属分类id
 */
@property (nonatomic, strong) NSString * categoryId; ///< 商品所属分类id

/*
 "function_ids": ["7", "11", "13"],
 
 @property(nonatomic, copy) NSArray *productEffects;         ///< 商品功效数组，维护了一组功效id
 */
@property (nonatomic, strong) NSArray * functionIds; ///< 商品功效数组，维护了一组功效id

/*
 NSDictionary *imgDictionary = dictionaryInDictionaryForKey(productJson, @"image_url_set");
 NSDictionary *singleImageDictionary = dictionaryInDictionaryForKey(imgDictionary, @"single");
 product_.productSingleImageRGB = singleImageDictionary[@"rgb"];
 
 if ([singleImageDictionary objectForKey:@"url"]) {
 singleImageDictionary = dictionaryInDictionaryForKey(singleImageDictionary, @"url");
 }
 
 product_.productImage200p200p = [MAImageAdapter adaptImageFromImages:singleImageDictionary];
 product_.productSingleImage = [MAImageAdapter adaptImageFromImages:singleImageDictionary];       //正常图
 product_.productImageForStarShop = singleImageDictionary;
 
 NSArray *gallerys_ = arrayInDictionaryForKey(imgDictionary, @"gallery");
 if (gallerys_.count > 0) {
 NSDictionary *firstGallery_ = gallerys_[0];
 NSDictionary *galleryDictionary_ = dictionaryInDictionaryForKey(firstGallery_, @"url");
 product_.productSingleGalleryImage = [MAImageAdapter adaptImageFromImages:galleryDictionary_];
 }
 
 NSDictionary *dxImageDictionary = dictionaryInDictionaryForKey(imgDictionary, @"dx_image");
 product_.productdxImageRGB = dxImageDictionary[@"rgb"];
 
 if ([dxImageDictionary objectForKey:@"url"]) {
 dxImageDictionary = dictionaryInDictionaryForKey(dxImageDictionary, @"url");
 }
 
 product_.productImage640p400p = [MAImageAdapter adaptImageFromImages:dxImageDictionary];
 product_.productdxImage = [MAImageAdapter adaptImageFromImages:dxImageDictionary];           //调性图
 */
@property (nonatomic, strong) JMImageUrlSet * imageUrlSet;

/*
 "tag": "",
 @property(nonatomic, copy) NSURL *productTagURL;           ///< 限购产品的标签
 */
@property (nonatomic, strong) NSString * tag; ///< 限购产品的标签


/*
 "show_category": "media",
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
 "has_short_video": "1",
 @property (nonatomic) BOOL shortVideo; ///< 是否有短视频
 */
@property (nonatomic, strong) NSString * hasShortVideo; ///< 是否有短视频，has_short_video 1代表有视频，0代表没有视频


/*
 "guarantee": [],
 
 NSDictionary *guarantee = dictionaryInDictionaryForKey(productJson, @"guarantee");
 NSArray *guaranteeList = arrayInDictionaryForKey(guarantee, @"guarantee_list");
 product_.promiseRefundPolicys = [MADealDetailApiRequest guaranteesWithJson:guaranteeList];
 product_.productGuaranteeTitle = stringInDictionaryForKey(guarantee, @"title");
 
 @property(nonatomic, strong) NSArray *promiseRefundPolicys;  ///< 商品的退货策略,承诺保证策略的数组
 @property(nonatomic, copy) NSString *productGuaranteeTitle; ///<  聚美保证标题
 */
@property (nonatomic, strong) NSArray * guarantee;


/*
 "rating": "0.0",
 @property(nonatomic, copy) NSNumber *productPraiseRating;    ///< 口碑平分
 */
@property (nonatomic, strong) NSString * rating; ///< 口碑平分


/*
 "product_attr_aca": "n",
 
 if ([elementName_ isEqualToString:@"product_attr_aca"]) {
 product_.productPromisePolicy = stringInDictionaryForKey(productJson, elementName_);
 }
 
 @property(nonatomic, copy) NSString *productPromisePolicy;   ///< 商品的承诺保证策略
 */
@property (nonatomic, strong) NSString * productAttrAca; ///< 商品的承诺保证策略

/*
 "shopname": "",
 @property(nonatomic, copy) NSString *productAttributTip;   ///< 产品在详情页属性提示(iPhone)
 */
@property (nonatomic, strong) NSString * shopname;///< 产品在详情页属性提示(iPhone)


/*
 "brand_name": "法国大使",
 @property(nonatomic, copy) NSString *productBrandName;      ///< 品牌名称
 */
@property (nonatomic, strong) NSString * brandName;



//"description_url_set": {
//    "product": {
//        "480": "http:\/\/www.jumei.com\/i\/deal\/df1611242420p1832146.html?share_source=app",
//        "640": "http:\/\/www.jumei.com\/i\/deal\/df1611242420p1832146.html?share_source=app",
//        "750": "http:\/\/www.jumei.com\/i\/deal\/df1611242420p1832146.html?share_source=app",
//        "1200": "http:\/\/www.jumei.com\/i\/deal\/df1611242420p1832146.html?share_source=app"
//    },
//    "detail": {
//        "480": "http:\/\/s.h5.jumei.com\/mobile\/deal\/product_info?type=jumei_pop&item_id=df1611242420p1832146&t_lang=touch&product_attr_aca=n&site=bj&__client_v=3.9801&__platform=iphone",
//        "640": "http:\/\/s.h5.jumei.com\/mobile\/deal\/product_info?type=jumei_pop&item_id=df1611242420p1832146&t_lang=touch&product_attr_aca=n&site=bj&__client_v=3.9801&__platform=iphone",
//        "750": "http:\/\/s.h5.jumei.com\/mobile\/deal\/product_info?type=jumei_pop&item_id=df1611242420p1832146&t_lang=touch&product_attr_aca=n&site=bj&__client_v=3.9801&__platform=iphone",
//        "1200": "http:\/\/s.h5.jumei.com\/mobile\/deal\/product_info?type=jumei_pop&item_id=df1611242420p1832146&t_lang=touch&product_attr_aca=n&site=bj&__client_v=3.9801&__platform=iphone"
//    },
//    "pictures": {
//        同上
//    },
//    "usage": {
//        同上
//    },
//    "union": {
//        同上
//    }
//},

/*
 NSDictionary *descriptionDictionary = dictionaryInDictionaryForKey(productJson, @"description_url_set");
 //    NSDictionary *detailUrlDictionary = dictionaryInDictionaryForKey(descriptionDictionary, @"detail");
 NSDictionary *detailUrlDictionary = dictionaryInDictionaryForKey(descriptionDictionary, @"union");
 product_.productDetailsWebURL = [MAImageAdapter adaptImageFromImages:detailUrlDictionary];
 
 NSDictionary *picturesUrlDictionary = dictionaryInDictionaryForKey(descriptionDictionary, @"pictures");
 product_.productPhotosWebURL = [MAImageAdapter adaptImageFromImages:picturesUrlDictionary];
 NSDictionary *productUrlDictionary = dictionaryInDictionaryForKey(descriptionDictionary, @"product");
 product_.productHTTPURL = [[MAImageAdapter adaptImageFromImages:productUrlDictionary] absoluteString];
 NSDictionary *usageUrlDictionary = dictionaryInDictionaryForKey(descriptionDictionary, @"usage");
 product_.productUsageWebUrl = [MAImageAdapter adaptImageFromImages:usageUrlDictionary];
 //预售
 NSDictionary *presaleRuleURLDictionary = dictionaryInDictionaryForKey(descriptionDictionary, @"presale_rule_url");
 product_.presale_rule_url = [MAImageAdapter adaptImageFromImages:presaleRuleURLDictionary];
 
 
 @property(nonatomic, copy) NSURL *productDetailsWebURL;    ///< 产品详情页webview的地址
 @property(nonatomic, copy) NSURL *productPhotosWebURL;     ///< 产品实拍web地址
 @property(nonatomic, copy) NSURL *productUsageWebUrl;      ///< 产品的使用方法
 @property(nonatomic, copy) NSString *productHTTPURL;         ///< 分享时附带的链接，一般为网页版商场中的地址
 
 @property (nonatomic, copy) NSURL *presale_rule_url; //预售
 */
@property (nonatomic, strong) JMDescriptionUrlSet * descriptionUrlSet; //各种url

/*
 "properties": [
     {
     "property_id": "4",
     "name": "商品名称",
     "value": "480D舒压推脂纤腿踩脚裤袜"
     },
 ]
 
 @property(nonatomic, copy) NSArray *productAttributs;      ///< 产品在详情页显示的各种属性
 */
@property (nonatomic, strong) NSArray * properties; ///< 商品参数的各种属性




/*
 "ext_desc": {
 "discount": "1.6折",
 "sku_title": "选择型号",
 "sku_button": "尺码助手",
 "price_bottom": ""
 },
 
 NSDictionary *ext_desc_ = dictionaryInDictionaryForKey(productJson, @"ext_desc");
 //详情页动静分离改discount为最外层返回结构
 product_.ext_dexc_discount = [stringInDictionaryForKey(productJson, @"discount") discountDisplay];
 product_.sku_title         = stringInDictionaryForKey(ext_desc_, @"sku_title");//sku的title的文案
 product_.sku_button_title  = stringInDictionaryForKey(ext_desc_, @"sku_button");//sku右侧button的的文案
 product_.price_bottom      = stringInDictionaryForKey(ext_desc_, @"price_bottom");
 
 @property (nonatomic, copy) NSString *ext_dexc_discount; ///< MAEDetailTitleTableViewCell中前面特殊前缀中使用[]
 @property(nonatomic, copy) NSString *sku_title;           ///< sku的title的文案
 @property(nonatomic, copy) NSString *sku_button_title;    ///< sku右侧button的的文案
 @property(nonatomic, copy) NSString *price_bottom;        ///< 价格cell下面cell的通用方案
 */
@property (nonatomic, strong) JMExtDesc * extDesc;

/*
 "guonei_baoyou": "单商家订单满159元包邮",
 @property (nonatomic, copy) NSString *guoneiBaoyou; ///<  国内包邮信息
 */
@property (nonatomic, strong) NSString * guoneiBaoyou;


/*
 "ext_info": {
     "brand_info": {
         "brand_name": "佳丽宝",
         "url": "jumeimall://page/search/filter?search=佳丽宝&brandid=4514&title=佳丽宝"
     }
 },
 // 品牌相关
 NSDictionary * ext_info = dictionaryInDictionaryForKey(productJson, @"ext_info");
 NSDictionary * brand_info = dictionaryInDictionaryForKey(ext_info, @"brand_info");
 product_.ext_info_brand_info_name = stringInDictionaryForKey(brand_info, @"brand_name");
 product_.ext_info_brand_info_url = stringInDictionaryForKey(brand_info, @"url");
 */
@property (nonatomic, strong) NSArray * extInfo; //品牌名字和跳转链接

/*
 "recommend_title": " 您也许还喜欢",
 
 @property (nonatomic, copy) NSString *recommend_title; //超值推荐商品title
 */
@property (nonatomic, strong) NSString * recommendTitle; //超值推荐商品title

/*
 "special_tags": {
    "jm_owner": "[聚美自营]",
    "book": ""
 },
 
 //v3.4 特殊标签
 NSDictionary *special_tags = dictionaryInDictionaryForKey(productJson, @"special_tags");
 product_.tag_jm_owner = stringInDictionaryForKey(special_tags, @"jm_owner");
 product_.tag_book = stringInDictionaryForKey(special_tags, @"book");
 
 @property (nonatomic, copy) NSString *tag_jm_owner;   //聚美自营
 @property (nonatomic, copy) NSString *tag_book;      //抢先预订
 */
@property (nonatomic, strong) JMSpecialTag * specialTags;

/*
 "scan_control": {
     "is_show_scan_btn": "1",
     "is_allow_add_scan": "1"
 },
 
 //是否显示浏览记录
 NSDictionary *scan_control = dictionaryInDictionaryForKey(productJson, @"scan_control");
 product_.is_show_scan_btn = [stringInDictionaryForKey(scan_control, @"is_show_scan_btn") boolValue];
 
 //这个没有使用
 product_.is_allow_add_scan = [stringInDictionaryForKey(scan_control, @"is_allow_add_scan") boolValue];
 */

/*
 "fav_enabled": "0",
 @property(nonatomic) BOOL productFavEnable;  ///< 是否显示收藏
 */
@property (nonatomic, strong) NSString * favEnabled; ///< 是否显示收藏


/*
 "video_info": {
 "short_video_url": "http:\/\/jmvideo.jumei.com\/MzgyODYwMDk_E\/MTQ4MDAwNzE4NDQ0Ng_E_E\/NDM1NzQ4Mg_E_E\/dHJpbS45Qzg0Njg1My03MjAxLTRCNzctQTk4Mi0wQTg1M0IxNTQyNDMuTU9W_default.mp4?post_id=video_4702",
 "short_video_cover_url": {
     "480": "http:\/\/showlive-10012585.image.myqcloud.com\/f14b7f5b-a6b3-40f0-a9d3-f5357784ef31",
     "640": "http:\/\/showlive-10012585.image.myqcloud.com\/f14b7f5b-a6b3-40f0-a9d3-f5357784ef31",
     "750": "http:\/\/showlive-10012585.image.myqcloud.com\/f14b7f5b-a6b3-40f0-a9d3-f5357784ef31",
     "1200": "http:\/\/showlive-10012585.image.myqcloud.com\/f14b7f5b-a6b3-40f0-a9d3-f5357784ef31"
 },
 "post_id": "video_4702"
 },
 
 
 //详情页头视图短视频
 NSDictionary *shortVideoDic = dictionaryInDictionaryForKey(productJson, @"video_info");
 product_.shortVideoCoverUrlIsExit = stringInDictionaryForKey(shortVideoDic, @"short_video_url");
 product_.productPostId            = stringInDictionaryForKey(shortVideoDic, @"post_id");
 MADealDetailInfoImageSetGallery *imageSetGallery = [[MADealDetailInfoImageSetGallery alloc] init];
 NSDictionary *shortVideoCoverUrlDic              = dictionaryInDictionaryForKey(shortVideoDic,@"short_video_cover_url");
 imageSetGallery.shortVideoCoverUrl               = [[MAImageAdapter adaptImageFromImages:shortVideoCoverUrlDic] absoluteString];
 imageSetGallery.big_image                        = [[MAImageAdapter adaptImageFromImages:shortVideoCoverUrlDic] absoluteString];
 imageSetGallery.shortVideoUrl                    = stringInDictionaryForKey(shortVideoDic, @"short_video_url");
 NSMutableArray *imageAndVideoArr                 = [NSMutableArray arrayWithArray:product_.productGallery];
 if (imageSetGallery.shortVideoCoverUrl.length > 0) {
     [imageAndVideoArr insertObject:imageSetGallery atIndex:0];
     product_.productGallery = imageAndVideoArr;
 }
 
 @property (nonatomic, copy) NSString *shortVideoCoverUrlIsExit;
 @property (nonatomic, copy) NSString *productPostId;    ///<帖子id
 
 @property(nonatomic, strong) NSArray *productGallery;         ///< 产品的图片册
 @property (nonatomic, copy) NSString *big_image;           ///< 同shortVideoCoverUrl
 @property (nonatomic, copy) NSString *shortVideoCoverUrl;  ///< 默认视频封面图片
 @property (nonatomic, copy) NSString *shortVideoUrl;       ///< 短视频mov格式，可在线播放
 */
@property (nonatomic, strong) JMVideoInfo * videoInfo;


/*
 "share_info": [
 {
 "platform": "wechat",
 "link": "http:\/\/4096.share.jumei.com\/product\/detail?type=jumei_pop&item_id=df1611242420p1832146&share_source=app",
 "title": "\u3010\u6b63\u54c1\u4f4e\u4ef7\u3001\u6781\u901f\u6d77\u6dd8\u3011\u4ec5\u552e399\uff01\u5168\u7cfb\u5217\u53ef\u6269\u5bb9  PC\u6750\u8d28\u7bb1\u9762",
 "text": "\u3010\u6e90\u81ea\u6cd5\u56fd\u5df4\u9ece\u3011DELSEY\u6cd5\u56fd\u5927\u4f7f \u62c9\u6746\u7bb120\u5bf8\/25\u5bf8\/28\u5bf8\uff085\u8272\u53ef\u9009\uff09\u90fd\u53ea\u8981399\uff01\u3010\u6b27\u6d32\u7bb1\u5305\u54c1\u724c\uff0c\u904d\u5e03110\u591a\u4e2a\u56fd\u5bb6\u3011\u30105\u5e74\u8d28\u4fdd\u653e\u5fc3\u8d2d\uff01\u3011\u88c5\u518d\u591a\u4e07\u5411\u8f6e\u4e5f\u6ca1\u8d1f\u91cd\u611f\uff0c\u52a0\u539a\u94dd\u5316\u62c9\u6746\u9ad8\u627f\u91cd\u529b\uff0c\u8010\u538bPC\u6750\u8d28\u4e0d\u6015\u884c\u674e\u88ab\u6454\u70c2\uff013\u79cd\u5c3a\u5bf8\u540c\u4ef7\u683c\u4efb\u6027\u9009\uff0c28\u5bf8\u8d85\u5927\u7bb1\u4f53\u66f4\u8d85\u503c\uff01\u6570\u91cf\u6709\u9650\u54e6",
 "image_url_set": {
 "url": {
 "480": "http:\/\/mp1.jmstatic.com\/c_zoom,w_480,q_70\/product\/001\/832\/1832146_std\/1832146_1000_1000.jpg?v=1479983828",
 "640": "http:\/\/mp1.jmstatic.com\/c_zoom,w_640,q_70\/product\/001\/832\/1832146_std\/1832146_1000_1000.jpg?v=1479983828",
 "750": "http:\/\/mp1.jmstatic.com\/c_zoom,w_750,q_70\/product\/001\/832\/1832146_std\/1832146_1000_1000.jpg?v=1479983828",
 "1200": "http:\/\/mp1.jmstatic.com\/c_zoom,w_1200,q_70\/product\/001\/832\/1832146_std\/1832146_1000_1000.jpg?v=1479983828"
 },
 "rgb": "#FFFFFF"
 }
 }, ],
 
 @property(nonatomic, strong) NSArray<MAShareInfo *> *arrShareInfo;
 */
@property (nonatomic, strong) NSArray * iconTag;













@property (nonatomic, strong) JMScanControl * scanControl;
@property (nonatomic, strong) NSArray * shareInfo;







@property (nonatomic, strong) NSArray * taxInfo;





/*
 "price_ext_title": "",
 @property(nonatomic, copy) NSString *productPriceDescription;
 不知道还有用不，好像是没用了
 */
@property (nonatomic, strong) NSString * priceExtTitle;

/*
 "nav": {
 "wifi": "detail",
 "default": "introduction"
 },
 无用的字段
 */
@property (nonatomic, strong) JMNav * nav;


/*
 "refund_policy": "7days",
 @property(nonatomic, copy) NSString *productRefundPolicy;    ///< 商品的退货策略
 没有使用该字段
 */
@property (nonatomic, strong) NSString * refundPolicy;


/*
 "merchant_id": "1708",
 无用的字段
 */
@property (nonatomic, strong) NSString * merchantId;

/*
 "store_id": "3223",
 
 没有使用该字段，使用动态接口shop_info下的store_id
 */
@property (nonatomic, strong) NSString * storeId;

/*
 "bonded_area_id": "",
 担保的ID，无用
 */
@property (nonatomic, strong) NSString * bondedAreaId;


/*
 "is_auth_brand": "0",
 是否授权品牌？无用，
 */
@property (nonatomic, strong) NSString * isAuthBrand;

/*
 "category_ids": "485,517,518,519",
 无用
 */
@property (nonatomic, strong) NSString * categoryIds;

/*
 "sale_forms": "normal",
 无用
 */
@property (nonatomic, strong) NSString * saleForms;

/*
 "warehouse_name": "",
 无用
 */
@property (nonatomic, strong) NSString * warehouseName;

/*
 "shipping_system_id": "1889",
 @property(nonatomic, copy) NSString *shippingSystemId;              ///< 仓库id
 无用
 */
@property (nonatomic, strong) NSString * shippingSystemId;


-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end
