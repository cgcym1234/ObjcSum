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
#import "YYMessageInputToolManager.h"

@interface YYMessageViewController ()
<UICollectionViewDelegate, UICollectionViewDataSource, YYMessageCellBaseDelegate, YYMessageInputToolManagerDelegate>

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSArray *messageArray;

@property (nonatomic, strong) NSIndexPath *lastVisibleIndexPathBeforeRotation;
@property (nonatomic, strong) YYMessageInputToolManager *inputToolManager;
@end

@implementation YYMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setContext];
    [self loadData];
}

- (void)loadData {
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
    [_collectionView reloadData];
}

- (void)viewDidLayoutSubviews {
    NSLog(@"viewDidLayoutSubviews");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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

#pragma mark - YYMessageInputToolManagerDelegate

- (void)yyMessageInputToolManager:(YYMessageInputToolManager *)manager didSendMessage:(id)messageObj messageType:(YYMessageType)messageType {
    
}

- (void)yyMessageInputToolManager:(YYMessageInputToolManager *)manager willTranslateToFrame:(CGRect)toFrame fromFrame:(CGRect)fromFrame {
    
}

#pragma mark - Private

- (void)setContext {
    [self.view addSubview:self.collectionView];
    [self.collectionView layoutEqualParent];
    
    if (self.inputToolManager) {
    }
}

- (void)layoutModel:(YYMessageModel *)model {
    [model calculateSizeInWidth:self.collectionView.width];
}

- (YYMessageModel *)makeModel:(YYMessage *)message {
    YYMessageModel *model = [YYMessageModel modelWithMessage:message];
    [self layoutModel:model];
    return model;
}

- (void)refreshModelLayout {
    [_dataArray enumerateObjectsUsingBlock:^(YYMessageModel *messageMoel, NSUInteger idx, BOOL * _Nonnull stop) {
        [messageMoel cleanCacheLayout];
        [messageMoel calculateSizeInWidth:self.view.width];
    }];
}

#pragma mark - Getters

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

- (YYMessageInputToolManager *)inputToolManager {
    if (!_inputToolManager) {
        YYMessageInputToolManager *inputToolManager = [[YYMessageInputToolManager alloc] initWithDelegate:self inputToolBarContainerView:self.view];
        _inputToolManager = inputToolManager;
    }
    return _inputToolManager;
}

#pragma mark - 旋转处理 (iOS7)


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    _lastVisibleIndexPathBeforeRotation = [_collectionView indexPathsForVisibleItems].lastObject;
    [_collectionView.collectionViewLayout invalidateLayout];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self refreshModelLayout];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
    [_collectionView reloadData];
    [_collectionView scrollToItemAtIndexPath:_lastVisibleIndexPathBeforeRotation atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
}

@end
