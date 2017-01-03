//
//	JMProduct.m
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "JMProduct.h"

@interface JMProduct ()
@end
@implementation JMProduct




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[@"activity_list"] isKindOfClass:[NSNull class]]){
		self.activityList = dictionary[@"activity_list"];
	}	
	if(![dictionary[@"brand_id"] isKindOfClass:[NSNull class]]){
		self.brandId = dictionary[@"brand_id"];
	}	
	if(![dictionary[@"buyer_number"] isKindOfClass:[NSNull class]]){
		self.buyerNumber = dictionary[@"buyer_number"];
	}	
	if(![dictionary[@"cart_action"] isKindOfClass:[NSNull class]]){
		self.cartAction = dictionary[@"cart_action"];
	}	
	if(![dictionary[@"cart_action_title"] isKindOfClass:[NSNull class]]){
		self.cartActionTitle = dictionary[@"cart_action_title"];
	}	
	if(![dictionary[@"default_sku"] isKindOfClass:[NSNull class]]){
		self.defaultSku = dictionary[@"default_sku"];
	}	
	if(![dictionary[@"detail_page_show_promocard"] isKindOfClass:[NSNull class]]){
		self.detailPageShowPromocard = dictionary[@"detail_page_show_promocard"];
	}	
	if(![dictionary[@"discount"] isKindOfClass:[NSNull class]]){
		self.discount = dictionary[@"discount"];
	}	
	if(![dictionary[@"end_time"] isKindOfClass:[NSNull class]]){
		self.endTime = dictionary[@"end_time"];
	}	
	if(![dictionary[@"extra_data"] isKindOfClass:[NSNull class]]){
		self.extraData = dictionary[@"extra_data"];
	}	
	if(![dictionary[@"fen_qi"] isKindOfClass:[NSNull class]]){
		self.fenQi = [[JMFenQi alloc] initWithDictionary:dictionary[@"fen_qi"]];
	}

	if(![dictionary[@"is_dm"] isKindOfClass:[NSNull class]]){
		self.isDm = dictionary[@"is_dm"];
	}	
	if(![dictionary[@"is_sellable"] isKindOfClass:[NSNull class]]){
		self.isSellable = dictionary[@"is_sellable"];
	}	
	if(![dictionary[@"is_show_comment"] isKindOfClass:[NSNull class]]){
		self.isShowComment = dictionary[@"is_show_comment"];
	}	
	if(![dictionary[@"is_show_koubei"] isKindOfClass:[NSNull class]]){
		self.isShowKoubei = dictionary[@"is_show_koubei"];
	}	
	if(![dictionary[@"is_show_score"] isKindOfClass:[NSNull class]]){
		self.isShowScore = dictionary[@"is_show_score"];
	}	
	if(![dictionary[@"item_id"] isKindOfClass:[NSNull class]]){
		self.itemId = dictionary[@"item_id"];
	}	
	if(![dictionary[@"jumei_price"] isKindOfClass:[NSNull class]]){
		self.jumeiPrice = dictionary[@"jumei_price"];
	}	
	if(![dictionary[@"market_price"] isKindOfClass:[NSNull class]]){
		self.marketPrice = dictionary[@"market_price"];
	}	
	if(![dictionary[@"price_des"] isKindOfClass:[NSNull class]]){
		self.priceDes = dictionary[@"price_des"];
	}	
	if(![dictionary[@"product_desc"] isKindOfClass:[NSNull class]]){
		self.productDesc = dictionary[@"product_desc"];
	}	
	if(![dictionary[@"product_id"] isKindOfClass:[NSNull class]]){
		self.productId = dictionary[@"product_id"];
	}	
	if(![dictionary[@"promotion_set"] isKindOfClass:[NSNull class]]){
		self.promotionSet = dictionary[@"promotion_set"];
	}	
	if(![dictionary[@"relate_deal"] isKindOfClass:[NSNull class]]){
		self.relateDeal = dictionary[@"relate_deal"];
	}	
	if(![dictionary[@"right_top_icon"] isKindOfClass:[NSNull class]]){
		self.rightTopIcon = dictionary[@"right_top_icon"];
	}	
	if(![dictionary[@"sale_type"] isKindOfClass:[NSNull class]]){
		self.saleType = dictionary[@"sale_type"];
	}	
	if(![dictionary[@"second_kill_time"] isKindOfClass:[NSNull class]]){
		self.secondKillTime = dictionary[@"second_kill_time"];
	}	
	if(![dictionary[@"selling_forms"] isKindOfClass:[NSNull class]]){
		self.sellingForms = dictionary[@"selling_forms"];
	}	
	if(![dictionary[@"shop_info"] isKindOfClass:[NSNull class]]){
		self.shopInfo = dictionary[@"shop_info"];
	}	
	if(![dictionary[@"show_category"] isKindOfClass:[NSNull class]]){
		self.showCategory = dictionary[@"show_category"];
	}	
	if(![dictionary[@"show_sku"] isKindOfClass:[NSNull class]]){
		self.showSku = dictionary[@"show_sku"];
	}	
	if(dictionary[@"size"] != nil && [dictionary[@"size"] isKindOfClass:[NSArray class]]){
		NSArray * sizeDictionaries = dictionary[@"size"];
		NSMutableArray * sizeItems = [NSMutableArray array];
		for(NSDictionary * sizeDictionary in sizeDictionaries){
			JMSize * sizeItem = [[JMSize alloc] initWithDictionary:sizeDictionary];
			[sizeItems addObject:sizeItem];
		}
		self.size = sizeItems;
	}
	if(![dictionary[@"start_time"] isKindOfClass:[NSNull class]]){
		self.startTime = dictionary[@"start_time"];
	}	
	if(![dictionary[@"status"] isKindOfClass:[NSNull class]]){
		self.status = dictionary[@"status"];
	}	
	if(![dictionary[@"status_num"] isKindOfClass:[NSNull class]]){
		self.statusNum = dictionary[@"status_num"];
	}	
	if(![dictionary[@"status_tag"] isKindOfClass:[NSNull class]]){
		self.statusTag = dictionary[@"status_tag"];
	}	
	if(![dictionary[@"stocks_alarm"] isKindOfClass:[NSNull class]]){
		self.stocksAlarm = dictionary[@"stocks_alarm"];
	}	
	if(![dictionary[@"tag_ids"] isKindOfClass:[NSNull class]]){
		self.tagIds = dictionary[@"tag_ids"];
	}	
	if(![dictionary[@"type"] isKindOfClass:[NSNull class]]){
		self.type = dictionary[@"type"];
	}	
	if(![dictionary[@"warehouse_code"] isKindOfClass:[NSNull class]]){
		self.warehouseCode = dictionary[@"warehouse_code"];
	}	
	if(![dictionary[@"wish_number"] isKindOfClass:[NSNull class]]){
		self.wishNumber = dictionary[@"wish_number"];
	}	
	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	if(self.activityList != nil){
		dictionary[@"activity_list"] = self.activityList;
	}
	if(self.brandId != nil){
		dictionary[@"brand_id"] = self.brandId;
	}
	if(self.buyerNumber != nil){
		dictionary[@"buyer_number"] = self.buyerNumber;
	}
	if(self.cartAction != nil){
		dictionary[@"cart_action"] = self.cartAction;
	}
	if(self.cartActionTitle != nil){
		dictionary[@"cart_action_title"] = self.cartActionTitle;
	}
	if(self.defaultSku != nil){
		dictionary[@"default_sku"] = self.defaultSku;
	}
	if(self.detailPageShowPromocard != nil){
		dictionary[@"detail_page_show_promocard"] = self.detailPageShowPromocard;
	}
	if(self.discount != nil){
		dictionary[@"discount"] = self.discount;
	}
	if(self.endTime != nil){
		dictionary[@"end_time"] = self.endTime;
	}
	if(self.extraData != nil){
		dictionary[@"extra_data"] = self.extraData;
	}
	if(self.fenQi != nil){
		dictionary[@"fen_qi"] = [self.fenQi toDictionary];
	}
	if(self.isDm != nil){
		dictionary[@"is_dm"] = self.isDm;
	}
	if(self.isSellable != nil){
		dictionary[@"is_sellable"] = self.isSellable;
	}
	if(self.isShowComment != nil){
		dictionary[@"is_show_comment"] = self.isShowComment;
	}
	if(self.isShowKoubei != nil){
		dictionary[@"is_show_koubei"] = self.isShowKoubei;
	}
	if(self.isShowScore != nil){
		dictionary[@"is_show_score"] = self.isShowScore;
	}
	if(self.itemId != nil){
		dictionary[@"item_id"] = self.itemId;
	}
	if(self.jumeiPrice != nil){
		dictionary[@"jumei_price"] = self.jumeiPrice;
	}
	if(self.marketPrice != nil){
		dictionary[@"market_price"] = self.marketPrice;
	}
	if(self.priceDes != nil){
		dictionary[@"price_des"] = self.priceDes;
	}
	if(self.productDesc != nil){
		dictionary[@"product_desc"] = self.productDesc;
	}
	if(self.productId != nil){
		dictionary[@"product_id"] = self.productId;
	}
	if(self.promotionSet != nil){
		dictionary[@"promotion_set"] = self.promotionSet;
	}
	if(self.relateDeal != nil){
		dictionary[@"relate_deal"] = self.relateDeal;
	}
	if(self.rightTopIcon != nil){
		dictionary[@"right_top_icon"] = self.rightTopIcon;
	}
	if(self.saleType != nil){
		dictionary[@"sale_type"] = self.saleType;
	}
	if(self.secondKillTime != nil){
		dictionary[@"second_kill_time"] = self.secondKillTime;
	}
	if(self.sellingForms != nil){
		dictionary[@"selling_forms"] = self.sellingForms;
	}
	if(self.shopInfo != nil){
		dictionary[@"shop_info"] = self.shopInfo;
	}
	if(self.showCategory != nil){
		dictionary[@"show_category"] = self.showCategory;
	}
	if(self.showSku != nil){
		dictionary[@"show_sku"] = self.showSku;
	}
	if(self.size != nil){
		NSMutableArray * dictionaryElements = [NSMutableArray array];
		for(JMSize * sizeElement in self.size){
			[dictionaryElements addObject:[sizeElement toDictionary]];
		}
		dictionary[@"size"] = dictionaryElements;
	}
	if(self.startTime != nil){
		dictionary[@"start_time"] = self.startTime;
	}
	if(self.status != nil){
		dictionary[@"status"] = self.status;
	}
	if(self.statusNum != nil){
		dictionary[@"status_num"] = self.statusNum;
	}
	if(self.statusTag != nil){
		dictionary[@"status_tag"] = self.statusTag;
	}
	if(self.stocksAlarm != nil){
		dictionary[@"stocks_alarm"] = self.stocksAlarm;
	}
	if(self.tagIds != nil){
		dictionary[@"tag_ids"] = self.tagIds;
	}
	if(self.type != nil){
		dictionary[@"type"] = self.type;
	}
	if(self.warehouseCode != nil){
		dictionary[@"warehouse_code"] = self.warehouseCode;
	}
	if(self.wishNumber != nil){
		dictionary[@"wish_number"] = self.wishNumber;
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
	if(self.activityList != nil){
		[aCoder encodeObject:self.activityList forKey:@"activity_list"];
	}
	if(self.brandId != nil){
		[aCoder encodeObject:self.brandId forKey:@"brand_id"];
	}
	if(self.buyerNumber != nil){
		[aCoder encodeObject:self.buyerNumber forKey:@"buyer_number"];
	}
	if(self.cartAction != nil){
		[aCoder encodeObject:self.cartAction forKey:@"cart_action"];
	}
	if(self.cartActionTitle != nil){
		[aCoder encodeObject:self.cartActionTitle forKey:@"cart_action_title"];
	}
	if(self.defaultSku != nil){
		[aCoder encodeObject:self.defaultSku forKey:@"default_sku"];
	}
	if(self.detailPageShowPromocard != nil){
		[aCoder encodeObject:self.detailPageShowPromocard forKey:@"detail_page_show_promocard"];
	}
	if(self.discount != nil){
		[aCoder encodeObject:self.discount forKey:@"discount"];
	}
	if(self.endTime != nil){
		[aCoder encodeObject:self.endTime forKey:@"end_time"];
	}
	if(self.extraData != nil){
		[aCoder encodeObject:self.extraData forKey:@"extra_data"];
	}
	if(self.fenQi != nil){
		[aCoder encodeObject:self.fenQi forKey:@"fen_qi"];
	}
	if(self.isDm != nil){
		[aCoder encodeObject:self.isDm forKey:@"is_dm"];
	}
	if(self.isSellable != nil){
		[aCoder encodeObject:self.isSellable forKey:@"is_sellable"];
	}
	if(self.isShowComment != nil){
		[aCoder encodeObject:self.isShowComment forKey:@"is_show_comment"];
	}
	if(self.isShowKoubei != nil){
		[aCoder encodeObject:self.isShowKoubei forKey:@"is_show_koubei"];
	}
	if(self.isShowScore != nil){
		[aCoder encodeObject:self.isShowScore forKey:@"is_show_score"];
	}
	if(self.itemId != nil){
		[aCoder encodeObject:self.itemId forKey:@"item_id"];
	}
	if(self.jumeiPrice != nil){
		[aCoder encodeObject:self.jumeiPrice forKey:@"jumei_price"];
	}
	if(self.marketPrice != nil){
		[aCoder encodeObject:self.marketPrice forKey:@"market_price"];
	}
	if(self.priceDes != nil){
		[aCoder encodeObject:self.priceDes forKey:@"price_des"];
	}
	if(self.productDesc != nil){
		[aCoder encodeObject:self.productDesc forKey:@"product_desc"];
	}
	if(self.productId != nil){
		[aCoder encodeObject:self.productId forKey:@"product_id"];
	}
	if(self.promotionSet != nil){
		[aCoder encodeObject:self.promotionSet forKey:@"promotion_set"];
	}
	if(self.relateDeal != nil){
		[aCoder encodeObject:self.relateDeal forKey:@"relate_deal"];
	}
	if(self.rightTopIcon != nil){
		[aCoder encodeObject:self.rightTopIcon forKey:@"right_top_icon"];
	}
	if(self.saleType != nil){
		[aCoder encodeObject:self.saleType forKey:@"sale_type"];
	}
	if(self.secondKillTime != nil){
		[aCoder encodeObject:self.secondKillTime forKey:@"second_kill_time"];
	}
	if(self.sellingForms != nil){
		[aCoder encodeObject:self.sellingForms forKey:@"selling_forms"];
	}
	if(self.shopInfo != nil){
		[aCoder encodeObject:self.shopInfo forKey:@"shop_info"];
	}
	if(self.showCategory != nil){
		[aCoder encodeObject:self.showCategory forKey:@"show_category"];
	}
	if(self.showSku != nil){
		[aCoder encodeObject:self.showSku forKey:@"show_sku"];
	}
	if(self.size != nil){
		[aCoder encodeObject:self.size forKey:@"size"];
	}
	if(self.startTime != nil){
		[aCoder encodeObject:self.startTime forKey:@"start_time"];
	}
	if(self.status != nil){
		[aCoder encodeObject:self.status forKey:@"status"];
	}
	if(self.statusNum != nil){
		[aCoder encodeObject:self.statusNum forKey:@"status_num"];
	}
	if(self.statusTag != nil){
		[aCoder encodeObject:self.statusTag forKey:@"status_tag"];
	}
	if(self.stocksAlarm != nil){
		[aCoder encodeObject:self.stocksAlarm forKey:@"stocks_alarm"];
	}
	if(self.tagIds != nil){
		[aCoder encodeObject:self.tagIds forKey:@"tag_ids"];
	}
	if(self.type != nil){
		[aCoder encodeObject:self.type forKey:@"type"];
	}
	if(self.warehouseCode != nil){
		[aCoder encodeObject:self.warehouseCode forKey:@"warehouse_code"];
	}
	if(self.wishNumber != nil){
		[aCoder encodeObject:self.wishNumber forKey:@"wish_number"];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.activityList = [aDecoder decodeObjectForKey:@"activity_list"];
	self.brandId = [aDecoder decodeObjectForKey:@"brand_id"];
	self.buyerNumber = [aDecoder decodeObjectForKey:@"buyer_number"];
	self.cartAction = [aDecoder decodeObjectForKey:@"cart_action"];
	self.cartActionTitle = [aDecoder decodeObjectForKey:@"cart_action_title"];
	self.defaultSku = [aDecoder decodeObjectForKey:@"default_sku"];
	self.detailPageShowPromocard = [aDecoder decodeObjectForKey:@"detail_page_show_promocard"];
	self.discount = [aDecoder decodeObjectForKey:@"discount"];
	self.endTime = [aDecoder decodeObjectForKey:@"end_time"];
	self.extraData = [aDecoder decodeObjectForKey:@"extra_data"];
	self.fenQi = [aDecoder decodeObjectForKey:@"fen_qi"];
	self.isDm = [aDecoder decodeObjectForKey:@"is_dm"];
	self.isSellable = [aDecoder decodeObjectForKey:@"is_sellable"];
	self.isShowComment = [aDecoder decodeObjectForKey:@"is_show_comment"];
	self.isShowKoubei = [aDecoder decodeObjectForKey:@"is_show_koubei"];
	self.isShowScore = [aDecoder decodeObjectForKey:@"is_show_score"];
	self.itemId = [aDecoder decodeObjectForKey:@"item_id"];
	self.jumeiPrice = [aDecoder decodeObjectForKey:@"jumei_price"];
	self.marketPrice = [aDecoder decodeObjectForKey:@"market_price"];
	self.priceDes = [aDecoder decodeObjectForKey:@"price_des"];
	self.productDesc = [aDecoder decodeObjectForKey:@"product_desc"];
	self.productId = [aDecoder decodeObjectForKey:@"product_id"];
	self.promotionSet = [aDecoder decodeObjectForKey:@"promotion_set"];
	self.relateDeal = [aDecoder decodeObjectForKey:@"relate_deal"];
	self.rightTopIcon = [aDecoder decodeObjectForKey:@"right_top_icon"];
	self.saleType = [aDecoder decodeObjectForKey:@"sale_type"];
	self.secondKillTime = [aDecoder decodeObjectForKey:@"second_kill_time"];
	self.sellingForms = [aDecoder decodeObjectForKey:@"selling_forms"];
	self.shopInfo = [aDecoder decodeObjectForKey:@"shop_info"];
	self.showCategory = [aDecoder decodeObjectForKey:@"show_category"];
	self.showSku = [aDecoder decodeObjectForKey:@"show_sku"];
	self.size = [aDecoder decodeObjectForKey:@"size"];
	self.startTime = [aDecoder decodeObjectForKey:@"start_time"];
	self.status = [aDecoder decodeObjectForKey:@"status"];
	self.statusNum = [aDecoder decodeObjectForKey:@"status_num"];
	self.statusTag = [aDecoder decodeObjectForKey:@"status_tag"];
	self.stocksAlarm = [aDecoder decodeObjectForKey:@"stocks_alarm"];
	self.tagIds = [aDecoder decodeObjectForKey:@"tag_ids"];
	self.type = [aDecoder decodeObjectForKey:@"type"];
	self.warehouseCode = [aDecoder decodeObjectForKey:@"warehouse_code"];
	self.wishNumber = [aDecoder decodeObjectForKey:@"wish_number"];
	return self;

}
@end