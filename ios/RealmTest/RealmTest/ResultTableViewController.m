//
//  ResultTableViewController.m
//  RealmTest
//
//  Created by Hirohisa Kobayasi on 2017/04/03.
//  Copyright © 2017年 Hirohisa Kobayasi. All rights reserved.
//

#import "ResultTableViewController.h"
#import "RealmManager.h"

@interface ResultTableViewController ()

@property (nonatomic) RLMResults<PersonEntity *> *entityList;

@end

@implementation ResultTableViewController

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

    self.entityList = results;

    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
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
