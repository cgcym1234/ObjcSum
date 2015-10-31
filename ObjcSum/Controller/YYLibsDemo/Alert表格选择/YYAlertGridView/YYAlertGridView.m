//
//  YYAlertGridView.m
//  MySimpleFrame
//
//  Created by sihuan on 15/10/20.
//  Copyright © 2015年 huan. All rights reserved.
//

#import "YYAlertGridView.h"
#import "YYAlertGridViewCell.h"

@interface YYAlertGridView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSArray *dataArr;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeigth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *marginTop;

@end

#pragma mark - Consts
static NSInteger const HeightForCommonCell = 49;
static NSInteger const ItemNumsPerLine = 3;

#pragma mark  Keys
static NSString * const IdentifierCell = @"YYAlertGridViewCell";


@implementation YYAlertGridView

#pragma mark - Life cycle
- (void)awakeFromNib {
    [self.collectionView registerNib:[UINib nibWithNibName:IdentifierCell bundle:nil] forCellWithReuseIdentifier:IdentifierCell];
    self.title = @"标题";
    self.frame = [UIScreen mainScreen].bounds;
}

- (void)layoutSubviews {
    self.frame = self.superview.bounds;
}

#pragma mark - Delegates

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArr.count;
}

//设置元素框的大小
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;
}

//设置元素之间的间隔
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

//设置每个item的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.bounds.size.width/ItemNumsPerLine, HeightForCommonCell);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YYAlertGridViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:IdentifierCell forIndexPath:indexPath];
    cell.tag = indexPath.item;
    cell.textLabel.text = _dataArr[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_didClickedBlock) {
        _didClickedBlock(self, indexPath.item);
    }
    [self dismss];
}


#pragma mark Private
+ (instancetype)instanceFromNib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}

- (instancetype)show {
    if (!self.superview) {
#pragma mark - 找到当前显示的window
        NSEnumerator *frontToBackWindows = [[UIApplication sharedApplication].windows reverseObjectEnumerator];
        for (UIWindow *window in frontToBackWindows) {
            BOOL windowOnMainScreen = window.screen == [UIScreen mainScreen];
            BOOL windowIsVisible = !window.hidden && window.alpha > 0;
            BOOL windowLevelNormal = window.windowLevel == UIWindowLevelNormal;
            
            if (windowOnMainScreen && windowIsVisible && windowLevelNormal) {
                [window addSubview:self];
                break;
            }
        }
        
        [self showAnimation];
    } else {
        [self.superview bringSubviewToFront:self];
    }
    
    return self;
}

- (void)showAnimation {
    [self.collectionView reloadData];
    self.collectionView.transform = CGAffineTransformConcat(CGAffineTransformIdentity, CGAffineTransformMakeScale(1.0f, 0.95f));
    CGFloat height = ceilf(_textArray.count*1.0/ItemNumsPerLine)*HeightForCommonCell;
//    self.collectionViewHeigth.constant = 0;
    self.collectionViewHeigth.constant = MIN([UIScreen mainScreen].bounds.size.height-_marginTop.constant, height);
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.collectionView.transform = CGAffineTransformIdentity;
                         
                         self.alpha = 1;
                         self.collectionView.alpha = 1;
//                         [self layoutIfNeeded];
                     }
                     completion:^(BOOL finished){
                         
                     }];
}

- (void)dismss {
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionAllowUserInteraction animations:^{
        //        self.containerView.transform = CGAffineTransformScale(_containerView.transform, 0.5, 0.5);
    } completion:^(BOOL finished) {
        self.collectionView.alpha = 0;
        self.alpha = 0;
        [self removeFromSuperview];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismss];
}


#pragma mark Public

- (void)setTitle:(NSString *)title {
    _title = title;
}

- (void)setTextArray:(NSArray *)textArray {
    _textArray = textArray;
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:textArray.count];
    [arr addObjectsFromArray:textArray];
    _dataArr = arr;
}

- (instancetype)showWithTitle:(NSString *)title textArry:(NSArray *)textArry {
    self.title = title;
    self.textArray = textArry;
    return [self show];
}

- (instancetype)showWithTextArry:(NSArray *)textArry {
    return [self showWithTitle:nil textArry:textArry];
}

+ (instancetype)showWithTitle:(NSString *)title textArry:(NSArray *)textArry {
    YYAlertGridView *alertView = [YYAlertGridView instanceFromNib];
    return [alertView showWithTitle:title textArry:textArry];
}

+ (instancetype)showWithTextArry:(NSArray *)textArry {
    return [self showWithTitle:nil textArry:textArry];
}



@end