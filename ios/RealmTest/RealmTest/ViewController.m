//
//  ViewController.m
//  RealmTest
//
//  Created by Hirohisa Kobayasi on 2017/03/15.
//  Copyright © 2017年 Hirohisa Kobayasi. All rights reserved.
//

#import "ViewController.h"
#import "ArrayTableViewController.h"
#import "RealmManager.h"
#import "LeakReference.h"


@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (nonatomic) ArrayTableViewController *childViewController;
@property (nonatomic) TestEntity *entityReference;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.childViewController = [[ArrayTableViewController alloc] initWithNibName:@"ArrayTableViewController"
                                                                          bundle:nil];
    [self addChildViewController:self.childViewController];
    [self.view addSubview:self.childViewController.view];
    [self.childViewController didMoveToParentViewController:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    NSLog(@"containerView.frame: %@", NSStringFromCGRect(self.containerView.frame));
    self.childViewController.view.frame = self.containerView.frame;
}


- (IBAction)onAddEntities:(id)sender {
    [RealmManager addEntities];
}

- (IBAction)onDeleteEntities:(id)sender {
    [RealmManager deleteEntities];
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

- (IBAction)onRetainReleaseReference:(id)sender {
    if (self.entityReference != nil) {
        self.entityReference = nil;
    } else {
        RLMRealm *realm = [RealmManager realm];
        [realm transactionWithBlock:^{
            self.entityReference = [[TestEntity allObjects] firstObject];
        }];
    }
}

@end
