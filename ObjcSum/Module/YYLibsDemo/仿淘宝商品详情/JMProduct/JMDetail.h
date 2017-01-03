#import <UIKit/UIKit.h>

@interface JMDetail : NSObject

//@property (nonatomic, strong) NSString * 1200;
//@property (nonatomic, strong) NSString * 480;
//@property (nonatomic, strong) NSString * 640;
//@property (nonatomic, strong) NSString * 750;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end
