//
//  RealmManager.m
//  RealmTest
//
//  Created by Hirohisa Kobayasi on 2017/03/15.
//  Copyright © 2017年 Hirohisa Kobayasi. All rights reserved.
//

#import "RealmManager.h"
#import "PersonEntity.h"


static const int LOOP_COUNT = 10;

@interface RealmManager ()

- (void)addEntitiesForRealm:(RLMRealm *)realm;
- (void)deleteEntitiesFromRealm:(RLMRealm *)realm;

@end


@implementation RealmManager

+ (RealmManager *)sharedInstance {
    static RealmManager *singleInstance;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleInstance = [[RealmManager alloc] init];
    });

    return singleInstance;
}

+ (BOOL)deleteRealm {
    BOOL result = NO;

    NSURL *fileUrl = [[RLMRealmConfiguration defaultConfiguration] fileURL];

    NSError *error;
    NSFileManager *manager = [NSFileManager defaultManager];

    if ([manager fileExistsAtPath:[fileUrl path]]) {
        error = nil;
        if ([manager removeItemAtURL:fileUrl
                                error:&error]) {
            result = YES;
        } else {
            // log error
        }
    }

    return result;
}

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

- (void)logDbInfo {
    // Realm instance information
    NSURL *dbPath = [[RLMRealmConfiguration defaultConfiguration] fileURL];
    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:dbPath.path
                                                                                error:nil];
    NSNumber *fileSize = [attributes objectForKey:NSFileSize];

    NSLog(@"Realm DB Path : %@", dbPath);
    NSLog(@"Realm DB Size: %lld bytes", [fileSize longLongValue]);
}

- (RLMRealm *)defaultRealm {
    static NSMutableDictionary *mainDictionary;
    static NSMutableDictionary *workerDictionary;;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mainDictionary = @{}.mutableCopy;
        workerDictionary = @{}.mutableCopy;
    });

    RLMRealm *realm = [RLMRealm defaultRealm];

    NSValue *pointer = [NSValue valueWithPointer:(__bridge const void *) realm];
    if ([NSThread isMainThread]) {
        if (mainDictionary[pointer] != nil) {
            NSLog(@"--- Main  : Exists Realm Instance: %@", pointer);
        } else {
            mainDictionary[pointer] = [NSNumber numberWithBool:YES];
            NSLog(@"--- Main  : New Realm Instance   : %@", pointer);
        }
    } else {
        if (workerDictionary[pointer] != nil) {
            NSLog(@"--- Worker: Exists Realm Instance: %@", pointer);
        } else {
            workerDictionary[pointer] = [NSNumber numberWithBool:YES];
            NSLog(@"--- Worker: New Realm Instance   : %@", pointer);
        }
    }

    return realm;
}


- (TestEntity *)testEntity {
    RLMRealm *realm = [self defaultRealm];

    TestEntity *entity = [TestEntity createInRealm:realm
                                         withValue:@{ @"id":[NSNumber numberWithInt:0] }];

    return entity;
}

- (PersonEntity *)personEntity {
    RLMRealm *realm = [self defaultRealm];

    PersonEntity *entity = [PersonEntity createInRealm:realm
                                             withValue:@{ @"personId":[NSNumber numberWithInt:0] }];

    return entity;
}

- (void)addEntitiesOnMain {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self addEntitiesForRealm:[self defaultRealm]];
    });
}

- (void)deleteEntitiesOnMain {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self deleteEntitiesFromRealm:[self defaultRealm]];
    });
}

- (void)addEntitiesOnWorker {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0UL), ^{
        [self addEntitiesForRealm:[self defaultRealm]];
    });
}

- (void)deleteEntitiesOnWorker {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0UL), ^{
        [self deleteEntitiesFromRealm:[self defaultRealm]];
    });
}


- (void)addEntitiesForRealm:(RLMRealm *)realm {

    RLMResults<TestEntity *> *results = [TestEntity allObjectsInRealm:realm];
    NSLog(@"before addEntities: TestEnitity count: %lu", (unsigned long) results.count);

    // トランザクションをループ内にし事象を起こしやすくする
    for (int i = 0; i < LOOP_COUNT; i++) {
        [realm transactionWithBlock:^{
            TestEntity *entity = [self testEntity];
            entity.id = i;
            entity.title = [NSString stringWithFormat:@"title%d", i];
            entity.desc = [NSString stringWithFormat:@"desc%d", i];
        }
                              error:nil];
    }

    NSLog(@"after addEntities: TestEnitity count: %lu", (unsigned long) results.count);
}

- (void)deleteEntitiesFromRealm:(RLMRealm *)realm {
    RLMResults<TestEntity *> *results = [TestEntity allObjectsInRealm:realm];
    NSLog(@"befor deleteEntities: TestEnitity count: %lu", (unsigned long) results.count);

    int count = (int) results.count;
    if (count > LOOP_COUNT) {
        count = LOOP_COUNT;
    }

    NSMutableArray *entities = [NSMutableArray arrayWithCapacity:count];
    int startIndex = (int) results.count - 1;
    int endIndex = (int) results.count - count;
    for (int i = startIndex; i >= endIndex; i--) {
        [entities addObject:results[i]];
    }

    // トランザクションをループ内にし事象を起こしやすくする
    for (int i = 0; i < count; i++) {
        [realm transactionWithBlock:^{
            [realm deleteObject:entities[i]];
        }];
    }

    NSLog(@"after deleteEntities: TestEnitity count: %lu", (unsigned long) results.count);
}


- (void)createOrUpdatePersonTable {
    RLMRealm *realm = [self defaultRealm];
    for (int i = 0; i < LOOP_COUNT; i++) {
        NSString *personId = [NSString stringWithFormat:@"%d", i];
        NSString *firstName = [NSString stringWithFormat:@"firstName%d", i];
        NSString *lastName = [NSString stringWithFormat:@"lastName%d", i];

        [PersonEntity createOrUpdateInRealm:realm
                                   personId:personId
                                  firstName:firstName
                                   lastName:lastName];
    }

    [self logDbInfo];
}


@end
