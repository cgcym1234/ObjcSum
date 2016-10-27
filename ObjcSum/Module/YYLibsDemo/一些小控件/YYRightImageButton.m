//
//  YYRightImageButton.m
//  ObjcSum
//
//  Created by yangyuan on 2016/10/26.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "YYRightImageButton.h"
#import "UIView+Frame.h"

#pragma mark - Const

static NSInteger const HeightForCommonCell = 49;

static NSString * const KeyCell = @"KeyCell";

IB_DESIGNABLE
@interface YYRightImageButton ()

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation YYRightImageButton


#pragma mark - Initialization

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setContext];
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
    
    _textLabelFont = [UIFont systemFontOfSize:14];
    _textLabelColor = [UIColor blackColor];
    
    _textLabel = ({
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.numberOfLines = 1;
        label.textAlignment = NSTextAlignmentLeft;
        label.font = _textLabelFont;
        label.textColor = _textLabelColor;
        label;
    });
    
    _imageView = ({
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView;
    });
    
    [self addSubview:_textLabel];
    [self addSubview:_imageView];
}


#pragma mark - Override

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _textLabel.left = _contentEdgeInsets.left;
    _textLabel.centerY = self.height/2;
    
    _imageView.right = self.width - _contentEdgeInsets.right;
    _imageView.centerY = _textLabel.centerY;
}

- (CGSize)intrinsicContentSize {
    CGSize textSize = _textLabel.intrinsicContentSize;
    CGFloat imageWidth = _imageSize.width == 0 ? _image.size.width : _imageSize.width;
    CGFloat imageHeight = _imageSize.height == 0 ? _image.size.height : _imageSize.height;
    CGFloat height = MAX(textSize.height, imageHeight);
    
    CGSize contentSize = {
        _contentEdgeInsets.left + textSize.width + _spacing + imageWidth + _contentEdgeInsets.right,
        _contentEdgeInsets.top + height + _contentEdgeInsets.bottom
    };
    return contentSize;
}

#pragma mark - Private

#pragma mark - Public

- (void)setTextLabelFont:(UIFont *)textLabelFont {
    _textLabelFont = textLabelFont;
    _textLabel.font = textLabelFont;
}

- (void)setTextLabelColor:(UIColor *)textLabelColor {
    _textLabelColor = textLabelColor;
    _textLabel.textColor = textLabelColor;
}

- (void)setText:(NSString *)text {
    NSString *textOld = _textLabel.text;
    _textLabel.text = text;
    if (textOld.length != text.length) {
        [_textLabel sizeToFit];
        [self invalidateIntrinsicContentSize];
    }
}

- (void)setImage:(UIImage *)image {
    _imageView.image = image;
    _imageSize = image == nil ? CGSizeZero : image.size;
    _imageView.size = _imageSize;
    [self invalidateIntrinsicContentSize];
}

- (void)setImageSize:(CGSize)imageSize {
    if (CGSizeEqualToSize(_imageSize, imageSize)) {
        return;
    }
    _imageSize = imageSize;
    [self invalidateIntrinsicContentSize];
}

- (void)setSpacing:(CGFloat)spacing {
    if (_spacing == spacing) {
        return;
    }
    _spacing = spacing;
    [self invalidateIntrinsicContentSize];
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    if (_cornerRadius != cornerRadius) {
        _cornerRadius = cornerRadius;
        self.layer.cornerRadius = _cornerRadius;
        self.layer.masksToBounds = YES;
    }
}
- (void)setBorderWidth:(CGFloat)borderWidth {
    _borderWidth = borderWidth;
    self.layer.borderWidth = _borderWidth;
}
- (void)setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    self.layer.borderColor = _borderColor.CGColor;
}

#pragma mark - Delegate


#pragma mark - Setter



#pragma mark - Getter



@end

