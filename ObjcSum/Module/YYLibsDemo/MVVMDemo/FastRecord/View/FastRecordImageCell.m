//
//  FastRecordImageCell.m
//  MLLSalesAssistant
//
//  Created by sihuan on 15/9/29.
//  Copyright © 2015年 Meilele. All rights reserved.
//

#import "FastRecordImageCell.h"

@interface FastRecordImageCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoMaxWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoMaxHeight;
@end

@implementation FastRecordImageCell

- (void)awakeFromNib {
    _photoMaxWidth.constant = CGRectGetWidth([UIScreen mainScreen].bounds);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _photoMaxHeight.constant = 400;
    [self addLongPressGesture];
}

- (void)addLongPressGesture {
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(deleteImage:)];
    [_photo addGestureRecognizer:longPress];
    _photo.userInteractionEnabled = YES;
}

- (void)deleteImage:(UILongPressGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"确认删除?" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [view show];
    }
    
}

#pragma -mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
        if (buttonIndex == 0) {
            return;
        } else {
            if (self.indexPath.row < self.fastRecordCellModel.recordImages.count) {
                [self.fastRecordCellModel.recordImages removeObjectAtIndex:self.indexPath.row];
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:FastRecordActionTypeImage] withRowAnimation:UITableViewRowAnimationNone];
            }
            
        }
}


- (UIEdgeInsets)layoutMargins {
    return UIEdgeInsetsMake(0, [UIScreen mainScreen].bounds.size.width, 0, 0);
}

#pragma mark - Public
- (void)updateUI:(FastRecordCellModel *)item atIndexpath:(NSIndexPath *)indexPath {
    [super updateUI:item atIndexpath:indexPath];
    UIImage *image = item.recordImages[indexPath.row];
    
    CGFloat imageWidth = image.size.width;
    CGFloat imageHeight = image.size.height;
    CGFloat maxWidth = [UIScreen mainScreen].bounds.size.width;
    
    if (imageHeight > maxWidth) {
        imageHeight = maxWidth*(imageHeight/imageWidth);
    }
    _photoMaxHeight.constant = imageHeight;
    self.photo.image = image;
}

////#pragma mark - Action
//- (IBAction)fastRecordCellDidCliced:(id)sender {
//    if ([self.delegate respondsToSelector:@selector(fastRecordCell:didClicked:atIndexpath:withObject:)]) {
//        [self.delegate fastRecordCell:self didClicked:FastRecordActionTypeImage atIndexpath:self.indexPath withObject:nil];
//    }
//}

@end
