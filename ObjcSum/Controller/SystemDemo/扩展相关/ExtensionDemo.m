//
//  ExtensionDemo.m
//  ObjcSum
//
//  Created by sihuan on 15/11/10.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import "ExtensionDemo.h"

#import <MobileCoreServices/MobileCoreServices.h>

@interface ExtensionDemo ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation ExtensionDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - 扩展基本使用host app与扩展如何通过扩展上下文互传数据
/**
 *  假设你现在需要在host app中将一张图片传递给扩展做滤镜处理
 */

#pragma mark - 扩展使用步骤1：host app中 传递数据
- (void)extensionDemo1 {
    UIImage *originedImage = self.imageView.image;
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:@[originedImage]  applicationActivities:nil];
    [self presentViewController:activityController animated:YES completion:nil];

    #pragma mark - 扩展使用步骤4：host app中接收来自扩展传回的数据
    [activityController setCompletionWithItemsHandler:^(NSString * __nullable activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError) {
        if (returnedItems.count > 0) {
            NSExtensionItem *extensionItem = returnedItems.firstObject;
            NSItemProvider *imageItemProvider = [extensionItem attachments].firstObject;
            NSString *typeImage = (NSString *)kUTTypeImage;
            if ([imageItemProvider hasItemConformingToTypeIdentifier:typeImage]) {
                [imageItemProvider loadItemForTypeIdentifier:typeImage options:nil completionHandler:^(id<NSSecureCoding>  _Nullable item, NSError * _Null_unspecified error) {
                    if (item) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //                    self.imageView.image = image;
                            
                        });
                    }
                }];
            }
        }
    }];
    
}

#pragma mark - 扩展使用步骤2：extention 中 获取数据，并操作
/**
 *  当用户在弹出的Action列表中选择了扩展，扩展将被启动，然后在扩展的viewDidLoad方法中，通过extensionContext检索host app传回的数据项。
 */
- (void)extensionDemo2 {
    /**
     *  extensionContext表示一个扩展到host app的连接。
     通过extionContent，你可以访问一个NSExtensionItem的数组，每一个NSExtensionItem项表示从host app传回的一个逻辑数据单元。
     */
    NSExtensionItem *imageItem = [self.extensionContext.inputItems firstObject];
    if (!imageItem) {
        return;
    }
    
    /**
     *  你可以从NSExtensionItem项的attachments属性中获得附件数据，如音频，视频，图片等。
     每一个附件用NSItemProvider实例表示。
     */
    NSItemProvider *imageItemProvider = [[imageItem attachments] firstObject];
    if (!imageItemProvider) {
        return;
    }
    
    /**
     *  (NSString *)kUTTypeImag 表示图片
     *
     *  如果你需要处理的是文本类型，参数则为(NSString *)kUTTypeText
     */
    NSString *typeImage = (NSString *)kUTTypeImage;
    
    if ([imageItemProvider hasItemConformingToTypeIdentifier:typeImage]) {
        [imageItemProvider loadItemForTypeIdentifier:typeImage options:nil completionHandler:^(id<NSSecureCoding>  _Nullable item, NSError * _Null_unspecified error) {
            if (item) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    //                    self.imageView.image = image;
                    
                });
            }
        }];
    }
    
    //处理文本
    if([imageItemProvider hasItemConformingToTypeIdentifier:(NSString *)kUTTypeText]){
        
        [imageItemProvider loadItemForTypeIdentifier:(NSString *)kUTTypeText options:nil completionHandler:^(NSAttributedString *string, NSError *error) {
            
            if (string) {
                
                // 在这里处理文本
                
            }
            
        }];
        
    }

}


#pragma mark - 扩展使用步骤3：extention 中 将处理好的数据再传给host app。
//当扩展处理完host app传回的图片数据后，它需要将处理好的数据再传给host app。在扩展中的代码如下：
- (void)extensionDemo3 {
    UIImage *image;
    NSExtensionItem *extensionItem = [[NSExtensionItem alloc] init];
    NSItemProvider *itemProvider = [[NSItemProvider alloc] initWithItem:image typeIdentifier:(NSString *)kUTTypeText];
    [extensionItem setAttachments:@[itemProvider]];
    [self.extensionContext completeRequestReturningItems:@[extensionItem] completionHandler:^(BOOL expired) {
        NSLog(@"completeRequestReturningItems");
    }];
}


#pragma mark - 在扩展中打开containing app的代码如下：
- (void)openContainingApp {
    NSURL *url = [NSURL URLWithString:@"ExtensionDemo://"];
    [self.extensionContext openURL:url completionHandler:^(BOOL success) {
        NSLog(@"openContainingApp %d", success);
    }];
}

@end
