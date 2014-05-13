//
//  HBActivityIndicator.m
//  Capture-SharedLibrary
//
//  Created by hatebyte on 5/6/14.
//  Copyright (c) 2014 hatebyte. All rights reserved.
//

#import "CYActivityIndicator.h"

@interface CYActivityIndicator () {
    UIImageView *_activityImageView;
}

@end


@implementation CYActivityIndicator

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _activityImageView                                      = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"global_spinner"]];
        _activityImageView.frame                                = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addSubview:_activityImageView];
        [self startActivityIndication];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    _activityImageView.frame                                    = CGRectMake(0, 0, frame.size.width, frame.size.height);
}

- (void)startActivityIndication {
    NSString *keypath = @"com.capturemedia.transform.spin";
    if (![_activityImageView.layer animationForKey:keypath]) {
        CABasicAnimation *rotation                                  = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        rotation.fromValue                                          = [NSNumber numberWithFloat:0];
        rotation.toValue                                            = [NSNumber numberWithFloat:(2 * M_PI)];
        rotation.duration                                           = 0.85;
        rotation.repeatCount                                        = HUGE_VALF;
        [_activityImageView.layer addAnimation:rotation forKey:keypath];
        _activityImageView.hidden                                   = NO;
        self.hidden                                                 = NO;
    }
}

- (void)stopActivityIndication {
    _activityImageView.hidden                                   = YES;
    [_activityImageView.layer removeAllAnimations];
    self.hidden                                                 = YES;
}

@end
