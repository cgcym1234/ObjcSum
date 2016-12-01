#import <UIKit/UIKit.h>

@interface JMIconTag : NSObject

@property (nonatomic, strong) NSString * groupNum;
@property (nonatomic, strong) NSString * label;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * status;
@property (nonatomic, strong) NSString * text;
@property (nonatomic, strong) NSString * urlTag;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end