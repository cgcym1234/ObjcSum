//
//  YYAlertGridView.m
//  MySimpleFrame
//
//  Created by sihuan on 15/10/20.
//  Copyright © 2015年 huan. All rights reserved.
//

#import "YYAlertGridView.h"
#import "YYAlertGridViewCell.h"
#import "YYDim.h"

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
    self.backgroundColor = [UIColor clearColor];
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
    [YYDim dismss];
}


#pragma mark Private
+ (instancetype)instanceFromNib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [YYDim dismss];
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
    
    CGFloat height = ceilf(_textArray.count*1.0/ItemNumsPerLine)*HeightForCommonCell;
    self.collectionViewHeigth.constant = MIN([UIScreen mainScreen].bounds.size.height-_marginTop.constant, height);
    [self.collectionView reloadData];
    
    [YYDim showView:self];
    return self;
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