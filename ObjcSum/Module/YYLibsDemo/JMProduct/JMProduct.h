#import <UIKit/UIKit.h>
#import "JMData.h"
#import "JMExtra.h"

@interface JMProduct : NSObject

@property (nonatomic, strong) NSString * action;
@property (nonatomic, strong) NSString * code;
@property (nonatomic, strong) JMData * data;
@property (nonatomic, strong) JMExtra * extra;
@property (nonatomic, strong) NSString * message;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end