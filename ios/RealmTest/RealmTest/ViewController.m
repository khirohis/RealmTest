//
//  ViewController.m
//  RealmTest
//
//  Created by Hirohisa Kobayasi on 2017/03/15.
//  Copyright © 2017年 Hirohisa Kobayasi. All rights reserved.
//

#import "ViewController.h"
#import "RealmManager.h"
#import "LeakReference.h"


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


- (IBAction)onAddEntities:(id)sender {
    RLMRealm *realm = [RealmManager realm];
    for (int i = 0; i < 1000; i++) {
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
    RLMRealm *realm = [RealmManager realm];
    RLMResults<TestEntity *> *results = [TestEntity allObjectsInRealm:realm];
    NSUInteger count = results.count;
    if (count > 1000) {
        count = 1000;
    }

    NSMutableArray *entities = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i++) {
        [entities addObject:results[i]];
    }

    for (int i = 0; i < count; i++) {
        [realm transactionWithBlock:^{
                [realm deleteObject:entities[i]];
        }];
    }
}

- (IBAction)onCompactRealm:(id)sender {
    [RealmManager compactRealm];
}

- (IBAction)onCreateLeak:(id)sender {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0UL), ^{
        LeakReference *leak1 = [[LeakReference alloc] init];
        LeakReference *leak2 = [[LeakReference alloc] init];

        RLMRealm *realm = [RealmManager realm];
        [realm transactionWithBlock:^{
            leak1.entity = [RealmManager entityFromRealm:realm];
            leak2.entity = [RealmManager entityFromRealm:realm];
        }];

        leak1.reference = leak2;
        leak2.reference = leak1;
    });
}

@end
