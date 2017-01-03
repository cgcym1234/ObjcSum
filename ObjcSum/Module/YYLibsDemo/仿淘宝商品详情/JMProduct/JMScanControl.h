#import <UIKit/UIKit.h>

@interface JMScanControl : NSObject

@property (nonatomic, strong) NSString * isAllowAddScan;
@property (nonatomic, strong) NSString * isShowScanBtn;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end