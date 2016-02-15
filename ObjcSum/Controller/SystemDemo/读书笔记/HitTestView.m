//
//  HitTestView.m
//  ObjcSum
//
//  Created by sihuan on 16/2/3.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "HitTestView.h"

// Return the alpha byte offset
static NSUInteger alphaOffset(NSInteger x, NSInteger y, NSInteger w) {
    return y * w*4 + x*4 + 0;
}

// Return a byte array of image
NSData *getBitmapFromImage(UIImage *sourceImage) {
    if (!sourceImage) return nil;
    
    // Establish color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    if (colorSpace == NULL)
    {
        NSLog(@"Error creating RGB color space");
        return nil;
    }
    
    // Establish context
    int width = sourceImage.size.width;
    int height = sourceImage.size.height;
    CGContextRef context = CGBitmapContextCreate(NULL, width, height, 8, width * 4, colorSpace, (CGBitmapInfo) kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(colorSpace );
    if (context == NULL)
    {
        NSLog(@"Error creating context");
        return nil;
    }
    
    // Draw source into context bytes
    CGRect rect = (CGRect){.size = sourceImage.size};
    CGContextDrawImage(context, rect, sourceImage.CGImage);
    
    // Create NSData from bytes
    NSData *data = [NSData dataWithBytes:CGBitmapContextGetData(context) length:(width * height * 4)];
    CGContextRelease(context);
    
    return data;
}

@implementation HitTestView {
    CGPoint previousLocation;
    NSData *data;
}

- (instancetype)initWithImage:(UIImage *)anImage
{
    self = [super init];
    if (self)
    {
        self.userInteractionEnabled = YES;
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        self.gestureRecognizers = @[panRecognizer];
        data = getBitmapFromImage(anImage);
        self.image = anImage;
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Promote the touched view
    [self.superview bringSubviewToFront:self];
    
    // Remember original location
    previousLocation = self.center;
}

- (void)handlePan:(UIPanGestureRecognizer *)uigr
{
    CGPoint translation = [uigr translationInView:self.superview];
    CGPoint newcenter = CGPointMake(previousLocation.x + translation.x, previousLocation.y + translation.y);
    
    // Bound movement into parent bounds
    float halfx = CGRectGetMidX(self.bounds);
    newcenter.x = MAX(halfx, newcenter.x);
    newcenter.x = MIN(self.superview.bounds.size.width - halfx, newcenter.x);
    
    float halfy = CGRectGetMidY(self.bounds);
    newcenter.y = MAX(halfy, newcenter.y);
    newcenter.y = MIN(self.superview.bounds.size.height - halfy, newcenter.y);
    
    // Set new location
    self.center = newcenter;
}



#pragma mark - 方式一 使用pointInside根据条件判断触摸点是否在View上
/**
 *  返回YES表示触摸点位于视图内，
 可以用于规则图形判断
 */
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    
    
    if (!CGRectContainsPoint(self.bounds, point)) {
        return NO;
    }
    
    Byte *bytes = (Byte *)data.bytes;
    NSUInteger offset = alphaOffset(point.x, point.y, self.image.size.width);
    
    /**
     *  这里使用85，意思是受测像素的不透明程度至少是33%（85/255），才认为点击了这个视图。
     可以自己的需要来调整，
     */
    return (bytes[offset] > 85);
}

#pragma mark - 方式二 针对位图的触摸测试

/**
 *  如果View是一个不规则复杂图形，使用pointInside则不好判断，
 必要针对位图来做测试，才能判断是否发生了触摸。
 
 对基于图像的View(image-based view)来说，位图是一种按字节排列的信息，
 它描述了该view的内容，从而可以判断是触摸了图中不透明部分(solid portion)，
 还是透明部分，如果是后者，应该判断view下面的视图是否受到触摸
 */


@end


















