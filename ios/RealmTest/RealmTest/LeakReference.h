//
//  LeakReference.h
//  RealmTest
//
//  Created by Hirohisa Kobayasi on 2017/03/17.
//  Copyright © 2017年 Hirohisa Kobayasi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TestEntity.h"

@interface LeakReference : NSObject

@property (nonatomic) LeakReference *reference;
@property (nonatomic) TestEntity *entity;

@end
