//
//  YYWebImageManager.h
//  ObjcSum
//
//  Created by sihuan on 16/2/17.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import <UIKit/UIKit.h>

#if __has_include(<YYWebImage/YYWebImage.h>)
#import <YYWebImage/YYImageCache.h>
#else
#import "YYImageCache.h"
#endif

@class YYWebImageOperation;

typedef NS_OPTIONS(NSUInteger, YYWebImageOptions) {
    ///当下载图片的时候会在状态栏显示一个当前网络状况
    YYWebImageOptionShowNetworkActivity = 1 << 0,
    
    ///能够像浏览器一样显示一个逐渐显示的图片,有三种方式:缓缓显示,中间带交叉效果,基于基线显示.这里可以看demo理解三种模式的区别
    YYWebImageOptionProgressive = 1 << 1,
    
    ///下载的时候显示一个模糊的渐渐显示的JPEG图片,或者一个交错显示的PNG图片,具体效果还是看demo
    ///这种模式会忽略baseline这种显示模式来获得更好的用户体验
    YYWebImageOptionProgressiveBlur = 1 << 2,
    
    ///使用NSURLCache来代替YYImageCache
    YYWebImageOptionUseNSURLCache = 1 << 3,
    
    ///允许未受信任的SSL证书,PS:基于我的理解以及对比SDWebImage,这种模式一般用户调试过程,不用于生产过程
    YYWebImageOptionAllowInvalidSSLCertificates = 1 << 4,
    
    ///app进入后台的时候允许后台下载图片
    YYWebImageOptionAllowBackgroundTask = 1 << 5,
    
    ///把cookies存储进NSHTTPCookieStore
    YYWebImageOptionHandleCookies = 1 << 6,
    
    ///从远程下载图片并且刷新图片缓存,这种模式可以用于更换了图片内容,但是图片URL不替换
    YYWebImageOptionRefreshImageCache = 1 << 7,
    
    ///不从硬盘缓存加载图片,同时也不会把图片缓存进磁盘
    YYWebImageOptionIgnoreDiskCache = 1 << 8,
    
    ///当没有通过一个URL下载到一个新的图片的时候不去修改图片
    YYWebImageOptionIgnorePlaceHolder = 1 << 9,
    
    ///忽略图片解码
    ///这种模式可能用于下载的时候并不去显示该图片
    YYWebImageOptionIgnoreImageDecoding = 1 << 10,
    
    ///忽略多frame图片解码
    ///这种模式会将 GIF/APNG/WebP/ICO图片转换为单一frame的图片,开发中如果需求图片固定显示大小,这个模式可能会有用
    YYWebImageOptionIgnoreAnimatedImage = 1 << 11,
    
    ///设置图片的时候带有一个fade的动画效果
    ///会给view's layer添加一个淡入淡出动画效果来获取更好的用户体验
    YYWebImageOptionSetImageWithFadeAnimation = 1 << 12,
    
    ///当图片下载完成之前不去设置它
    ///你可以手动设置图片
    YYWebImageOptionAvoidSetImage = 1 << 13,
    
    ///这种模式会把URL加进黑名单当下载失败的时候,黑名单存储在内存中,所以这种模式不会尝试重复下载
    YYWebImageOptionIgnoreFailedURL = 1 << 14,
};

///用来告诉我们图片来源
typedef NS_ENUM(NSUInteger, YYWebImageFromType) {
    YYWebImageFromTypeNone = 0,
    
    ///立刻从内存中查找图片,如果你调用了"setImageWithURL..."并且图片已经存在于内存,你会从相同的回调里面得到这个值
    YYWebImageFromMemoryCacheFast,
    
    /// Fetched from memory cache. ///从内存中来
    YYWebImageFromMemoryCache,
    
    /// Fetched from disk cache. ///从磁盘中来
    YYWebImageFromDiskCache,
    
    /// Fetched from remote (web or file path).///从远程下载的,可以是web或者一个路径
    YYWebImageFromRemote,
};

///用来告诉我们图片下载的完成度的
typedef NS_ENUM(NSUInteger, YYWebImageStage) {
    /// Incomplete, progressive image.///未完成,带进度的image
    YYWebImageStageProgress  = -1,
    
    /// Cancelled.///已经取消了
    YYWebImageStageCancelled = 0,
    
    /// Finished (succeed or failed).///已经结束,可能是成功或者失败
    YYWebImageStageFinished  = 1,
};

///从远程下载完成过程的回调,参数receivedSize是已经下载的大小,expectedSize是总共大小,因此可以通过receivedSize/expectedSize获得progress,如果expectedSize = -1代表着不知道一共有多大
typedef void(^YYWebImageProgressBlock)(NSInteger receivedSize, NSInteger expectedSize);

