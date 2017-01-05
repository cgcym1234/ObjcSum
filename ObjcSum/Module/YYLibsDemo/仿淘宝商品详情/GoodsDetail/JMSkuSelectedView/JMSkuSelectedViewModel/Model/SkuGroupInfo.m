//
//	SkuGroup.m
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "SkuGroupInfo.h"

@interface SkuGroupInfo ()
@end
@implementation SkuGroupInfo




/*
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
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[@"item"] isKindOfClass:[NSNull class]]){
		self.items = dictionary[@"item"];
	}	
	if(![dictionary[@"title"] isKindOfClass:[NSNull class]]){
		self.title = dictionary[@"title"];
	}	
	if(![dictionary[@"type"] isKindOfClass:[NSNull class]]){
		self.type = dictionary[@"type"];
	}	
	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	if(self.items != nil){
		dictionary[@"items"] = self.items;
	}
	if(self.title != nil){
		dictionary[@"title"] = self.title;
	}
	if(self.type != nil){
		dictionary[@"type"] = self.type;
	}
	return dictionary;

}

@end
