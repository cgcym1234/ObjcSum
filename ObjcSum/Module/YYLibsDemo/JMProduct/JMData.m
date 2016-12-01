//
//	JMData.m
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "JMData.h"

@interface JMData ()
@end
@implementation JMData




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[@"bonded_area_id"] isKindOfClass:[NSNull class]]){
		self.bondedAreaId = dictionary[@"bonded_area_id"];
	}	
	if(![dictionary[@"brand_id"] isKindOfClass:[NSNull class]]){
		self.brandId = dictionary[@"brand_id"];
	}	
	if(![dictionary[@"brand_name"] isKindOfClass:[NSNull class]]){
		self.brandName = dictionary[@"brand_name"];
	}	
	if(![dictionary[@"category_id"] isKindOfClass:[NSNull class]]){
		self.categoryId = dictionary[@"category_id"];
	}	
	if(![dictionary[@"category_ids"] isKindOfClass:[NSNull class]]){
		self.categoryIds = dictionary[@"category_ids"];
	}	
	if(![dictionary[@"description_url_set"] isKindOfClass:[NSNull class]]){
		self.descriptionUrlSet = [[JMDescriptionUrlSet alloc] initWithDictionary:dictionary[@"description_url_set"]];
	}

	if(![dictionary[@"ext_desc"] isKindOfClass:[NSNull class]]){
		self.extDesc = [[JMExtDesc alloc] initWithDictionary:dictionary[@"ext_desc"]];
	}

	if(![dictionary[@"ext_info"] isKindOfClass:[NSNull class]]){
		self.extInfo = dictionary[@"ext_info"];
	}	
	if(![dictionary[@"fav_enabled"] isKindOfClass:[NSNull class]]){
		self.favEnabled = dictionary[@"fav_enabled"];
	}	
	if(![dictionary[@"function_ids"] isKindOfClass:[NSNull class]]){
		self.functionIds = dictionary[@"function_ids"];
	}	
	if(![dictionary[@"guarantee"] isKindOfClass:[NSNull class]]){
		self.guarantee = dictionary[@"guarantee"];
	}	
	if(![dictionary[@"guonei_baoyou"] isKindOfClass:[NSNull class]]){
		self.guoneiBaoyou = dictionary[@"guonei_baoyou"];
	}	
	if(![dictionary[@"has_short_video"] isKindOfClass:[NSNull class]]){
		self.hasShortVideo = dictionary[@"has_short_video"];
	}	
	if(dictionary[@"icon_tag"] != nil && [dictionary[@"icon_tag"] isKindOfClass:[NSArray class]]){
		NSArray * iconTagDictionaries = dictionary[@"icon_tag"];
		NSMutableArray * iconTagItems = [NSMutableArray array];
		for(NSDictionary * iconTagDictionary in iconTagDictionaries){
			JMIconTag * iconTagItem = [[JMIconTag alloc] initWithDictionary:iconTagDictionary];
			[iconTagItems addObject:iconTagItem];
		}
		self.iconTag = iconTagItems;
	}
	if(![dictionary[@"image_url_set"] isKindOfClass:[NSNull class]]){
		self.imageUrlSet = [[JMImageUrlSet alloc] initWithDictionary:dictionary[@"image_url_set"]];
	}

	if(![dictionary[@"is_auth_brand"] isKindOfClass:[NSNull class]]){
		self.isAuthBrand = dictionary[@"is_auth_brand"];
	}	
	if(![dictionary[@"item_id"] isKindOfClass:[NSNull class]]){
		self.itemId = dictionary[@"item_id"];
	}	
	if(![dictionary[@"merchant_id"] isKindOfClass:[NSNull class]]){
		self.merchantId = dictionary[@"merchant_id"];
	}	
	if(![dictionary[@"name"] isKindOfClass:[NSNull class]]){
		self.name = dictionary[@"name"];
	}	
	if(![dictionary[@"nav"] isKindOfClass:[NSNull class]]){
		self.nav = [[JMNav alloc] initWithDictionary:dictionary[@"nav"]];
	}

	if(![dictionary[@"price_ext_title"] isKindOfClass:[NSNull class]]){
		self.priceExtTitle = dictionary[@"price_ext_title"];
	}	
	if(![dictionary[@"product_attr_aca"] isKindOfClass:[NSNull class]]){
		self.productAttrAca = dictionary[@"product_attr_aca"];
	}	
	if(![dictionary[@"product_id"] isKindOfClass:[NSNull class]]){
		self.productId = dictionary[@"product_id"];
	}	
	if(dictionary[@"properties"] != nil && [dictionary[@"properties"] isKindOfClass:[NSArray class]]){
		NSArray * propertiesDictionaries = dictionary[@"properties"];
		NSMutableArray * propertiesItems = [NSMutableArray array];
		for(NSDictionary * propertiesDictionary in propertiesDictionaries){
//			JMProperty * propertiesItem = [[JMProperty alloc] initWithDictionary:propertiesDictionary];
//			[propertiesItems addObject:propertiesItem];
		}
		self.properties = propertiesItems;
	}
	if(![dictionary[@"qrshare_product_name"] isKindOfClass:[NSNull class]]){
		self.qrshareProductName = dictionary[@"qrshare_product_name"];
	}	
	if(![dictionary[@"rating"] isKindOfClass:[NSNull class]]){
		self.rating = dictionary[@"rating"];
	}	
	if(![dictionary[@"recommend_title"] isKindOfClass:[NSNull class]]){
		self.recommendTitle = dictionary[@"recommend_title"];
	}	
	if(![dictionary[@"refund_policy"] isKindOfClass:[NSNull class]]){
		self.refundPolicy = dictionary[@"refund_policy"];
	}	
	if(![dictionary[@"sale_forms"] isKindOfClass:[NSNull class]]){
		self.saleForms = dictionary[@"sale_forms"];
	}	
	if(![dictionary[@"scan_control"] isKindOfClass:[NSNull class]]){
		self.scanControl = [[JMScanControl alloc] initWithDictionary:dictionary[@"scan_control"]];
	}

	if(dictionary[@"share_info"] != nil && [dictionary[@"share_info"] isKindOfClass:[NSArray class]]){
		NSArray * shareInfoDictionaries = dictionary[@"share_info"];
		NSMutableArray * shareInfoItems = [NSMutableArray array];
		for(NSDictionary * shareInfoDictionary in shareInfoDictionaries){
			JMShareInfo * shareInfoItem = [[JMShareInfo alloc] initWithDictionary:shareInfoDictionary];
			[shareInfoItems addObject:shareInfoItem];
		}
		self.shareInfo = shareInfoItems;
	}
	if(![dictionary[@"shipping_system_id"] isKindOfClass:[NSNull class]]){
		self.shippingSystemId = dictionary[@"shipping_system_id"];
	}	
	if(![dictionary[@"shopname"] isKindOfClass:[NSNull class]]){
		self.shopname = dictionary[@"shopname"];
	}	
	if(![dictionary[@"short_name"] isKindOfClass:[NSNull class]]){
		self.shortName = dictionary[@"short_name"];
	}	
	if(![dictionary[@"show_category"] isKindOfClass:[NSNull class]]){
		self.showCategory = dictionary[@"show_category"];
	}	
	if(![dictionary[@"special_tags"] isKindOfClass:[NSNull class]]){
		self.specialTags = [[JMSpecialTag alloc] initWithDictionary:dictionary[@"special_tags"]];
	}

	if(![dictionary[@"store_id"] isKindOfClass:[NSNull class]]){
		self.storeId = dictionary[@"store_id"];
	}	
	if(![dictionary[@"tag"] isKindOfClass:[NSNull class]]){
		self.tag = dictionary[@"tag"];
	}	
	if(![dictionary[@"tax_info"] isKindOfClass:[NSNull class]]){
		self.taxInfo = dictionary[@"tax_info"];
	}	
	if(![dictionary[@"type"] isKindOfClass:[NSNull class]]){
		self.type = dictionary[@"type"];
	}	
	if(![dictionary[@"video_info"] isKindOfClass:[NSNull class]]){
		self.videoInfo = [[JMVideoInfo alloc] initWithDictionary:dictionary[@"video_info"]];
	}

	if(![dictionary[@"warehouse_name"] isKindOfClass:[NSNull class]]){
		self.warehouseName = dictionary[@"warehouse_name"];
	}	
	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	if(self.bondedAreaId != nil){
		dictionary[@"bonded_area_id"] = self.bondedAreaId;
	}
	if(self.brandId != nil){
		dictionary[@"brand_id"] = self.brandId;
	}
	if(self.brandName != nil){
		dictionary[@"brand_name"] = self.brandName;
	}
	if(self.categoryId != nil){
		dictionary[@"category_id"] = self.categoryId;
	}
	if(self.categoryIds != nil){
		dictionary[@"category_ids"] = self.categoryIds;
	}
	if(self.descriptionUrlSet != nil){
		dictionary[@"description_url_set"] = [self.descriptionUrlSet toDictionary];
	}
	if(self.extDesc != nil){
		dictionary[@"ext_desc"] = [self.extDesc toDictionary];
	}
	if(self.extInfo != nil){
		dictionary[@"ext_info"] = self.extInfo;
	}
	if(self.favEnabled != nil){
		dictionary[@"fav_enabled"] = self.favEnabled;
	}
	if(self.functionIds != nil){
		dictionary[@"function_ids"] = self.functionIds;
	}
	if(self.guarantee != nil){
		dictionary[@"guarantee"] = self.guarantee;
	}
	if(self.guoneiBaoyou != nil){
		dictionary[@"guonei_baoyou"] = self.guoneiBaoyou;
	}
	if(self.hasShortVideo != nil){
		dictionary[@"has_short_video"] = self.hasShortVideo;
	}
	if(self.iconTag != nil){
		NSMutableArray * dictionaryElements = [NSMutableArray array];
		for(JMIconTag * iconTagElement in self.iconTag){
			[dictionaryElements addObject:[iconTagElement toDictionary]];
		}
		dictionary[@"icon_tag"] = dictionaryElements;
	}
	if(self.imageUrlSet != nil){
		dictionary[@"image_url_set"] = [self.imageUrlSet toDictionary];
	}
	if(self.isAuthBrand != nil){
		dictionary[@"is_auth_brand"] = self.isAuthBrand;
	}
	if(self.itemId != nil){
		dictionary[@"item_id"] = self.itemId;
	}
	if(self.merchantId != nil){
		dictionary[@"merchant_id"] = self.merchantId;
	}
	if(self.name != nil){
		dictionary[@"name"] = self.name;
	}
	if(self.nav != nil){
		dictionary[@"nav"] = [self.nav toDictionary];
	}
	if(self.priceExtTitle != nil){
		dictionary[@"price_ext_title"] = self.priceExtTitle;
	}
	if(self.productAttrAca != nil){
		dictionary[@"product_attr_aca"] = self.productAttrAca;
	}
	if(self.productId != nil){
		dictionary[@"product_id"] = self.productId;
	}
	if(self.properties != nil){
		NSMutableArray * dictionaryElements = [NSMutableArray array];
//		for(JMProperty * propertiesElement in self.properties){
//			[dictionaryElements addObject:[propertiesElement toDictionary]];
//		}
		dictionary[@"properties"] = dictionaryElements;
	}
	if(self.qrshareProductName != nil){
		dictionary[@"qrshare_product_name"] = self.qrshareProductName;
	}
	if(self.rating != nil){
		dictionary[@"rating"] = self.rating;
	}
	if(self.recommendTitle != nil){
		dictionary[@"recommend_title"] = self.recommendTitle;
	}
	if(self.refundPolicy != nil){
		dictionary[@"refund_policy"] = self.refundPolicy;
	}
	if(self.saleForms != nil){
		dictionary[@"sale_forms"] = self.saleForms;
	}
	if(self.scanControl != nil){
		dictionary[@"scan_control"] = [self.scanControl toDictionary];
	}
	if(self.shareInfo != nil){
		NSMutableArray * dictionaryElements = [NSMutableArray array];
		for(JMShareInfo * shareInfoElement in self.shareInfo){
			[dictionaryElements addObject:[shareInfoElement toDictionary]];
		}
		dictionary[@"share_info"] = dictionaryElements;
	}
	if(self.shippingSystemId != nil){
		dictionary[@"shipping_system_id"] = self.shippingSystemId;
	}
	if(self.shopname != nil){
		dictionary[@"shopname"] = self.shopname;
	}
	if(self.shortName != nil){
		dictionary[@"short_name"] = self.shortName;
	}
	if(self.showCategory != nil){
		dictionary[@"show_category"] = self.showCategory;
	}
	if(self.specialTags != nil){
		dictionary[@"special_tags"] = [self.specialTags toDictionary];
	}
	if(self.storeId != nil){
		dictionary[@"store_id"] = self.storeId;
	}
	if(self.tag != nil){
		dictionary[@"tag"] = self.tag;
	}
	if(self.taxInfo != nil){
		dictionary[@"tax_info"] = self.taxInfo;
	}
	if(self.type != nil){
		dictionary[@"type"] = self.type;
	}
	if(self.videoInfo != nil){
		dictionary[@"video_info"] = [self.videoInfo toDictionary];
	}
	if(self.warehouseName != nil){
		dictionary[@"warehouse_name"] = self.warehouseName;
	}
	return dictionary;

}

