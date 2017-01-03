#import <UIKit/UIKit.h>
#import "JMDetail.h"
#import "JMDetail.h"
#import "JMDetail.h"
#import "JMDetail.h"
#import "JMDetail.h"

@interface JMDescriptionUrlSet : NSObject

@property (nonatomic, strong) JMDetail * detail;
@property (nonatomic, strong) JMDetail * pictures;
@property (nonatomic, strong) JMDetail * product;
//@property (nonatomic, strong) JMDetail * union;
@property (nonatomic, strong) JMDetail * usage;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end
