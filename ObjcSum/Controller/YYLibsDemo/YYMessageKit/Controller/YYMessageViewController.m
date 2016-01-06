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

- (YYMessageCollectionView *)collectionView {
    if (!_collectionView) {
        YYMessageCollectionView *collectionView = [[YYMessageCollectionView alloc] initWithFrame:self.view.bounds];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [collectionView registerClass:[YYMessageCellText class] forCellWithReuseIdentifier:[YYMessageCellText identifier]];
        _collectionView = collectionView;
    }
    return _collectionView;
}

#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate

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

#pragma mark - YYMessageCellBaseDelegate

- (void)yyMessageCellBase:(YYMessageCellBase *)cell didClickItem:(YYMessageItem)itemType atIndexPath:(NSIndexPath *)indexPath withMessageModel:(YYMessageModel *)messageModel {
    switch (itemType) {
        case YYMessageItemAvatar: {
            break;
        }
        case YYMessageItemBubble: {
            break;
        }
        case YYMessageItemOther: {
            break;
        }
        default:
            break;
    }
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
