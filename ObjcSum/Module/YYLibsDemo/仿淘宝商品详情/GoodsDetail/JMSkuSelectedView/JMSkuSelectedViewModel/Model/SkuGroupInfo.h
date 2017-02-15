#import <UIKit/UIKit.h>

@interface SkuGroupItem : NSObject

@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *img;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end


@interface SkuGroupInfo : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *type;

@property (nonatomic, strong) NSArray<SkuGroupItem *> *items;

/*该分组下的属性是否支持点击切换图片*/
@property (nonatomic, assign) BOOL canChangeImage;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
