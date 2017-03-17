//
//  RealmManager.m
//  RealmTest
//
//  Created by Hirohisa Kobayasi on 2017/03/15.
//  Copyright © 2017年 Hirohisa Kobayasi. All rights reserved.
//

#import "RealmManager.h"


@implementation RealmManager

+ (BOOL)compactRealm {
    BOOL result = NO;

    NSURL *fileUrl = [[RLMRealmConfiguration defaultConfiguration] fileURL];
    NSURL *tmpUrl = [NSURL fileURLWithPath:[fileUrl.path stringByAppendingString:@".tmp"]];

    NSError *error;
    NSFileManager *manager = [NSFileManager defaultManager];

    if ([manager fileExistsAtPath:[tmpUrl path]]) {
        error = nil;
        if (![manager removeItemAtURL:tmpUrl
                                error:&error]) {
            // log error
            return NO;
        }
    }

    error = nil;
    if (![[RLMRealm defaultRealm] writeCopyToURL:tmpUrl
                                   encryptionKey:nil
                                           error:&error]) {
        // log error
        return NO;
    }

    error = nil;
    if ([manager removeItemAtURL:fileUrl
                           error:&error]) {
        if ([manager moveItemAtURL:tmpUrl
                         toURL:fileUrl
                             error:&error]) {
            result = YES;
        } else {
            // log error
        }
    } else {
        // log error
    }

    return result;
}


+ (RLMRealm *)realm {
    RLMRealm *realm = [RLMRealm defaultRealm];
    NSURL *dbPath = [[RLMRealmConfiguration defaultConfiguration] fileURL];
    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:dbPath.path
                                                                                error:nil];
    NSNumber *fileSize = [attributes objectForKey:NSFileSize];

//    NSLog(@"Realm DB Path : %@", dbPath);
    NSLog(@"Realm DB Size: %lld bytes", [fileSize longLongValue]);
    NSLog(@"Realm Instance: %@", [NSValue valueWithPointer:(__bridge const void *) realm]);

    return realm;
}


+ (TestEntity *)entityFromRealm:(RLMRealm *)realm {
    TestEntity *entity = [[TestEntity alloc] init];
    [realm addObject:entity];

    return entity;
}

@end
