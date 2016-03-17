//
//  YYEmoticonInputView.m
//  ObjcSum
//
//  Created by sihuan on 16/3/17.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "YYEmoticonInputView.h"
#import "YYEmoticonInputViewCell.h"

#pragma mark - Const

#define ScreenWidth CGRectGetWidth([[UIScreen mainScreen] bounds])

static NSInteger const ViewHeight = 216;
static NSInteger const EmoticonSize = 50;
static NSInteger const OneRowCount = 7;
static NSInteger const OnePageCount = 21;
static NSInteger const kToolbarHeight = 37;

static NSString * const CellIdentifierDefault = @"YYEmoticonInputViewCell";

@interface YYEmoticonInputView ()
<UICollectionViewDelegate, UICollectionViewDataSource>

//使用UICollectionView实现
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation YYEmoticonInputView


#pragma mark - Initialization

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setContext];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:CGRectMake(0, 0, ScreenWidth, ViewHeight)]) {
        [self setContext];
    }
    return self;
}


- (void)setContext {
    [self addSubview:self.collectionView];
    self.backgroundColor = [UIColor whiteColor];
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerNib:[UINib nibWithNibName:CellIdentifierDefault bundle:nil] forCellWithReuseIdentifier:CellIdentifierDefault];
    
    [self loadEmoticonData];
    if (_dataArray.count > 0) {
        [self resetItemLayout];
        [self reloadData];
    }
}


#pragma mark - Override

- (void)layoutSubviews {
    if (!CGRectEqualToRect(self.bounds, self.collectionView.frame)) {
        self.collectionView.frame = self.bounds;
        [self resetItemLayout];
    }
}

#pragma mark - Private

- (void)loadEmoticonData {
    NSMutableArray *dataArray = [NSMutableArray array];
    int emojiRangeArray[10] = {0xE001,0xE05A,0xE101,0xE15A,0xE201,0xE253,0xE401,0xE44C,0xE501,0xE537};
    for (int i = 0; i < 10; i += 2) {
        int startIndex = emojiRangeArray[i];
        int endIndex = emojiRangeArray[i+1];
        for (int emojiCode = startIndex; emojiCode < endIndex; emojiCode++) {
            //添加表情code到数据源数组
            [dataArray addObject:[NSString stringWithFormat:@"%C", (unichar)emojiCode]];
        }
    }
    _dataArray = dataArray;
}

#pragma mark - Public

- (void)reloadData {
    [_collectionView reloadData];
}

- (void)resetItemLayout {
    [self.collectionView.collectionViewLayout invalidateLayout];
}

#pragma mark - Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return (_dataArray.count/OnePageCount)+(_dataArray.count%OnePageCount==0?0:1);
}

//每页OnePageCount个表情
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (((_dataArray.count/OnePageCount)+(_dataArray.count%OnePageCount==0?0:1))!=section+1) {
        return OnePageCount;
    }else{
        return _dataArray.count-OnePageCount*((_dataArray.count/OnePageCount)+(_dataArray.count%OnePageCount==0?0:1)-1);
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YYEmoticonInputViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifierDefault forIndexPath:indexPath];
    cell.label.text =_dataArray[indexPath.row+indexPath.section*OnePageCount] ;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * emojiCode = _dataArray[indexPath.section*OnePageCount+indexPath.row];
    //这里手动将表情符号添加到textField上
//    if ([self.delegate respondsToSelector:@selector(yySegmentedControl:didSelectItemAtIndex:)]) {
//        [self.delegate yySegmentedControl:self didSelectItemAtIndex:_selectedIndex];
//    }
}

#pragma mark - Setter

- (void)setDataArray:(NSMutableArray *)dataArray {
    _dataArray = dataArray;
}

#pragma mark - Getter

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.flowLayout];
        collectionView.alwaysBounceHorizontal = YES;
        collectionView.bounces = YES;
        collectionView.pagingEnabled = YES;
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        
        _collectionView = collectionView;
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        //设置行列间距
        flowLayout.minimumInteritemSpacing = 0.0f;
        flowLayout.minimumLineSpacing = 0.0f;
        
        flowLayout.footerReferenceSize = CGSizeZero;
        flowLayout.headerReferenceSize = CGSizeZero;
        
        CGFloat itemWidth = (ScreenWidth - 10 * 2) / OneRowCount;
//        itemWidth = CGFloatPixelRound(itemWidth);
        CGFloat padding = (ScreenWidth - 7 * itemWidth) / 2.0;
        CGFloat paddingLeft = padding; //CGFloatPixelRound(padding);
        CGFloat paddingRight = ScreenWidth - paddingLeft - itemWidth * 7;
        //设置每个表情按钮的大小为30*30;
        flowLayout.itemSize = CGSizeMake(itemWidth, EmoticonSize);
        
        //计算每个分区的左右边距
        float xOffset = (ScreenWidth - 7*30 - 10*6)/2;
        //设置分区的内容偏移
        flowLayout.sectionInset = UIEdgeInsetsMake(10, paddingLeft, 10, paddingRight);
        _flowLayout = flowLayout;
    }
    return _flowLayout;
}


@end
