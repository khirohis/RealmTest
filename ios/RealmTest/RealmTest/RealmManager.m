//
//  RealmManager.m
//  RealmTest
//
//  Created by Hirohisa Kobayasi on 2017/03/15.
//  Copyright © 2017年 Hirohisa Kobayasi. All rights reserved.
//

#import "RealmManager.h"


@implementation RealmManager

+ (void)compactRealm {
    NSError *error;

    RLMRealm *realm = [RealmManager realmInstance];
    NSURL *fileUrl = [[RLMRealmConfiguration defaultConfiguration] fileURL];
    NSURL *copyUrl = [NSURL fileURLWithPath:[fileUrl.path stringByAppendingString:@".copy"]];

    error = nil;
    [[NSFileManager defaultManager] removeItemAtURL:copyUrl
                                              error:&error];

    error = nil;
    [realm writeCopyToURL:copyUrl
            encryptionKey:nil
                    error:&error];

    error = nil;
    [[NSFileManager defaultManager] removeItemAtURL:fileUrl
                                              error:&error];

    error = nil;
    [[NSFileManager defaultManager] moveItemAtURL:copyUrl
                                            toURL:fileUrl
                                            error:&error];
}

+ (RLMRealm *)realmSingleInstance {
    static RLMRealm *realm;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        realm = [RLMRealm defaultRealm];
    });

    return realm;
}

+ (RLMRealm *)realmInstance {
    return [RLMRealm defaultRealm];
}


+ (TestEntity *)entityFromRealm:(RLMRealm *)realm {
    TestEntity *entity = [[TestEntity alloc] init];
    [realm addObject:entity];

    return entity;
}

@end
