#import <UIKit/UIKit.h>

@interface JMSpecialTag : NSObject

@property (nonatomic, strong) NSString * book;
@property (nonatomic, strong) NSString * jmOwner;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end