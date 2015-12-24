//
//  FastRecord.m
//  MLLSalesAssistant
//
//  Created by sihuan on 15/10/7.
//  Copyright © 2015年 Meilele. All rights reserved.
//

#import "FastRecord.h"
#import "FastRecordModel.h"
#import "FastRecordCellModel.h"


@implementation FastRecord

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.MySimpleFrame" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:NSStringFromClass(self.class) withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"FastRecord.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (BOOL)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"谁手记 保存失败Unresolved error %@, %@", error, [error userInfo]);
            return NO;
        }
    }
    return YES;
}

- (BOOL)updateEntity:(FastRecordModel *)entity withValue:(FastRecordCellModel *)model {
    model.recordDate = [NSDate date];
    
//    ApplicationUser *user = [[MllRegisterManager sharedManager] getLatestLogedInUser];
    model.userId = @"hehe";
    
    //语音文字不能同时
    if (model.recordVoicePath) {
        model.recordText = nil;
    }

    entity.userId = model.userId;
    entity.type = @(model.type);
    entity.recordDate = model.recordDate;
    entity.clockDate = model.clockDate;
    entity.recordText = model.recordText;
    entity.recordVoicePath = model.recordVoicePath.absoluteString;
    entity.recordVoiceDuration = model.recordVoiceDuration != nil ? @([model.recordVoiceDuration intValue]) : nil;
    entity.recordImages = model.recordImages != nil ? [NSKeyedArchiver archivedDataWithRootObject:model.recordImages] : nil;
    entity.customerName = model.customerName;
    entity.customerId = model.customerId;
    
    return [self saveContext];
}


+ (instancetype)shareInstance {
    static FastRecord *_shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareInstance = [[FastRecord alloc] init];
    });
    return _shareInstance;
}

/*添加一条新记录*/
+ (BOOL)addNewEntityWithCellModel:(FastRecordCellModel *)cellModel {
    FastRecord *fastRecord = [FastRecord shareInstance];
    FastRecordModel *newEntity = [NSEntityDescription insertNewObjectForEntityForName:@"FastRecordModel" inManagedObjectContext:[FastRecord shareInstance].managedObjectContext];
    return [fastRecord updateEntity:newEntity withValue:cellModel];
}

/*更新记录*/
+ (BOOL)updateEntity:(FastRecordModel *)entity withValue:(FastRecordCellModel *)model {
    return [[FastRecord shareInstance] updateEntity:entity withValue:model];
}

/*删除记录*/
+ (BOOL)deleteEntity:(FastRecordModel *)model {
    FastRecord *fastRecord = [FastRecord shareInstance];
    [fastRecord.managedObjectContext deleteObject:model];
    return [fastRecord saveContext];
}

/*获取客户更进或者个人提醒数据*/
+ (NSArray *)getFastRecordDatasWithCustomerId:(NSString *)customerId {
    return [[FastRecord shareInstance] getFastRecordDatasWithCustomerId:customerId recordType:FastRecordTypeCustomer];
}

- (NSArray *)getFastRecordDatasWithCustomerId:(NSString *)customerId recordType:(FastRecordType) recordType{
    
//    ApplicationUser *user = [[MllRegisterManager sharedManager] getLatestLogedInUser];
    NSString *userKey = @"hehe";
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"FastRecordModel"];
    
    NSSortDescriptor *sortDesc = [[NSSortDescriptor alloc] initWithKey:@"recordDate" ascending:NO];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId=%@ AND customerId=%@ AND type=%d ", userKey, customerId, recordType];
    
    [fetchRequest setFetchBatchSize:20];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setSortDescriptors:@[sortDesc]];
    
    NSError *error = nil;
    return [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
}

@end
