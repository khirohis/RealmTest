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


@interface RealmManager : NSObject

+ (BOOL)compactRealm;

+ (RLMRealm *)realm;

+ (TestEntity *)entityFromRealm:(RLMRealm *)realm;
+ (void)addEntities;
+ (void)deleteEntities;

@end
