//
//  ViewController.m
//  HBCoreData-Example
//
//  Created by hatebyte on 5/6/14.
//  Copyright (c) 2014 hatebyte. All rights reserved.
//

#import "RootViewController.h"
#import "FetchAllViewController.h"
#import "FetchWithPredicateViewController.h"
#import "OverloadExampleViewController.h"
#import "CYCoreData.h"
#import "Listing+API.h"
#import "ExampleCYData.h"

@interface RootViewController () <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSArray *listings;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title                               = @"CYCoreData";
    self.navigationController.navigationBar.barTintColor    = [UIColor colorWithWhite:.2f alpha:1.f];
    NSMutableDictionary *textAttributes                     = [[NSMutableDictionary alloc] initWithDictionary:self.navigationController.navigationBar.titleTextAttributes];
    [textAttributes setValue:[UIColor colorWithWhite:.7f alpha:1.f] forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = textAttributes;
    self.navigationController.navigationBar.translucent     = NO;

    self.view.backgroundColor                               = [UIColor colorWithWhite:.2f alpha:1.f];

    _listings                                               = [NSArray arrayWithObjects:
                                                               [NSArray arrayWithObjects:@"Fetch all", @"Fetch with predicate", nil]
                                                               ,[NSArray arrayWithObjects:@"Overload Example", nil]
                                                               ,[NSArray arrayWithObjects:@"Clear database", nil]
                                                               , nil];
    
    _tableView                                              = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                                                            0,
                                                                                                            self.view.bounds.size.width,
                                                                                                            self.view.bounds.size.height)];
    _tableView.backgroundColor                              = [UIColor colorWithWhite:.1f alpha:1.f];
    _tableView.separatorStyle                               = UITableViewCellSeparatorStyleNone;
    _tableView.delegate                                     = self;
    _tableView.dataSource                                   = self;
    [self.view addSubview:_tableView];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView delegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section != 0) {
        return 30.f;
    }
    return 0.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section != 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
        view.backgroundColor = [UIColor colorWithWhite:.2f alpha:1.f];
        return view;
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.listings count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.listings objectAtIndex:section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.f;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell                                   = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellReuseIdentifier"];
    if (cell == nil) {
        cell                                                = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCellReuseIdentifier"];
    }
    
    cell.textLabel.text                                     = [[self.listings objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    if (indexPath.section == 2) {
        cell.contentView.backgroundColor                    = [UIColor redColor];
        cell.textLabel.textColor                            = [UIColor whiteColor];
        cell.textLabel.textAlignment                        = NSTextAlignmentCenter;
    } else {
        cell.contentView.backgroundColor                    = [UIColor colorWithWhite:.13f alpha:1.f];
        cell.textLabel.textColor                            = [UIColor colorWithWhite:.4f alpha:1.f];
        cell.selectionStyle                                 = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0: {
                FetchAllViewController *fetchAllViewController = [[FetchAllViewController alloc] init];
                [self.navigationController pushViewController:fetchAllViewController animated:YES];
            }
                break;
            case 1:{
                FetchWithPredicateViewController *fetchWithPredicateViewController = [[FetchWithPredicateViewController alloc] init];
                [self.navigationController pushViewController:fetchWithPredicateViewController animated:YES];
            }
                break;
        }
    } else if (indexPath.section == 1) {
        OverloadExampleViewController *overloadExampleViewController = [[OverloadExampleViewController alloc] init];
        [self.navigationController pushViewController:overloadExampleViewController animated:YES];
    } else {
        [ExampleCYData reset];
    }
    [self.tableView reloadData];
}


@end




























