//
//  RealmManager.h
//  RealmTest
//
//  Created by Hirohisa Kobayasi on 2017/03/15.
//  Copyright © 2017年 Hirohisa Kobayasi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>
#import "TestEntity.h"
#import "PersonEntity.h"

@interface RealmManager : NSObject

+ (RealmManager *)sharedInstance;

+ (BOOL)deleteRealm;
+ (BOOL)compactRealm;

- (void)logDbInfo;

- (RLMRealm *)defaultRealm;

- (TestEntity *)testEntity;

- (void)addEntitiesOnMain;
- (void)deleteEntitiesOnMain;
- (void)addEntitiesOnWorker;
- (void)deleteEntitiesOnWorker;

- (void)createOrUpdatePersonTable;

@end
