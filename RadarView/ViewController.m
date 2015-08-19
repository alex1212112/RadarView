//
//  ViewController.m
//  RadarView
//
//  Created by Ren Guohua on 15/8/19.
//  Copyright (c) 2015年 Ren guohua. All rights reserved.
//

#import "ViewController.h"
#import "CSTRadarView.h"

@interface ViewController ()

@property (nonatomic, strong) CSTRadarView *radarView;

- (IBAction)start:(id)sender;

- (IBAction)stop:(id)sender;

@end

@implementation ViewController

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self p_configSubViews];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
  
}

#pragma mark - Private method


- (void)p_configSubViews{
    
    [self.view addSubview:self.radarView];
    [self p_configLayoutConstraintsWithRadarView];
}

- (void)p_configLayoutConstraintsWithRadarView{

    self.radarView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *constraintCenterX = [NSLayoutConstraint constraintWithItem:self.radarView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
    NSLayoutConstraint *constraintCenterY = [NSLayoutConstraint constraintWithItem:self.radarView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
    
    NSLayoutConstraint *constraintWidth = [NSLayoutConstraint constraintWithItem:self.radarView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:9.0 / 10.0 constant:0.0];
    
    NSLayoutConstraint *constraintHeight = [NSLayoutConstraint constraintWithItem:self.radarView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.radarView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0];
    
    
    [NSLayoutConstraint activateConstraints:@[constraintCenterX,constraintCenterY,constraintWidth,constraintHeight]];
}


#pragma mark - Event response
- (IBAction)start:(id)sender {
    
    [self.radarView startAnimation];
}

- (IBAction)stop:(id)sender {
    [self.radarView stopAnimation];
}


#pragma mark - Setters and getters

- (CSTRadarView *)radarView{

    if (!_radarView) {
        
        _radarView = [[CSTRadarView alloc] init];
        _radarView.width = 3.0;
        _radarView.color = [UIColor whiteColor];
    }
    
    return _radarView;
}


@end