/**
 图片从远程下载完成之前会执行这个block,用来执行一些额外的操作
 @discussion 当'YYWebImageCompletionBlock'这个完成度额回调在下载完成之前会执行这个回调用来给你一个机会做一些额外的处理,比如用来修改图片尺寸等.如果这里不需要对图片进行transform处理,只会返回image这一个参数
 @example 你可以裁剪/模糊图片,或者添加一些边角通过以下代码:
 ^(UIImage *image, NSURL *url){
 //可能你需要创建一个 @autoreleasepool来限制内存开销
 image = [image yy_imageByResizeToSize:CGSizeMake(100, 100) contentMode:UIViewContentModeScaleAspectFill];
 image = [image yy_imageByBlurRadius:20 tintColor:nil tintMode:kCGBlendModeNormal saturation:1.2 maskImage:nil];
 image = [image yy_imageByRoundCornerRadius:5];
 return image;
 }
 */
typedef UIImage *(^YYWebImageTransformBlock)(UIImage *image, NSURL *url);

/**
 这个block会在当图片下载完成或者取消的时候调用
 
 @param image       The image.
 @param url         图片url,远程或者本地路径
 @param from        图片从哪来,
 @param error       图片下载中的错误
 @param finished    如果请求取消掉了,返回NO,其他是YES
 */

typedef void (^YYWebImageCompletionBlock)(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error);

/**
 *  用来创建和管理网络图片任务的管理器,这个类其实就一个作用,管理生成一个YYWebImageOperation实例
 */
@interface YYWebImageManager : NSObject

+ (instancetype)sharedManager;

/**
 *  生成一个manager,带有缓存与操作队列
 *
 *  @param cache 图片缓存用到的manager,
 *  @param queue 图片请求,调度运行的请求队列
 *
 *  @return 一个新的manager
 */
- (instancetype)initWithCache:(YYImageCache *)cache queue:(NSOperationQueue *)queue
    NS_DESIGNATED_INITIALIZER;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

/**
 *  创建返回一个新的operation,这个operation会立刻开始执行
 *
 *  @param url        图片url,可以是远程或者本地路径
 *  @param options    控制下载的option
 *  @param progress   进度block,会在后台线程的时候调用,传空的话会禁用此特性
 *  @param transform  进入后台线程会调用此block,传空禁用此block
 *  @param completion 进入后台线程会调用此block,传空禁用此block
 *
 *  @return 一个新的图片operation
 */
- (YYWebImageOperation *)requestImageWithURL:(NSURL *)url
                                     options:(YYWebImageOptions)options
                                    progress:(YYWebImageProgressBlock)progress
                                   transform:(YYWebImageTransformBlock)transform
                                  completion:(YYWebImageCompletionBlock)completion;


/**
 *  图片请求用到的缓存,可以设置为nil来禁用缓存
 */
@property (nonatomic, strong) YYImageCache *cache;

/**
 *  图片的请求调度运行的队列
 你不通过队列新建一个新的operation的时候可以给这个值置为nil
 
 你可以用这个队列来控制请求的最大值最小值,获得当前操作队列的状态值,或者来取消这个manager中所有的operation
 */
@property (nonatomic, strong) NSOperationQueue *queue;

/**
 *  默认值为nil,共享的图片变换的过程,
 当调用`requestImageWithURL:options:progress:transform:completion`并且`transform`为nil时,这个block才有用
 */
@property (nonatomic, copy) YYWebImageTransformBlock sharedTransformBlock;

/**
 *  请求超时时间,默认15秒
 */
@property (nonatomic, assign) NSTimeInterval timeout;

/**
 *  NSURLCredential使用的用户名,默认为nil
 */
@property (nonatomic, strong) NSString *username;

/**
 *  同上,密码,默认为nil
 */
@property (nonatomic, strong) NSString *password;

/**
 *  图片TTTP的请求头,默认是"Accept:image/webp,image/\*;q=0.8"
 */
@property (nonatomic, copy) NSDictionary *headers;

/**
 *  每个图片http请求做额外的HTTP header操作的时候会调用这个block,默认为nil
 */
@property (nonatomic, copy) NSDictionary *(^headersFilter)(NSURL *url, NSDictionary *header);

/**
 *  每个图片的操作都会调用这个block,默认为nil
 使用这个block能够给URL提供一个自定义的的图片
 */
@property (nonatomic, copy) NSString *(^cacheKeyFilter)(NSURL *url);


/**
 *  返回URL的HTTP headers
 *
 *  @param url 当前URL
 *
 *  @return http header
 */
- (NSDictionary *)headersForURL:(NSURL *)url;

/**
 *  给URL返回一个cacheKey
 *
 *  @param url 该URL
 *
 *  @return cache key在YYImageCache中有用到
 */
- (NSString *)cacheKeyForURL:(NSURL *)url;

/**
 *  增加活跃的网络请求数量
 如果在增加前数量为0,那么会在状态来开始有一个网络菊花动画
 该方法是线程安全的
 该方法不会对APP扩展产生影响
 */
+ (void)incrementNetworkActivityCount;

/**
 *  与上面对应,减少活跃的网络请求数量,如果执行完毕之后数量变为0,那么会停止在状态栏的网络指示器动画
 线程安全
 不会影响APP扩展
 */
+ (void)decrementNetworkActivityCount;

/**
 *  获取当前活跃的网络请求数量
 *  线程安全
 不会影响APP扩展
 *  @return
 */
+ (NSInteger)currentNetworkActivityCount;

@end































