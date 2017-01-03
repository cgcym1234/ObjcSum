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


IB_DESIGNABLE
@interface YYRightImageButton ()

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation YYRightImageButton


#pragma mark - Initialization

#pragma mark - Initialization

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self _setupContext];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self _setupContext];
    }
    return self;
}

- (void)_setupContext {
    self.userInteractionEnabled = YES;
    self.clipsToBounds = YES;
    
    _textLabel = ({
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.numberOfLines = 1;
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor blackColor];
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

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (_didClickBlock) {
        _didClickBlock(self);
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _textLabel.left = _contentEdgeInsets.left;
    _textLabel.centerY = self.height/2;
    
    _imageView.right = self.width - _contentEdgeInsets.right;
    _imageView.centerY = _textLabel.centerY;
}

- (CGSize)intrinsicContentSize {
    CGSize textSize = _textLabel.intrinsicContentSize;
    
    CGSize imageSize = self.finalImageSize;
    CGFloat height = MAX(textSize.height, imageSize.height);
    _imageView.size = imageSize;
    
    CGSize contentSize = {
        _contentEdgeInsets.left + textSize.width + _spacing + imageSize.width + _contentEdgeInsets.right,
        _contentEdgeInsets.top + height + _contentEdgeInsets.bottom
    };
    return contentSize;
}

- (void)sizeToFit {
    [super sizeToFit];
    self.size = self.intrinsicContentSize;
}

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    [self limitTextLabelWidth:bounds.size.width];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self limitTextLabelWidth:frame.size.width];
}

#pragma mark - Private
/*如果限制了宽度，将label宽度减小*/
- (void)limitTextLabelWidth:(CGFloat)width {
    CGSize imageSize = self.finalImageSize;
    CGFloat maxWidth = width - ( _contentEdgeInsets.left + _spacing + imageSize.width + _contentEdgeInsets.right);
    if (_textLabel.width > maxWidth) {
        _textLabel.width = maxWidth;
    }
}

#pragma mark - Public

- (void)setBackgroundImage:(UIImage *)backgroundImage {
    self.layer.contents = (__bridge id _Nullable)(backgroundImage.CGImage);
}

- (void)setTextLabelFont:(UIFont *)textLabelFont {
    _textLabel.font = textLabelFont;
}

- (void)setTextLabelColor:(UIColor *)textLabelColor {
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

- (void)setContentEdgeInsets:(UIEdgeInsets)contentEdgeInsets {
    if (UIEdgeInsetsEqualToEdgeInsets(_contentEdgeInsets, contentEdgeInsets)) {
        return;
    }
    _contentEdgeInsets = contentEdgeInsets;
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

- (UIImage *)backgroundImage {
    return self.layer.contents;
}

- (UIImage *)image {
    return _imageView.image;
}

- (NSString *)text {
    return _textLabel.text;
}

- (UIFont *)textLabelFont {
    return _textLabel.font;
}

- (UIColor *)textLabelColor {
    return _textLabel.textColor;
}

- (CGSize)realImageSize {
    return _imageView.image.size;
}

- (CGSize)fixedImageSize {
    return _imageSize;
}

- (CGSize)finalImageSize {
    return CGSizeEqualToSize(self.fixedImageSize, CGSizeZero) ? self.realImageSize : self.fixedImageSize;
}


@end
