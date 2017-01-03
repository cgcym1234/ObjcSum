//
//	JMImageUrlSet.m
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "JMImageUrlSet.h"

@interface JMImageUrlSet ()
@end
@implementation JMImageUrlSet




//"image_url_set": {
//    "product_gallery": [{
//        "url": {
//            "480": "http:\/\/mp1.jmstatic.com\/c_zoom,w_480,q_70\/product\/001\/832\/1832146_std\/1832146_1000_1000.jpg?v=1479983828",
//            "640": "http:\/\/mp1.jmstatic.com\/c_zoom,w_640,q_70\/product\/001\/832\/1832146_std\/1832146_1000_1000.jpg?v=1479983828",
//            "750": "http:\/\/mp1.jmstatic.com\/c_zoom,w_750,q_70\/product\/001\/832\/1832146_std\/1832146_1000_1000.jpg?v=1479983828",
//            "1200": "http:\/\/mp1.jmstatic.com\/c_zoom,w_1200,q_70\/product\/001\/832\/1832146_std\/1832146_1000_1000.jpg?v=1479983828"
//        },
//        "rgb": "#FFFFFF"
//    }, {
//        "url": {
//            "480": "http:\/\/mp1.jmstatic.com\/c_zoom,w_480,q_70\/product\/001\/832\/1832146_std\/1832146_1_1000_1000.jpg?v=1479983837",
//            "640": "http:\/\/mp1.jmstatic.com\/c_zoom,w_640,q_70\/product\/001\/832\/1832146_std\/1832146_1_1000_1000.jpg?v=1479983837",
//            "750": "http:\/\/mp1.jmstatic.com\/c_zoom,w_750,q_70\/product\/001\/832\/1832146_std\/1832146_1_1000_1000.jpg?v=1479983837",
//            "1200": "http:\/\/mp1.jmstatic.com\/c_zoom,w_1200,q_70\/product\/001\/832\/1832146_std\/1832146_1_1000_1000.jpg?v=1479983837"
//        },
//        "rgb": "#FFFFFF"
//    }, {
//        "url": {
//            "480": "http:\/\/mp1.jmstatic.com\/c_zoom,w_480,q_70\/product\/001\/832\/1832146_std\/1832146_2_1000_1000.jpg?v=1479983844",
//            "640": "http:\/\/mp1.jmstatic.com\/c_zoom,w_640,q_70\/product\/001\/832\/1832146_std\/1832146_2_1000_1000.jpg?v=1479983844",
//            "750": "http:\/\/mp1.jmstatic.com\/c_zoom,w_750,q_70\/product\/001\/832\/1832146_std\/1832146_2_1000_1000.jpg?v=1479983844",
//            "1200": "http:\/\/mp1.jmstatic.com\/c_zoom,w_1200,q_70\/product\/001\/832\/1832146_std\/1832146_2_1000_1000.jpg?v=1479983844"
//        },
//        "rgb": "#FFFFFF"
//    }, {
//        "url": {
//            "480": "http:\/\/mp1.jmstatic.com\/c_zoom,w_480,q_70\/product\/001\/832\/1832146_std\/1832146_3_1000_1000.jpg?v=1479983853",
//            "640": "http:\/\/mp1.jmstatic.com\/c_zoom,w_640,q_70\/product\/001\/832\/1832146_std\/1832146_3_1000_1000.jpg?v=1479983853",
//            "750": "http:\/\/mp1.jmstatic.com\/c_zoom,w_750,q_70\/product\/001\/832\/1832146_std\/1832146_3_1000_1000.jpg?v=1479983853",
//            "1200": "http:\/\/mp1.jmstatic.com\/c_zoom,w_1200,q_70\/product\/001\/832\/1832146_std\/1832146_3_1000_1000.jpg?v=1479983853"
//        },
//        "rgb": "#FFFFFF"
//    }, {
//        "url": {
//            "480": "http:\/\/mp1.jmstatic.com\/c_zoom,w_480,q_70\/product\/001\/832\/1832146_std\/1832146_4_1000_1000.jpg?v=1479983860",
//            "640": "http:\/\/mp1.jmstatic.com\/c_zoom,w_640,q_70\/product\/001\/832\/1832146_std\/1832146_4_1000_1000.jpg?v=1479983860",
//            "750": "http:\/\/mp1.jmstatic.com\/c_zoom,w_750,q_70\/product\/001\/832\/1832146_std\/1832146_4_1000_1000.jpg?v=1479983860",
//            "1200": "http:\/\/mp1.jmstatic.com\/c_zoom,w_1200,q_70\/product\/001\/832\/1832146_std\/1832146_4_1000_1000.jpg?v=1479983860"
//        },
//        "rgb": "#FFFFFF"
//    }, {
//        "url": {
//            "480": "http:\/\/mp1.jmstatic.com\/c_zoom,w_480,q_70\/product\/001\/832\/1832146_std\/1832146_5_1000_1000.jpg?v=1479983870",
//            "640": "http:\/\/mp1.jmstatic.com\/c_zoom,w_640,q_70\/product\/001\/832\/1832146_std\/1832146_5_1000_1000.jpg?v=1479983870",
//            "750": "http:\/\/mp1.jmstatic.com\/c_zoom,w_750,q_70\/product\/001\/832\/1832146_std\/1832146_5_1000_1000.jpg?v=1479983870",
//            "1200": "http:\/\/mp1.jmstatic.com\/c_zoom,w_1200,q_70\/product\/001\/832\/1832146_std\/1832146_5_1000_1000.jpg?v=1479983870"
//        },
//        "rgb": "#FFFFFF"
//    }]
//},

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(dictionary[@"product_gallery"] != nil && [dictionary[@"product_gallery"] isKindOfClass:[NSArray class]]){
		NSArray * productGalleryDictionaries = dictionary[@"product_gallery"];
		NSMutableArray * productGalleryItems = [NSMutableArray array];
		for(NSDictionary * productGalleryDictionary in productGalleryDictionaries){
			JMProductGallery * productGalleryItem = [[JMProductGallery alloc] initWithDictionary:productGalleryDictionary];
			[productGalleryItems addObject:productGalleryItem];
		}
		self.productGallery = productGalleryItems;
	}
	if(![dictionary[@"url"] isKindOfClass:[NSNull class]]){
//		self.url = [[JMDetail alloc] initWithDictionary:dictionary[@"url"]];
	}

	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	if(self.productGallery != nil){
		NSMutableArray * dictionaryElements = [NSMutableArray array];
		for(JMProductGallery * productGalleryElement in self.productGallery){
			[dictionaryElements addObject:[productGalleryElement toDictionary]];
		}
		dictionary[@"product_gallery"] = dictionaryElements;
	}
//	if(self.url != nil){
//		dictionary[@"url"] = [self.url toDictionary];
//	}
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
	if(self.productGallery != nil){
		[aCoder encodeObject:self.productGallery forKey:@"product_gallery"];
	}
//	if(self.url != nil){
//		[aCoder encodeObject:self.url forKey:@"url"];
//	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.productGallery = [aDecoder decodeObjectForKey:@"product_gallery"];
//	self.url = [aDecoder decodeObjectForKey:@"url"];
	return self;

}
@end
