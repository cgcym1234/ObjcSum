//
//  UIImageView+JMNetworking.h
//  JMKit
//
//  Created by Pinglin Tang on 13-5-3.
//  Copyright (c) 2013年 Jumei Inc. All rights reserved.
//

#if __IPHONE_OS_VERSION_MIN_REQUIRED
#import <UIKit/UIKit.h>

/**
 This category adds methods to the UIKit framework's `UIImageView` class. The methods in this category provide support for loading remote images asynchronously from a URL.
 */



@interface UIImageView (JMNetworking)
/**
 *	取得HTTP网络的图片,图片加载完后播出动画
 *
 *	@param	NSArray<NSURL>, NSURL的数组
 *	@param	animation 加载完后播出动画,nil为不播出动画
 */
- (void)setImageWithURLArray:(NSArray *)imageArray
                   animation:(CAAnimation *)animation;


/**
 *	取得HTTP网络的图片,图片加载完后播出动画
 *
 *	@param	http's URL
 *	@param	animation 加载完后播出动画,nil为不播出动画
 */
- (void)setImageWithURL:(NSURL *)url
              animation:(CAAnimation *)animation;

/**
 *	取得HTTP网络的图片
 *
 *	@param	url	http's URL
 *	@param	imageScale	图片缩放大小, 默认为UIScreen的sacle, 传0当做默认处理
 */
- (void)setImageWithURL:(NSURL *)url
             imageScale:(CGFloat)imageScale;

/**
 *	取得HTTP网络的图片
 *
 *	@param	url	url	http's URL
 *	@param	priority	网络请求优先级
 */
- (void)setImageWithURL:(NSURL *)url
               priority:(NSOperationQueuePriority)priority;

/**
 *	取得HTTP网络的图片,图片加载完后播出动画
 *
 *	@param	url	http's URL
 *	@param	placeholderImage	占位图片
 *	@param	animation	加载完后播出动画,nil为不播出动画
 */
- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholderImage
              animation:(CAAnimation *)animation;



/**
 *	取得HTTP网络的图片
 *
 *	@param	url	http's URL
 *	@param	animation	加载完后播出动画,nil为不播出动画
 *	@param	priority	网络请求优先级
 */
- (void)setImageWithURL:(NSURL *)url
             imageScale:(CGFloat)imageScale
               priority:(NSOperationQueuePriority)priority;

/**
 *	取得HTTP网络的图片
 *
 *	@param	url	http's URL
 *	@param	animation	加载完后播出动画,nil为不播出动画
 *	@param	imageScale	图片缩放大小, 默认为UIScreen的sacle, 传0当做默认处理
 */
- (void)setImageWithURL:(NSURL *)url
              animation:(CAAnimation *)animation
             imageScale:(CGFloat)imageScale;

/**
 *	取得HTTP网络的图片,图片加载完后播出动画
 *
 *	@param	url	http's URL
 *	@param	placeholderImage	占位图片
 *	@param	animation	加载完后播出动画,nil为不播出动画
 *	@param	imageScale	图片缩放大小, 默认为UIScreen的sacle, 传0当做默认处理
 */
- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholderImage
              animation:(CAAnimation *)animation
             imageScale:(CGFloat)imageScale;

/**
 *	取得HTTP网络的图片,图片加载完后播出动画
 *
 *	@param	url	http's URL
 *	@param	animation	加载完后播出动画,nil为不播出动画
 *	@param	imageScale	图片缩放大小, 默认为UIScreen的sacle, 传0当做默认处理
 *	@param	priority	NSOperationQueuePriority 图片加载优先级
 */
- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholderImage
              animation:(CAAnimation *)animation
             imageScale:(CGFloat)imageScale
               priority:(NSOperationQueuePriority)priority;

/**
 *	取得HTTP网络的图片,图片加载完后播出动画
 *  @dis
 *
 *	@param	urlRequest	http's URL
 *	@param	placeholderImage	占位图片
 *	@param	animation	加载完后播出动画,nil为不播出动画
 *	@param	imageScale	图片缩放大小, 默认为UIScreen的sacle, 传0当做默认处理
 *	@param	priority	NSOperationQueuePriority 图片加载优先级
 *  @param  success     成功的回调
 *  @param  failure     失败的回调
 */
- (void)setImageWithURLRequest:(NSURLRequest *)urlRequest
              placeholderImage:(UIImage *)placeholderImage
                     animation:(CAAnimation *)animation
                    imageScale:(CGFloat)imageScale
                      priority:(NSOperationQueuePriority)priority
                       success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image))success
                       failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure;
/**
 Cancels any executing image request operation for the receiver, if one exists.
 */
- (void)cancelImageRequestOperation;

//获取本地image
- (BOOL )imageCachedWithURL:(NSURL *)url completeHandle:(void (^)(UIImage *image))completeHandle;

@end

#endif