/**
 * Implementation of NSCoding encoding method
 */
/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
- (void)encodeWithCoder:(NSCoder *)aCoder
{
	if(self.bondedAreaId != nil){
		[aCoder encodeObject:self.bondedAreaId forKey:@"bonded_area_id"];
	}
	if(self.brandId != nil){
		[aCoder encodeObject:self.brandId forKey:@"brand_id"];
	}
	if(self.brandName != nil){
		[aCoder encodeObject:self.brandName forKey:@"brand_name"];
	}
	if(self.categoryId != nil){
		[aCoder encodeObject:self.categoryId forKey:@"category_id"];
	}
	if(self.categoryIds != nil){
		[aCoder encodeObject:self.categoryIds forKey:@"category_ids"];
	}
	if(self.descriptionUrlSet != nil){
		[aCoder encodeObject:self.descriptionUrlSet forKey:@"description_url_set"];
	}
	if(self.extDesc != nil){
		[aCoder encodeObject:self.extDesc forKey:@"ext_desc"];
	}
	if(self.extInfo != nil){
		[aCoder encodeObject:self.extInfo forKey:@"ext_info"];
	}
	if(self.favEnabled != nil){
		[aCoder encodeObject:self.favEnabled forKey:@"fav_enabled"];
	}
	if(self.functionIds != nil){
		[aCoder encodeObject:self.functionIds forKey:@"function_ids"];
	}
	if(self.guarantee != nil){
		[aCoder encodeObject:self.guarantee forKey:@"guarantee"];
	}
	if(self.guoneiBaoyou != nil){
		[aCoder encodeObject:self.guoneiBaoyou forKey:@"guonei_baoyou"];
	}
	if(self.hasShortVideo != nil){
		[aCoder encodeObject:self.hasShortVideo forKey:@"has_short_video"];
	}
	if(self.iconTag != nil){
		[aCoder encodeObject:self.iconTag forKey:@"icon_tag"];
	}
	if(self.imageUrlSet != nil){
		[aCoder encodeObject:self.imageUrlSet forKey:@"image_url_set"];
	}
	if(self.isAuthBrand != nil){
		[aCoder encodeObject:self.isAuthBrand forKey:@"is_auth_brand"];
	}
	if(self.itemId != nil){
		[aCoder encodeObject:self.itemId forKey:@"item_id"];
	}
	if(self.merchantId != nil){
		[aCoder encodeObject:self.merchantId forKey:@"merchant_id"];
	}
	if(self.name != nil){
		[aCoder encodeObject:self.name forKey:@"name"];
	}
	if(self.nav != nil){
		[aCoder encodeObject:self.nav forKey:@"nav"];
	}
	if(self.priceExtTitle != nil){
		[aCoder encodeObject:self.priceExtTitle forKey:@"price_ext_title"];
	}
	if(self.productAttrAca != nil){
		[aCoder encodeObject:self.productAttrAca forKey:@"product_attr_aca"];
	}
	if(self.productId != nil){
		[aCoder encodeObject:self.productId forKey:@"product_id"];
	}
	if(self.properties != nil){
		[aCoder encodeObject:self.properties forKey:@"properties"];
	}
	if(self.qrshareProductName != nil){
		[aCoder encodeObject:self.qrshareProductName forKey:@"qrshare_product_name"];
	}
	if(self.rating != nil){
		[aCoder encodeObject:self.rating forKey:@"rating"];
	}
	if(self.recommendTitle != nil){
		[aCoder encodeObject:self.recommendTitle forKey:@"recommend_title"];
	}
	if(self.refundPolicy != nil){
		[aCoder encodeObject:self.refundPolicy forKey:@"refund_policy"];
	}
	if(self.saleForms != nil){
		[aCoder encodeObject:self.saleForms forKey:@"sale_forms"];
	}
	if(self.scanControl != nil){
		[aCoder encodeObject:self.scanControl forKey:@"scan_control"];
	}
	if(self.shareInfo != nil){
		[aCoder encodeObject:self.shareInfo forKey:@"share_info"];
	}
	if(self.shippingSystemId != nil){
		[aCoder encodeObject:self.shippingSystemId forKey:@"shipping_system_id"];
	}
	if(self.shopname != nil){
		[aCoder encodeObject:self.shopname forKey:@"shopname"];
	}
	if(self.shortName != nil){
		[aCoder encodeObject:self.shortName forKey:@"short_name"];
	}
	if(self.showCategory != nil){
		[aCoder encodeObject:self.showCategory forKey:@"show_category"];
	}
	if(self.specialTags != nil){
		[aCoder encodeObject:self.specialTags forKey:@"special_tags"];
	}
	if(self.storeId != nil){
		[aCoder encodeObject:self.storeId forKey:@"store_id"];
	}
	if(self.tag != nil){
		[aCoder encodeObject:self.tag forKey:@"tag"];
	}
	if(self.taxInfo != nil){
		[aCoder encodeObject:self.taxInfo forKey:@"tax_info"];
	}
	if(self.type != nil){
		[aCoder encodeObject:self.type forKey:@"type"];
	}
	if(self.videoInfo != nil){
		[aCoder encodeObject:self.videoInfo forKey:@"video_info"];
	}
	if(self.warehouseName != nil){
		[aCoder encodeObject:self.warehouseName forKey:@"warehouse_name"];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.bondedAreaId = [aDecoder decodeObjectForKey:@"bonded_area_id"];
	self.brandId = [aDecoder decodeObjectForKey:@"brand_id"];
	self.brandName = [aDecoder decodeObjectForKey:@"brand_name"];
	self.categoryId = [aDecoder decodeObjectForKey:@"category_id"];
	self.categoryIds = [aDecoder decodeObjectForKey:@"category_ids"];
	self.descriptionUrlSet = [aDecoder decodeObjectForKey:@"description_url_set"];
	self.extDesc = [aDecoder decodeObjectForKey:@"ext_desc"];
	self.extInfo = [aDecoder decodeObjectForKey:@"ext_info"];
	self.favEnabled = [aDecoder decodeObjectForKey:@"fav_enabled"];
	self.functionIds = [aDecoder decodeObjectForKey:@"function_ids"];
	self.guarantee = [aDecoder decodeObjectForKey:@"guarantee"];
	self.guoneiBaoyou = [aDecoder decodeObjectForKey:@"guonei_baoyou"];
	self.hasShortVideo = [aDecoder decodeObjectForKey:@"has_short_video"];
	self.iconTag = [aDecoder decodeObjectForKey:@"icon_tag"];
	self.imageUrlSet = [aDecoder decodeObjectForKey:@"image_url_set"];
	self.isAuthBrand = [aDecoder decodeObjectForKey:@"is_auth_brand"];
	self.itemId = [aDecoder decodeObjectForKey:@"item_id"];
	self.merchantId = [aDecoder decodeObjectForKey:@"merchant_id"];
	self.name = [aDecoder decodeObjectForKey:@"name"];
	self.nav = [aDecoder decodeObjectForKey:@"nav"];
	self.priceExtTitle = [aDecoder decodeObjectForKey:@"price_ext_title"];
	self.productAttrAca = [aDecoder decodeObjectForKey:@"product_attr_aca"];
	self.productId = [aDecoder decodeObjectForKey:@"product_id"];
	self.properties = [aDecoder decodeObjectForKey:@"properties"];
	self.qrshareProductName = [aDecoder decodeObjectForKey:@"qrshare_product_name"];
	self.rating = [aDecoder decodeObjectForKey:@"rating"];
	self.recommendTitle = [aDecoder decodeObjectForKey:@"recommend_title"];
	self.refundPolicy = [aDecoder decodeObjectForKey:@"refund_policy"];
	self.saleForms = [aDecoder decodeObjectForKey:@"sale_forms"];
	self.scanControl = [aDecoder decodeObjectForKey:@"scan_control"];
	self.shareInfo = [aDecoder decodeObjectForKey:@"share_info"];
	self.shippingSystemId = [aDecoder decodeObjectForKey:@"shipping_system_id"];
	self.shopname = [aDecoder decodeObjectForKey:@"shopname"];
	self.shortName = [aDecoder decodeObjectForKey:@"short_name"];
	self.showCategory = [aDecoder decodeObjectForKey:@"show_category"];
	self.specialTags = [aDecoder decodeObjectForKey:@"special_tags"];
	self.storeId = [aDecoder decodeObjectForKey:@"store_id"];
	self.tag = [aDecoder decodeObjectForKey:@"tag"];
	self.taxInfo = [aDecoder decodeObjectForKey:@"tax_info"];
	self.type = [aDecoder decodeObjectForKey:@"type"];
	self.videoInfo = [aDecoder decodeObjectForKey:@"video_info"];
	self.warehouseName = [aDecoder decodeObjectForKey:@"warehouse_name"];
	return self;

}
@end
