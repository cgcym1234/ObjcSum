//
//  YYMessageMoreView.m
//  ObjcSum
//
//  Created by sihuan on 16/2/20.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "YYMessageMoreView.h"
#import "YYMessageMoreViewCell.h"
#import "YYMessageDefinition.h"
#import "UIView+AutoLayout.h"
#import "DNImagePickerController.h"
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetRepresentation.h>

#pragma mark - Const

static NSString * const CellIdentifierDefault = @"YYMessageMoreViewCell";

@interface YYMessageMoreView ()
<DNImagePickerControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) YYHorizontalScrollView *moreView;

@end

@implementation YYMessageMoreView


#pragma mark - Initialization


- (instancetype)init {
    if (self = [super init]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self addSubview:self.moreView];
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, YYInputViewHeight);
}


#pragma mark - Override


#pragma mark - Private

- (void)openCamera {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [_containerController presentViewController:picker animated:YES completion:NULL];
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有找到相机" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)showImagePicker {
    DNImagePickerController *imagePicker = [[DNImagePickerController alloc] init];
    imagePicker.filterType = DNImagePickerFilterTypePhotos;
    imagePicker.imagePickerDelegate = self;
    [_containerController presentViewController:imagePicker animated:YES completion:nil];
}

- (void)selecteImages:(NSArray *)imagesArr {
    if ([_delegate respondsToSelector:@selector(yyMessageMoreView:didSelectImages:)]) {
        [_delegate yyMessageMoreView:self didSelectImages:imagesArr];
    }
}

#pragma mark - Public


#pragma mark - Delegate

#pragma mark - DNImagePickerControllerDelegate

- (void)dnImagePickerController:(DNImagePickerController *)imagePicker sendImages:(NSArray *)imageAssets isFullImage:(BOOL)fullImage {
    NSMutableArray *images = [NSMutableArray array];
    int i = 0;
    for (ALAsset *asset in imageAssets) {
        if (i++ >= 5) {
            break;
        }
        UIImage *image = [UIImage imageWithCGImage:[asset defaultRepresentation].fullScreenImage];
        [images addObject:image];
    }
    
    [self selecteImages:images];
}

- (void)dnImagePickerControllerDidCancel:(DNImagePickerController *)imagePicker
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *editImage = [info objectForKey:UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        if (editImage) {
            [self selecteImages:@[editImage]];
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}



#pragma mark - Setter


#pragma mark - Getter

- (YYHorizontalScrollView *)moreView {
    if (!_moreView) {
        YYHorizontalScrollView *moreView = [YYHorizontalScrollView new];
        
        moreView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, YYInputViewHeight);
        moreView.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width/4, 100);
        [moreView registerClass:[YYMessageMoreViewCell class]];
        moreView.dataArray = @[
                               [YYMessageMoreViewCellModel modelWithType:YYMessageMoreViewItemCamera],
                               [YYMessageMoreViewCellModel modelWithType:YYMessageMoreViewItemAlbum],
                               ];
        __weak typeof(self) weakSelf = self;
        moreView.didSelectItemBlock = ^(YYHorizontalScrollView *view, NSInteger selectedIndex) {
            YYMessageMoreViewCellModel *item = view.dataArray[selectedIndex];
            switch (item.type) {
                case YYMessageMoreViewItemCamera: {
                    [weakSelf openCamera];
                    break;
                }
                case YYMessageMoreViewItemAlbum: {
                    [weakSelf showImagePicker];
                    break;
                }
            }
        };
        _moreView = moreView;
    }
    return _moreView;
}


@end


