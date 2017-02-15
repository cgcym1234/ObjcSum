//
//	SkuGroup.m
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "SkuGroupInfo.h"
#import "JMDataUtility.h"

@implementation SkuGroupItem

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    self.value = stringInDictionaryForKey(dictionary, @"value");
    self.img = stringInDictionaryForKey(dictionary, @"img");
    return self;
}

@end


@interface SkuGroupInfo ()
@end
@implementation SkuGroupInfo


/*
"attr_list":[
             {
                 "title":"颜色",
                 "type":"attribute",
                 "item":[
                         {
                             "value":"红色",
                             "img":"http://p0.jmstatic.com/product/003/068/3068537_std/3068537_350_350.jpg"
                         },
                         {
                             "value":"黄色",
                             "img":"http://p0.jmstatic.com/product/002/951/2951903_std/2951903_350_350.jpg"
                         },
                         {
                             "value":"蓝色",
                             "img":"http://p0.jmstatic.com/product/002/467/2467081_std/2467081_350_350.jpg"
                         },
                         {
                             "value":"很长的颜色很长的颜色很长的颜色很长的颜色很长的颜色很长的颜色",
                             "img":"http://p0.jmstatic.com/product/003/068/3068537_std/3068537_350_350.jpg"
                         }
                         ],
                 "spu":"1"
             },
             {
                 "title":"尺码",
                 "type":"size",
                 "item":[
                         {
                             "value":"33",
                             "img":"http://p0.jmstatic.com/product/003/068/3068537_std/3068537_350_350.jpg"
                         },
                         {
                             "value":"34",
                             "img":"http://p0.jmstatic.com/product/003/068/3068537_std/3068537_350_350.jpg"
                         },
                         {
                             "value":"35",
                             "img":"http://p0.jmstatic.com/product/003/068/3068537_std/3068537_350_350.jpg"
                         },
                         {
                             "value":"36",
                             "img":"http://p0.jmstatic.com/product/003/068/3068537_std/3068537_350_350.jpg"
                         }
                         ],
                 "spu":"0"
             }
     ],
*/

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
    NSArray *items = arrayInDictionaryForKey(dictionary, @"item");
    NSMutableArray *groupItems = [NSMutableArray new];
    for (NSDictionary *dict in items) {
        [groupItems addObject:[[SkuGroupItem alloc] initWithDictionary:dict]];
    }
    self.items = groupItems;
    self.title = stringInDictionaryForKey(dictionary, @"title");
    self.type = stringInDictionaryForKey(dictionary, @"type");
    self.canChangeImage = [stringInDictionaryForKey(dictionary, @"spu") boolValue];
	return self;
}



@end
