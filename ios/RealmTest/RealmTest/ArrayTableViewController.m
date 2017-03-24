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

@property (nonatomic) NSArray<TestEntity *> *entityList;

@end


@implementation ArrayTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"UITableViewCell"];

    [self reload];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)reload {
    RLMRealm *realm = [RealmManager realm];
    RLMResults *results = [TestEntity allObjectsInRealm:realm];

    NSMutableArray *entities = [NSMutableArray arrayWithCapacity:results.count];
    for (TestEntity *entity in results) {
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

    cell.textLabel.text = self.entityList[indexPath.row].title;

    return cell;
}


/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
