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

    NSLog(@"Realm DB Path : %@", dbPath);
    NSLog(@"Realm DB Size: %lld bytes", [fileSize longLongValue]);
    NSLog(@"Realm Instance: %@", [NSValue valueWithPointer:(__bridge const void *) realm]);

    return realm;
}


+ (TestEntity *)entityFromRealm:(RLMRealm *)realm {
    TestEntity *entity = [[TestEntity alloc] init];
    [realm addObject:entity];

    return entity;
}

+ (void)addEntities {
    RLMRealm *realm = [self.class realm];
    for (int i = 0; i < 1000; i++) {
        [realm transactionWithBlock:^{
            TestEntity *entity = [self.class entityFromRealm:realm];
            entity.id = i;
            entity.title = [NSString stringWithFormat:@"title%d", i];
            entity.desc = [NSString stringWithFormat:@"desc%d", i];
        }
                              error:nil];
    }
}

+ (void)deleteEntities {
    RLMRealm *realm = [self.class realm];
    RLMResults<TestEntity *> *results = [TestEntity allObjectsInRealm:realm];
    NSUInteger count = results.count;
    if (count > 1000) {
        count = 1000;
    }

    NSMutableArray *entities = [NSMutableArray arrayWithCapacity:count];
    NSUInteger startIndex = results.count - 1;
    NSUInteger endIndex = results.count - count;
    for (NSUInteger i = startIndex; i >= endIndex; i--) {
        [entities addObject:results[i]];
    }

    for (int i = 0; i < count; i++) {
        [realm transactionWithBlock:^{
            [realm deleteObject:entities[i]];
        }];
    }
}

@end
