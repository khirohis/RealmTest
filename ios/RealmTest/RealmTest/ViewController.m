//
//  ViewController.m
//  RealmTest
//
//  Created by Hirohisa Kobayasi on 2017/03/15.
//  Copyright © 2017年 Hirohisa Kobayasi. All rights reserved.
//

#import "ViewController.h"
#import "RealmManager.h"


@interface ViewController ()

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)onAddRealmInstance:(id)sender {
    for (int i = 0; i < 1000; i++) {
        RLMRealm *realm = [RealmManager realmInstance];
        [realm transactionWithBlock:^{
            TestEntity *entity = [RealmManager entityFromRealm:realm];
            entity.id = i;
            entity.title = [NSString stringWithFormat:@"title%d", i];
            entity.desc = [NSString stringWithFormat:@"desc%d", i];
        }
                              error:nil];
    }
}

- (IBAction)onAddRealmSingleInstance:(id)sender {
    for (int i = 0; i < 1000; i++) {
        RLMRealm *realm = [RealmManager realmSingleInstance];
        [realm transactionWithBlock:^{
            TestEntity *entity = [RealmManager entityFromRealm:realm];
            entity.id = i;
            entity.title = [NSString stringWithFormat:@"title%d", i];
            entity.desc = [NSString stringWithFormat:@"desc%d", i];
        }
                              error:nil];
    }
}

- (IBAction)onDeleteEntities:(id)sender {
    RLMRealm *realm = [RealmManager realmInstance];
    RLMResults<TestEntity *> *results = [TestEntity allObjectsInRealm:realm];
    NSUInteger count = results.count;
    if (count > 1000) {
        count = 1000;
    }

    for (int i = 0; i < count; i++) {
        [realm transactionWithBlock:^{
            [realm deleteObject:results[i]];
        }];
    }
}

- (IBAction)onDeleteEntitiesSingle:(id)sender {
    RLMRealm *realm = [RealmManager realmSingleInstance];
    RLMResults<TestEntity *> *results = [TestEntity allObjectsInRealm:realm];
    NSUInteger count = results.count;
    if (count > 1000) {
        count = 1000;
    }
    
    for (int i = 0; i < count; i++) {
        [realm transactionWithBlock:^{
            [realm deleteObject:results[i]];
        }];
    }
}

- (IBAction)onCompactRealm:(id)sender {
    [RealmManager compactRealm];
}

@end
