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
#import "YYMessageModelManager.h"
#import "YYMessageCellImage.h"

@interface YYMessageViewController ()
<UICollectionViewDelegate, UICollectionViewDataSource, YYMessageCellBaseDelegate, YYMessageInputToolManagerDelegate>

@property (nonatomic, strong) YYMessageModelManager *messageModelManager;

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
    NSArray *messageArray = @[
                      [YYMessage messageTextOutgoing],
                      [YYMessage messageTextInComing],
                      [YYMessage messageTextOutgoing],
                      [YYMessage messageTextOutgoing],
                      [YYMessage messageTextOutgoing],
                      [YYMessage messageTextOutgoing],
                      [YYMessage messageTextInComing],
                      [YYMessage messageImageInComing],
                      ];
    _messageModelManager = [YYMessageModelManager new];
    for (YYMessage *message in messageArray) {
        [_messageModelManager addMessage:message];
    }
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
    return _messageModelManager.count;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YYMessageModel *model = [_messageModelManager messageModelAtIndex:indexPath.item];
    [model calculateSizeInWidth:collectionView.width];
    CGSize itemSize = CGSizeMake(collectionView.width, model.cellHeight);
    NSLog(@"itemSize: %@", NSStringFromCGSize(itemSize));
    return itemSize;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YYMessageModel *messageModel = [_messageModelManager messageModelAtIndex:indexPath.item];
    NSString *identifier = messageModel.cellIdentifier;
    YYMessageCellBase *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [cell renderWithMessageModel:messageModel atIndexPath:indexPath inCollectionView:collectionView];
    cell.delegate = self;
    
    //cell内部是在layoutsubview方法中布局的，避免因cell复用而不调用
    [cell setNeedsLayout];
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
    [self sendMessage:[YYMessage messageWithType:messageType content:messageObj]];
}

- (void)yyMessageInputToolManager:(YYMessageInputToolManager *)manager willTranslateToFrame:(CGRect)toFrame fromFrame:(CGRect)fromFrame {
    CGFloat bottom = self.view.height - toFrame.origin.y;
    
    /**
     *  要先调整contentInset，再调整contentOffset
     */
    [self setCollectionViewInsetsTopValue:0 bottomValue:bottom];
    [self scrollToBottom:bottom animated:YES];
}

#pragma mark - Message

- (void)sendMessage:(YYMessage *)message {
    [self willSendMessage:message];
}

//发送消息
- (void)willSendMessage:(YYMessage *)message {
    [_messageModelManager addMessage:message];
    [self reloadCollectionView];
}

//发送结果
- (void)sendMessage:(YYMessage *)message didCompleteWithError:(NSError *)error {
}

//发送进度
-(void)sendMessage:(YYMessage *)message progress:(CGFloat)progress {
}

//接收消息
- (void)onRecvMessages:(NSArray *)message {
}

//- (void)uiAddMessages:(NSArray *)messages{
//    NSArray *insert = [self.sessionDatasource addMessages:messages];
//    for (NIMMessage *message in messages) {
//        NIMMessageModel *model = [[NIMMessageModel alloc] initWithMessage:message];
//        [self layoutConfig:model];
//    }
//    [self.layoutManager insertTableViewCellAtRows:insert];
//}
//
//- (void)uiDeleteMessage:(NIMMessage *)message{
//    NIMMessageModel *model = [self makeModel:message];
//    NSArray *indexs = [self.sessionDatasource deleteMessageModel:model];
//    [self.layoutManager deleteCellAtIndexs:indexs];
//}
//
//- (void)uiUpdateMessage:(NIMMessage *)message{
//    NIMMessageModel *model = [self makeModel:message];
//    NSInteger index = [self.sessionDatasource indexAtModelArray:model];
//    [self.sessionDatasource.modelArray replaceObjectAtIndex:index withObject:model];
//    [self.layoutManager updateCellAtIndex:index model:model];
//}

#pragma mark - Private

- (void)setContext {
    [self.view addSubview:self.collectionView];
    [self.collectionView layoutEqualParent];
    
    if (self.inputToolManager) {
    }
}

- (void)reloadCollectionView {
    [_collectionView reloadData];
    [self scrollToBottom:0 animated:NO];
}

- (void)setCollectionViewInsetsTopValue:(CGFloat)top bottomValue:(CGFloat)bottom
{
    UIEdgeInsets insets = UIEdgeInsetsMake(top, 0.0f, bottom, 0.0f);
    self.collectionView.contentInset = insets;
    self.collectionView.scrollIndicatorInsets = insets;
}

- (void)scrollToBottom:(CGFloat)bottom animated:(BOOL)animated
{
    if ([self.collectionView numberOfSections] == 0) {
        return;
    }
    
    NSInteger items = [self.collectionView numberOfItemsInSection:0];
    
    if (items == 0) {
        return;
    }
    
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:items -1 inSection:0];
    [_collectionView scrollToItemAtIndexPath:lastIndexPath atScrollPosition:UICollectionViewScrollPositionBottom animated:animated];
    
//    CGPoint bottomOffset = CGPointMake(0, _collectionView.contentSize.height - (_collectionView.height - bottom));
//    
//    [_collectionView setContentOffset:bottomOffset animated:animated];
}

#pragma mark - Getters

- (YYMessageCollectionView *)collectionView {
    if (!_collectionView) {
        YYMessageCollectionView *collectionView = [[YYMessageCollectionView alloc] initWithFrame:self.view.bounds];
        collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [collectionView registerClass:[YYMessageCellText class] forCellWithReuseIdentifier:[YYMessageCellText identifier]];
        [collectionView registerClass:[YYMessageCellImage class] forCellWithReuseIdentifier:[YYMessageCellImage identifier]];
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
    [_messageModelManager refreshMessageModelLayoutWidth:_collectionView.width];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
    [_collectionView reloadData];
    [_collectionView scrollToItemAtIndexPath:_lastVisibleIndexPathBeforeRotation atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
}

@end
