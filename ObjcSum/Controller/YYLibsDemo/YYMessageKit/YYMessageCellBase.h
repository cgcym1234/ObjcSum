//
//  YYMessageCellBase.h
//  ObjcSum
//
//  Created by sihuan on 15/12/30.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYMessageCellLayoutConfig.h"
#import "YYMessageAvatarView.h"
#import "YYMessageBubbleView.h"
#import "UIView+YYMessage.h"
#import "UILabel+YYMessage.h"

@class YYMessageCellConfig;
@class YYMessageCellBase;
@class YYMessageModel;
@protocol YYMessageCellBaseDelegate <NSObject>

- (void)yyMessageCellBase:(YYMessageCellBase *)cell didClickedAtIndexPath:(NSIndexPath *)indexPath withMessageModel:(YYMessageModel *)messageModel;

@end

@interface YYMessageCellBase : UICollectionViewCell

@property (nonatomic, weak) YYMessageCellConfig *cellConfig;
@property (nonatomic, weak) YYMessageModel *messageModel;
@property (nonatomic, weak) id<YYMessageCellBaseDelegate> delegate;
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, copy) NSIndexPath *indexPath;

//用来显示时间
@property (nonatomic, strong) UILabel *cellTopLabel;
//用来显示昵称，气泡上面
@property (nonatomic, strong) UILabel *bubbleTopLabel;
//用来显示昵称，气泡下面
@property (nonatomic, strong) UILabel *cellBottomLabel;

@property (nonatomic, strong) YYMessageAvatarView *avatarImageView;

@property (nonatomic, strong) YYMessageBubbleView *bubbleContainerView;
//@property (nonatomic, strong) UIImageView *bubbleImageView;


/**
 *  cell的唯一标志符
 */
+ (NSString *)identifier;

/**
 *  一些额外的初始化，子类覆盖的话需要调用super
 */
- (void)setContext;

/**
 *  配置cell方法，子类需调用super xxx
 */
- (void)renderWithMessageModel:(YYMessageModel *)messageModel atIndexPath:(NSIndexPath *)indexPath inCollectionView:(UICollectionView *)collectionView;

@end
