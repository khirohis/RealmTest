//
//  ArrayTableViewController.m
//  RealmTest
//
//  Created by Hirohisa Kobayasi on 2017/03/22.
//  Copyright © 2017年 Hirohisa Kobayasi. All rights reserved.
//

#import "ArrayTableViewController.h"
#import "RealmManager.h"


@interface ArrayTableViewController ()

@property (nonatomic) NSArray<PersonEntity *> *entityList;

@end


@implementation ArrayTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"UITableViewCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)reload {
    RLMRealm *realm = [[RealmManager sharedInstance] defaultRealm];
    RLMResults<PersonEntity *> *results = [PersonEntity allObjectsInRealm:realm];

    NSMutableArray *entities = [NSMutableArray arrayWithCapacity:results.count];
    for (PersonEntity *entity in results) {
        [entities addObject:entity];
    }

    self.entityList = [entities copy];

    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return self.entityList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"
                                                            forIndexPath:indexPath];

    PersonEntity *entity = self.entityList[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", entity.firstName, entity.lastName];

    return cell;
}

@end
