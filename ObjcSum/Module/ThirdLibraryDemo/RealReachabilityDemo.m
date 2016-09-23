//
//  RealReachabilityDemo.m
//  ObjcSum
//
//  Created by yangyuan on 2016/9/23.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "RealReachabilityDemo.h"
#import "RealReachability.h"

@interface RealReachabilityDemo ()

@property (weak, nonatomic) IBOutlet UILabel *flagLabel;

@end

@implementation RealReachabilityDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(networkChanged:)
                                                 name:kRealReachabilityChangedNotification
                                               object:nil];
    
    ReachabilityStatus status = [GLobalRealReachability currentReachabilityStatus];
    NSLog(@"Initial reachability status:%@",@(status));
    
    switch (status) {
        case RealStatusNotReachable:
            self.flagLabel.text = @"Network unreachable!";
            break;
        case RealStatusViaWiFi:
            self.flagLabel.text = @"Network wifi!";
            break;
        case RealStatusViaWWAN:
            self.flagLabel.text = @"Network WWAN!";
            break;
        default:
            self.flagLabel.text = @"Network unknow!";
            break;
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)networkChanged:(NSNotification *)notification {
    RealReachability *reachability = (RealReachability *)notification.object;
    ReachabilityStatus status = [reachability currentReachabilityStatus];
    ReachabilityStatus previousStatus = [reachability previousReachabilityStatus];
    NSLog(@"networkChanged, currentStatus:%@, previousStatus:%@", @(status), @(previousStatus));
    switch (status) {
        case RealStatusNotReachable:
            self.flagLabel.text = @"Network unreachable!";
            break;
        case RealStatusViaWiFi:
            self.flagLabel.text = @"Network wifi!";
            break;
        case RealStatusViaWWAN:
            self.flagLabel.text = @"Network WWAN!";
            break;
        default:
            self.flagLabel.text = @"Network unknow!";
            break;
    }
    
    if (status == RealStatusViaWWAN) {
        WWANAccessType accessType = [GLobalRealReachability currentWWANtype];
        switch (accessType) {
            case WWANType2G:
                self.flagLabel.text = @"Network RealReachabilityStatus2G!";
                break;
            case WWANType3G:
                self.flagLabel.text = @"Network RealReachabilityStatus3G!";
                break;
            case WWANType4G:
                self.flagLabel.text = @"Network RealReachabilityStatus4G!";
                break;
            default:
                self.flagLabel.text = @"Network unknow!";
                break;
        }
    }
}

- (IBAction)testAction:(id)sender
{
    [GLobalRealReachability reachabilityWithBlock:^(ReachabilityStatus status) {
        switch (status)
        {
            case RealStatusNotReachable:
            {
                [[[UIAlertView alloc] initWithTitle:@"RealReachability" message:@"Nothing to do! offlineMode" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil] show];
                break;
            }
                
            case RealStatusViaWiFi:
            {
                [[[UIAlertView alloc] initWithTitle:@"RealReachability" message:@"Do what you want! free!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil] show];
                break;
            }
                
            case RealStatusViaWWAN:
            {
                [[[UIAlertView alloc] initWithTitle:@"RealReachability" message:@"Take care of your money! You are in charge!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil] show];
                
                WWANAccessType accessType = [GLobalRealReachability currentWWANtype];
                if (accessType == WWANType2G)
                {
                    self.flagLabel.text = @"RealReachabilityStatus2G";
                }
                else if (accessType == WWANType3G)
                {
                    self.flagLabel.text = @"RealReachabilityStatus3G";
                }
                else if (accessType == WWANType4G)
                {
                    self.flagLabel.text = @"RealReachabilityStatus4G";
                }
                else
                {
                    self.flagLabel.text = @"Unknown RealReachability WWAN Status, might be iOS6";
                }
                
                break;
            }
                
            default:
                break;
        }
    }];
}
@end






















