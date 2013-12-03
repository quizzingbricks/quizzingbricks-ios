//
//  QBGameViewController.m
//  QuizzingBricks
//
//  Created by Linus Hedenberg on 2013-09-22.
//  Copyright (c) 2013 Linus Hedenberg. All rights reserved.
//

#import "QBGameViewController.h"
#import "QBQuestionViewController.h"
#import "QBDataManager.h"
#import "QBCommunicationManager.h"
#import "QBBoardView.h"
#import "QBGame.h"

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
    
    NSInteger numberOfCells = 8;
    NSInteger size = numberOfCells*50;
    
    QBBoardView *gameView = [[QBBoardView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x+10, self.view.bounds.origin.y+10, size, size) delegate:self];
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

- (void)fetchGame
{
    QBDataManager *dm = [QBDataManager sharedManager];
    QBCommunicationManager *cm = [[QBCommunicationManager alloc] init];
    cm.gameDelegate = self;
    [cm getGameWithToken:dm.token gameId:self.gameID];
}

- (void)games:(NSArray *)gameList
{
    
}

- (void)getGamesFailed
{
    
}

- (void)game:(QBGame *)g
{
    NSLog(@"Gameview received game!");
    self.game = g;
    // UPDATE BOARD
    for (NSNumber *n in self.game.board) {
        //NSLog(@"n: ",n);
    }
}

- (void)getGameFailed
{
    NSLog(@"Get Game Failed");
}

- (void)playMoveSucceded
{
    // Not used
    NSLog(@"playMoveSucceded");
}

- (void)playMoveFailed
{
    // Not used
    NSLog(@"playMoveFailed");
}

- (void) pressAtColumn:(NSInteger)column row:(NSInteger)row
{
    NSLog(@"Press at column %ld row %ld", (long)column, (long)row);
    //NSInteger index = row*8+column;
    
    //QBDataManager *dm = [QBDataManager sharedManager];
    //QBCommunicationManager *cm = [[QBCommunicationManager alloc] init];
    //cm.playDelegate = self;
    //[cm playMoveWithToken:dm.token gameID:self.gameID xCoord:column yCoord:row];
    
    
    QBQuestionViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"QuestionNav"];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:vc animated:YES completion:Nil];
    
    //[[self.gameView.board objectAtIndex:index] updateWithState:2];
}

- (IBAction)cancel:(UIStoryboardSegue *)segue
{
    //[self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"question to game cancel");
    /*if ([[segue identifier] isEqualToString:@"CancelCreate"]) {
        [self dismissViewControllerAnimated: YES completion:NULL];
        NSLog(@"cancelCreateDismiss");
    }*/
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
