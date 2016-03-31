//
//  TableViewDemo.m
//  ObjcSum
//
//  Created by sihuan on 16/3/30.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "TableViewDemo.h"
#import "ShowRoomCell.h"
#import "YYHud.h"
#import "YYBaseHttp.h"
#import "ShowRoomListModel.h"
#import "UITableView+FDTemplateLayoutCell.h"

#define IdentifierCell @"ShowRoomCell"

@interface TableViewDemo ()

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSMutableArray *heightArray;

@property (nonatomic, assign) BOOL appendData;
@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation TableViewDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    /**
     *  定义了tableView的estimatedRowHeight后，delegate调用顺序为
     1. estimatedHeightForRowAtIndexPath * N
     
     2. cellForRowAtIndexPath   0
     3. heightForRowAtIndexPath 0
     
     4. cellForRowAtIndexPath   1
     5. heightForRowAtIndexPath 1
     ...
     
     最后发现上面是错的。。。
     原文链接：http://www.jianshu.com/p/a0342ee86431
     
     通过打印我们可以看到，获取cell之前，诡异地对heighForRow方法遍历了三次...为什么是三次？
     
     
     没有定义或设置estimatedRowHeight，代理顺序按以前的顺序
     */
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[UINib nibWithNibName:IdentifierCell bundle:nil] forCellReuseIdentifier:IdentifierCell];
    _heightArray = [NSMutableArray new];
    [self loadData];
    
}

- (void)loadData
{
    _currentPage = 1;
    [self loadData:NO];
}

- (void)loadData:(BOOL)appendData {
    _appendData = appendData;
    
    __weak typeof(self)weakSelf = self;
    
    NSString *url = @"http://www.meilele.com/mll_api/api/app_ybj2_list?page=1&&size=1";
    [YYHud showSpinner];
    [[YYBaseHttp new] getUrlString:url parameters:nil useCache:YES cacheExpiration:1000000 completion:^(id responseData, NSError *error, NSURLSessionDataTask *dataTask) {
        [YYHud dismiss];
        if (error) {
            [YYHud showError:error.localizedDescription];
            NSLog(@"%@", error);
        } else {
//            NSLog(@"%@", responseData);
            ShowRoomListModel *list = [[ShowRoomListModel alloc] initWithValues:responseData];
            _dataArray = list.cellModelArr;
            [weakSelf.tableView reloadData];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"%s", __PRETTY_FUNCTION__);
//    CGFloat height = [tableView fd_heightForCellWithIdentifier:IdentifierCell cacheByIndexPath:indexPath configuration:^(ShowRoomCell *cell) {
//        [cell updateUI:self.dataArray[indexPath.row]];
//    }];
//    
//    return height;
//    return 300;
//    return [_heightArray[indexPath.row] floatValue];
//}

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"%s", __PRETTY_FUNCTION__);
//    return 100;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    ShowRoomCell *cell = [tableView dequeueReusableCellWithIdentifier:IdentifierCell forIndexPath:indexPath];
    [cell updateUI:self.dataArray[indexPath.row]];
//    CGSize contentSize =  [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingExpandedSize];
//    [_heightArray addObject:@(contentSize.height)];
    return cell;
}



@end
