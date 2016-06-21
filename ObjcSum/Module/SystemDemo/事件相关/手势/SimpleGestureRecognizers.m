//
//  SimpleGestureRecognizers.m
//  ObjcSum
//
//  Created by sihuan on 16/3/31.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "SimpleGestureRecognizers.h"
#import "UIView+YYMessage.h"


#pragma mark - Const

static BOOL  first = YES;

static NSString * const KeyCell = @"KeyCell";

@interface SimpleGestureRecognizers ()
<UIGestureRecognizerDelegate>

@property (nonatomic, strong) IBOutlet UITapGestureRecognizer *tapRecognizer;
@property (nonatomic, strong) IBOutlet UISwipeGestureRecognizer *swipeLeftRecognizer;
@property (nonatomic, strong) IBOutlet UIPanGestureRecognizer *panRecognizer;
@property (nonatomic, strong) IBOutlet UIRotationGestureRecognizer *rotateRecognizer;

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UISegmentedControl *segmentedControl;


@end

@implementation SimpleGestureRecognizers


#pragma mark - Initialization

- (void)awakeFromNib {
    [self setContext];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    /**
     不能用下面的方式来将self替换成xib，会crash，如下
     *  This coder requires that replaced objects be returned from initWithCoder:
     
     建议的方式是将xib中load的view，作为自己的subView
     http://stackoverflow.com/questions/21898190/creating-a-reusable-uiview-with-xib-and-loading-from-storyboard
     */
    first = NO;
    if (first) {
        first = NO;
        self = [SimpleGestureRecognizers newInstanceFromNib];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setContext];
    }
    return self;
}


- (void)setContext {
    self.userInteractionEnabled = YES;
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.imageView];
    [self addGestureRecognizer:self.panRecognizer];
}


#pragma mark - Override

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)drawImageForGestureRecognizer:(UIGestureRecognizer *)recognizer atPoint:(CGPoint)centerPoint {
    
    NSString *imageName = @"rotation.png";
    
    if ([recognizer isMemberOfClass:[UITapGestureRecognizer class]]) {
        imageName = @"tap.png";
    }
    else if ([recognizer isMemberOfClass:[UIRotationGestureRecognizer class]]) {
        imageName = @"rotation.png";
    }
    else if ([recognizer isMemberOfClass:[UISwipeGestureRecognizer class]]) {
        imageName = @"swipe.png";
    }
    
    self.imageView.image = [UIImage imageNamed:imageName];
    self.imageView.center = centerPoint;
    self.imageView.alpha = 1.0;
}


#pragma mark - Action

- (IBAction)takeLeftSwipeRecognitionEnabledFrom:(UISegmentedControl *)segmentedControl {
    if (segmentedControl.selectedSegmentIndex == 0) {
        [self addGestureRecognizer:self.swipeLeftRecognizer];
    } else {
        [self removeGestureRecognizer:self.swipeLeftRecognizer];
    }
}

- (IBAction)showGestureForTapRecognizer:(UITapGestureRecognizer *)recognizer {
    CGPoint location = [recognizer locationInView:self];
    [self drawImageForGestureRecognizer:recognizer atPoint:location];
    [UIView animateWithDuration:0.5 animations:^{
        self.imageView.alpha = 0.0;
    }];
}

- (IBAction)showGestureForSwipeRecognizer:(UISwipeGestureRecognizer *)recognizer {
    CGPoint location = [recognizer locationInView:self];
    [self drawImageForGestureRecognizer:recognizer atPoint:location];
    
    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        location.x -= 80;
    } else {
        location.x += 80;
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        self.imageView.alpha = 0.0;
        self.imageView.center = location;
    }];
}

- (IBAction)showGestureForPanRecognizer:(UIPanGestureRecognizer *)recognizer {
    NSLog(@"%s, %ld", __PRETTY_FUNCTION__, (long)recognizer.state);
    CGPoint location = [recognizer locationInView:self];
    [self drawImageForGestureRecognizer:recognizer atPoint:location];
    
    if (recognizer.state == UIGestureRecognizerStateEnded ||
        recognizer.state == UIGestureRecognizerStateCancelled) {
        [UIView animateWithDuration:0.5 animations:^{
            self.imageView.alpha = 0.0;
            self.imageView.transform = CGAffineTransformIdentity;
        }];
    }
}

- (IBAction)showGestureForRotation:(UIRotationGestureRecognizer *)recognizer {
    CGPoint location = [recognizer locationInView:self];
    CGAffineTransform transform = CGAffineTransformMakeRotation(recognizer.rotation);
    _imageView.transform = transform;
    [self drawImageForGestureRecognizer:recognizer atPoint:location];
    
    if (recognizer.state == UIGestureRecognizerStateEnded ||
        recognizer.state == UIGestureRecognizerStateCancelled) {
        [UIView animateWithDuration:0.5 animations:^{
            self.imageView.alpha = 0.0;
            self.imageView.transform = CGAffineTransformIdentity;
        }];
    }
}

#pragma mark - Public


#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    //禁止在segmentedControl上响应tap手势
    if ((touch.view == self.segmentedControl)
        && gestureRecognizer == self.tapRecognizer) {
        return NO;
    }
    return YES;
}

#pragma mark - Setter


#pragma mark - Getter

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.frame = CGRectMake(0, 0, 60, 30);
    }
    return _imageView;
}

- (UIPanGestureRecognizer *)panRecognizer {
    if (!_panRecognizer) {
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(showGestureForPanRecognizer:)];
        pan.delegate = self;
        _panRecognizer = pan;
    }
    return _panRecognizer;
}
@end












