//
//  QBGameViewController.m
//  QuizzingBricks
//
//  Created by Linus Hedenberg on 2013-09-22.
//  Copyright (c) 2013 Linus Hedenberg. All rights reserved.
//

#import "QBGameViewController.h"
#import "QBBoardView.h"

@interface QBGameViewController ()

@end

@implementation QBGameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSInteger numberOfCells = 20;
    NSInteger size = numberOfCells*50;
    
    QBBoardView *gameView = [[QBBoardView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x+10, self.view.bounds.origin.y+10, size, size)];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y+100, self.view.bounds.size.width, self.view.bounds.size.height-100)];
    [scrollView setContentSize:CGSizeMake(size+20, size+20)];
    [scrollView addSubview:gameView];
    scrollView.minimumZoomScale=0.3;
    scrollView.maximumZoomScale=1.0;
    [self.view addSubview:scrollView];
    [self.view setNeedsDisplay];
    [scrollView setDelegate:self];
    [self setGameView:gameView];
    
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return [self gameView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
