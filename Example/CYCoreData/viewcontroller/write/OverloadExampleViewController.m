//
//  ThreadDemoViewController.m
//  CaptureMedia-Data
//
//  Created by hatebyte on 2/21/14.
//  Copyright (c) 2014 CaptureMedia. All rights reserved.
//


#import "OverloadExampleViewController.h"
#import "ExampleCYData.h"
#import "CYActivityIndicator.h"
#import "Listing+Read.h"
#import "Listing+Write.h"
#import "Listing+Util.h"

@interface OverloadExampleViewController ()

@property(nonatomic, strong) NSMutableArray *indicators;
@property(nonatomic, weak) NSManagedObjectContext *mainThreadContext;
@property(nonatomic, strong) UIButton *mainbutton;
@property(nonatomic, strong) UIButton *temporarybutton;
@property(nonatomic, strong) UILabel *label;

@end

@implementation OverloadExampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect bounds                                               = self.view.bounds;
    self.view.backgroundColor                                   = [UIColor blackColor];
    
    self.label                                                  = [[UILabel alloc] initWithFrame:CGRectMake(20, bounds.size.height - 180, 280, 100)];
    self.label.textColor                                        = [UIColor whiteColor];
    self.label.textAlignment                                    = NSTextAlignmentCenter;
    self.label.backgroundColor                                  = [UIColor clearColor];
    self.label.numberOfLines                                    = 0;
    [self.view addSubview:self.label];
    
    self.temporarybutton                                          = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.temporarybutton setTitle:@"WritingContext" forState:UIControlStateNormal];
    [self.temporarybutton addTarget:self action:@selector(activate:) forControlEvents:UIControlEventTouchUpInside];
    self.temporarybutton.frame                                    = CGRectMake(0, .5, 160, 64);
    self.temporarybutton.backgroundColor                          = [UIColor colorWithWhite:.2f alpha:1.f];
    [self.temporarybutton setTitleColor:[UIColor colorWithWhite:.4f alpha:1.f] forState:UIControlStateNormal];
    self.temporarybutton.tag                                      = 0;
    [self.view addSubview:self.temporarybutton];
    
    self.mainbutton                                             = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.mainbutton setTitle:@"ReadingContext" forState:UIControlStateNormal];
    [self.mainbutton addTarget:self action:@selector(activate:) forControlEvents:UIControlEventTouchUpInside];
    self.mainbutton.frame                                       = CGRectMake(self.temporarybutton.frame.size.width + .5, .5, 160, 64);
    self.mainbutton.backgroundColor                             = [UIColor colorWithWhite:.2f alpha:1.f];
    [self.mainbutton setTitleColor:[UIColor colorWithWhite:.4f alpha:1.f] forState:UIControlStateNormal];
    self.mainbutton.tag                                         = 1;
    [self.view addSubview:self.mainbutton];
    
    self.indicators                                             = [NSMutableArray new];
    int i                                                       = 0;
    for (i=0; i < 300; i++) {
        CYActivityIndicator *activityIndicator                  = [[CYActivityIndicator alloc] initWithFrame:CGRectZero];
        activityIndicator.alpha                                 = 0.f;
        [self.indicators addObject:activityIndicator];
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [ExampleCYData reset]; // If we don't clear it here, we will drag down the rest of the application with 10s of thousands of records
}

- (void)readDataBase {
    NSInteger count                                             = [Listing fetchCountInContext:[ExampleCYData readContext] withPredicate:nil];
    [self setText:[NSString stringWithFormat:@"%ld submissions in database", (long)count]];
}

- (void)setText:(NSString *)text {
    self.label.text                                             = text;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)activate:(UIButton *)sender {
    [self addActivityIndicators];
    [self createAndFetchMassiveListings:(BOOL)sender.tag];
    [self.temporarybutton removeTarget:self action:@selector(activate:) forControlEvents:UIControlEventTouchUpInside];
    [self.mainbutton removeTarget:self action:@selector(activate:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)finish {
    [self.temporarybutton addTarget:self action:@selector(activate:) forControlEvents:UIControlEventTouchUpInside];
    [self.mainbutton addTarget:self action:@selector(activate:) forControlEvents:UIControlEventTouchUpInside];
    [self removeActivityIndicators];
}

- (void)addActivityIndicators {
    CGRect bounds                                               = [UIScreen mainScreen].bounds;
    __weak typeof(&*self) weakSelf                              = self;
    [self.indicators enumerateObjectsUsingBlock:^(CYActivityIndicator *activityIndicator, NSUInteger idx, BOOL *stop) {
        double delay                                            = (idx * .004) * NSEC_PER_SEC;
        dispatch_time_t popTime                                 = dispatch_time(DISPATCH_TIME_NOW, (int64_t)delay);
        dispatch_after(popTime, dispatch_get_main_queue(), ^{
            CGFloat size                                        = 60 * ((float)rand() / RAND_MAX);
            CGFloat x                                           = (bounds.size.width - size) * ((float)rand() / RAND_MAX);
            CGFloat y                                           = (((bounds.size.height-128) - size) * ((float)rand() / RAND_MAX)) + 64;
            activityIndicator.frame                             = CGRectMake(x, y, size, size);
            [weakSelf.view addSubview:activityIndicator];
            [activityIndicator startActivityIndication];
            [UIView animateWithDuration:.4 animations:^{
                activityIndicator.alpha                         = ((float)rand() / RAND_MAX) + .2;
            }];
            [self.view addSubview:self.mainbutton];
            [self.view addSubview:self.temporarybutton];
            [self.view addSubview:self.label];
        });
    }];
}

- (void)removeActivityIndicators {
    [self.indicators enumerateObjectsUsingBlock:^(CYActivityIndicator *activityIndicator, NSUInteger idx, BOOL *stop) {
        double delay                                            = (idx * .007) * NSEC_PER_SEC;
        dispatch_time_t popTime                                 = dispatch_time(DISPATCH_TIME_NOW, (int64_t)delay);
        dispatch_after(popTime, dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:.4 animations:^{
                activityIndicator.alpha                         = 0.f;
            } completion:^(BOOL finished) {
                [activityIndicator stopActivityIndication];
                 [activityIndicator removeFromSuperview];
            }];
        });
    }];
    
    [UIView animateWithDuration:.5
                          delay:3
                        options:UIViewAnimationOptionCurveEaseIn animations:^{
                            self.temporarybutton.alpha          = 1.f;
                            self.mainbutton.alpha               = 1.f;
                        } completion:^(BOOL finished) {
                            self.temporarybutton.enabled        = YES;
                            self.mainbutton.enabled             = YES;
                        }];
}

