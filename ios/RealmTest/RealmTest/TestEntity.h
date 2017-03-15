//
//  TestEntity.h
//  RealmTest
//
//  Created by Hirohisa Kobayasi on 2017/03/15.
//  Copyright © 2017年 Hirohisa Kobayasi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

@interface TestEntity : RLMObject

@property NSInteger id;
@property NSString *title;
@property NSString *desc;

@end
