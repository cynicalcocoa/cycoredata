//
//  FetchAllViewController.m
//  HBCoreData-Example
//
//  Created by hatebyte on 5/6/14.
//  Copyright (c) 2014 hatebyte. All rights reserved.
//

#import "FetchAllViewController.h"
#import "ExampleCYData.h"
#import "Listing+API.h"
#import "Listing+Read.h"
#import <AFNetworking.h>

@interface FetchAllViewController () <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSArray *listings;
@property(nonatomic, strong) AFHTTPRequestOperation *currentOperation;

@end

@implementation FetchAllViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor                               = [UIColor colorWithWhite:.2f alpha:1.f];
    
    _tableView                                              = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                                                            0,
                                                                                                            self.view.bounds.size.width,
                                                                                                            self.view.bounds.size.height-64)];
    _tableView.backgroundColor                              = [UIColor colorWithWhite:.1f alpha:1.f];
    _tableView.separatorStyle                               = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    __weak typeof(self) weakSelf                            = self;
    _currentOperation                                       = [Listing getRedditListingsWithComplete:^{
        [weakSelf fetchAll];
    } failure:^(NSError *error) {
        NSLog(@"%@", error.localizedDescription);
    }];
    
    [self fetchAll];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_currentOperation cancel];
}

- (void)fetchAll {
    __weak typeof(self) weakSelf                            = self;
    NSManagedObjectContext *readContext                     = [ExampleCYData readContext];
    [readContext performBlockAndWait:^{
        weakSelf.listings                                   = [Listing fetchMostRecentWithContext:readContext];
        [weakSelf.tableView reloadData];
        
        weakSelf.navigationItem.title                       = [NSString stringWithFormat:@"%ld Local Listings", (long)[weakSelf.listings count]];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.listings count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.f;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell                                   = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellReuseIdentifier"];
    if (cell == nil) {
        cell                                                = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCellReuseIdentifier"];
    }
    Listing *listing                                        = [self.listings objectAtIndex:indexPath.row];
    cell.textLabel.text                                     = listing.title;
    cell.contentView.backgroundColor                        = [UIColor colorWithWhite:.13f alpha:1.f];
    cell.textLabel.textColor                                = [UIColor colorWithWhite:.4f alpha:1.f];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


@end




























