//
//  PersonEntity.h
//  RealmTest
//
//  Created by Hirohisa Kobayasi on 2017/03/27.
//  Copyright © 2017年 Hirohisa Kobayasi. All rights reserved.
//

#import <Realm/Realm.h>

@interface PersonEntity : RLMObject

@property NSString *personId;
@property NSString *firstName;
@property NSString *lastName;

+ (void)createOrUpdateInRealm:(RLMRealm *)realm
                     personId:(NSString *)personId
                    firstName:(NSString *)firstName
                     lastName:(NSString *)lastName;

@end
