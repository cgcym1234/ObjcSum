//
//  YYMessageViewController.m
//  ObjcSum
//
//  Created by sihuan on 15/12/30.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import "YYMessageViewController.h"
#import "YYMessageCellText.h"
#import "YYMessageModel.h"

@interface YYMessageViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, YYMessageCellBaseDelegate>

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSArray *messageArray;
@end

@implementation YYMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _messageArray = @[
                   [YYMessage messageTextOutgoing],
                   [YYMessage messageTextInComing],
                   [YYMessage messageTextOutgoing],
                   [YYMessage messageTextOutgoing],
                   [YYMessage messageTextOutgoing],
                   [YYMessage messageTextOutgoing],
                   [YYMessage messageTextInComing],
                   ];
    NSMutableArray *arr = [NSMutableArray new];
    for (YYMessage *message in _messageArray) {
        [arr addObject:[self makeModel:message]];
    }
    _dataArray = arr;
    [self.view addSubview:self.collectionView];
}

- (void)viewDidLayoutSubviews {
    _collectionView.frame = self.view.bounds;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.minimumInteritemSpacing = 0.0f;
        flowLayout.minimumLineSpacing = 10.0f;
        flowLayout.sectionInset = UIEdgeInsetsZero;
        flowLayout.footerReferenceSize = CGSizeZero;
        flowLayout.headerReferenceSize = CGSizeZero;
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        collectionView.alwaysBounceVertical = YES;
        collectionView.pagingEnabled = NO;
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        [collectionView registerClass:[YYMessageCellText class] forCellWithReuseIdentifier:[YYMessageCellText identifier]];
        _collectionView = collectionView;
    }
    return _collectionView;
}

#pragma mark- UICollectionViewDataSource,UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YYMessageModel *model = _dataArray[indexPath.item];
    return CGSizeMake(collectionView.width, model.cellHeight);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [YYMessageCellText identifier];
    YYMessageCellBase *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [cell renderWithMessageModel:_dataArray[indexPath.item] atIndexPath:indexPath inCollectionView:collectionView];
    cell.delegate = self;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

#pragma mark - Private

- (void)layoutModel:(YYMessageModel *)model {
    [model calculateSizeInWidth:self.collectionView.width];
}

- (YYMessageModel *)makeModel:(YYMessage *)message {
    YYMessageModel *model = [YYMessageModel modelWithMessage:message];
    [self layoutModel:model];
    return model;
}

@end
