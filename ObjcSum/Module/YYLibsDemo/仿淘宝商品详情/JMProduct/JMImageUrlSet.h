#import <UIKit/UIKit.h>
#import "JMProductGallery.h"

@interface JMImageUrlSet : NSObject

@property (nonatomic, strong) NSArray * productGallery;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end