- (void)createsRandomListings:(NSInteger)numListings withExtras:(NSInteger)extras withContext:(NSManagedObjectContext *)context {
    __weak typeof(&*self) weakSelf                              = self;
    int i                                                       = 0;
    for (i=0; i < numListings; i++) {
        Listing *listing                                        = [Listing newObjectInContext:context];
        listing.isSelfBool                                      = YES;
        listing.title                                           = [NSString stringWithFormat:@"Title for listing : %d", i];
        listing.createdUtc                                      = [NSDate date];
        [self.mainThreadContext performBlock:^{
            [weakSelf setText:[NSString stringWithFormat:@"Creating %d Listings", i+1]];
        }];
    }
    int j                                                       = i;
    i                                                           = 0;
    for (i=0; i < extras; i++) {
        Listing *listing                                        = [Listing newObjectInContext:context];
        listing.isSelfBool                                      = NO;
        listing.title                                           = [NSString stringWithFormat:@"Title for listing : %d", i+j];
        listing.createdUtc                                      = [NSDate date];
        [self.mainThreadContext performBlock:^{
            [weakSelf setText:[NSString stringWithFormat:@"Creating %ld Listings", (long)(i + numListings + 1)]];
        }];
    }
}

- (void)createAndFetchMassiveListings:(BOOL)onMain {
    [self setText:@""];
    self.mainThreadContext                                      = [ExampleCYData readContext];
    self.temporarybutton.enabled                                = NO;
    self.mainbutton.enabled                                     = NO;
    
    NSManagedObjectContext *context;
    UIButton *tempbutton;
    if (onMain) {
        context                                                 = [ExampleCYData readContext];
        tempbutton                                              = self.temporarybutton;
    } else {
        context                                                 = [ExampleCYData temporaryWriteContext];
        tempbutton                                              = self.mainbutton;
    }
    
    __weak typeof(&*self) weakSelf                              = self;
    [UIView animateWithDuration:.4 animations:^{
        tempbutton.alpha                                        = 0.f;
    }];
    
    NSInteger numListings                                       = 10000;
    NSInteger extras                                            = 136;
    NSInteger nons                                              = 5000;
    
    [context performBlock:^{
        
        [weakSelf createsRandomListings:(numListings + extras) withExtras:nons withContext:context];
        [weakSelf.mainThreadContext performBlockAndWait:^{
            [weakSelf setText:[NSString stringWithFormat:@"%ld Listings Saving", (long)(extras + numListings + nons)]];
        }];
        [context saveAsynchronously];
        
        [weakSelf.mainThreadContext performBlockAndWait:^{
            [weakSelf setText:@"Paginating by every 10,000..."];
        }];

        [weakSelf.mainThreadContext performBlock:^{
            NSSortDescriptor *dateDescriptor                    = [[NSSortDescriptor alloc] initWithKey:@"createdUtc" ascending:NO];
            NSPredicate *predicate                              = [NSPredicate predicateWithFormat:@"self.isSelf == 1"];
            NSArray *page1Listings                              = [Listing fetchObjectsInContext:weakSelf.mainThreadContext
                                                                                    byPageNumber:1
                                                                              withObjectsPerPage:numListings
                                                                                    andPredicate:predicate
                                                                                withSortDescriptors:[NSArray arrayWithObject:dateDescriptor]];
            NSArray *page2Listings                              = [Listing fetchObjectsInContext:weakSelf.mainThreadContext
                                                                                    byPageNumber:2
                                                                              withObjectsPerPage:numListings
                                                                                    andPredicate:predicate
                                                                             withSortDescriptors:[NSArray arrayWithObject:dateDescriptor]];
            NSInteger count                                     = [Listing fetchCountInContext:weakSelf.mainThreadContext withPredicate:nil];
            NSString *inDbText                                  = [NSString stringWithFormat:@"%ld Listings in database", (long)count];
            NSString *page1Text                                 = [NSString stringWithFormat:@"Page 1 : %ld", (long)[page1Listings count]];
            NSString *page2Text                                 = [NSString stringWithFormat:@"Page 2 : %ld", (long)[page2Listings count]];
            NSString *text                                      = [NSString stringWithFormat:@"%@\n%@\n%@\n", inDbText, page1Text, page2Text];
            
            [weakSelf setText:text];
            [weakSelf finish];
        }];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

