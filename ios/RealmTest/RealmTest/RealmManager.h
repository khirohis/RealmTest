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

+ (void)compactRealm;

+ (RLMRealm *)realmSingleInstance;
+ (RLMRealm *)realmInstance;

+ (TestEntity *)entityFromRealm:(RLMRealm *)realm;

@end
