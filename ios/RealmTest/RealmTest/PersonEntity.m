//
//  PersonEntity.m
//  RealmTest
//
//  Created by Hirohisa Kobayasi on 2017/03/27.
//  Copyright © 2017年 Hirohisa Kobayasi. All rights reserved.
//

#import "PersonEntity.h"

#define UPDATE_AFTER_CREATE
#define DELETE_AFTER_CREATE

@implementation PersonEntity

+ (void)createOrUpdateInRealm:(RLMRealm *)realm
                     personId:(NSString *)personId
                    firstName:(NSString *)firstName
                     lastName:(NSString *)lastName {

#if defined UPDATE_AFTER_CREATE
    __block PersonEntity *entity = [[self.class objectsInRealm:realm
                                                         where:@"personId=%@", personId] firstObject];
    [realm transactionWithBlock:^{
        if (entity == nil) {
            entity = [self.class createInRealm:realm
                                     withValue:@{ @"personId": personId }];
        }

        entity.firstName = [firstName copy];
        entity.lastName = [lastName copy];
    }];
#elif defined DELETE_AFTER_CREATE
    __block PersonEntity *entity;

    [realm transactionWithBlock:^{
        entity = [self.class createInRealm:realm
                                 withValue:@{
                                             @"personId": [personId copy],
                                             @"firstName": [firstName copy],
                                             @"lastName": [lastName copy]
                                             }];
    }];

    RLMResults<PersonEntity *> *entities = [self.class objectsInRealm:realm
                                                              where:@"personId=%@", personId];
    if (entities.count > 1) {
        [realm transactionWithBlock:^{
            [realm deleteObject:entity];
        }];
    }
#else
    PersonEntity *entity = [[self.class objectsInRealm:realm
                                                 where:@"personId=%@", personId] firstObject];
    if (entity == nil) {
        [realm transactionWithBlock:^{
            [self.class createInRealm:realm
                            withValue:@{
                                        @"personId": [personId copy],
                                        @"firstName": [firstName copy],
                                        @"lastName": [lastName copy]
                                        }];
        }];
    } else {
        [realm transactionWithBlock:^{
            entity.firstName = [firstName copy];
            entity.lastName = [lastName copy];
        }];
    }
#endif
}

@end
