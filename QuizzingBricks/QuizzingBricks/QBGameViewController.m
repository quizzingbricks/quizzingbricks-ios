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
#import "QBGamer.h"
#import "QBQuestion.h"

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
    
    [(UILabel *)[self.view viewWithTag:101] setHidden:YES];
    [(UILabel *)[self.view viewWithTag:102] setHidden:YES];
    [(UILabel *)[self.view viewWithTag:103] setHidden:YES];
    [(UIImageView *)[self.view viewWithTag:110] setHidden:YES];
    [(UILabel *)[self.view viewWithTag:201] setHidden:YES];
    [(UILabel *)[self.view viewWithTag:202] setHidden:YES];
    [(UILabel *)[self.view viewWithTag:203] setHidden:YES];
    [(UIImageView *)[self.view viewWithTag:210] setHidden:YES];
    [(UILabel *)[self.view viewWithTag:301] setHidden:YES];
    [(UILabel *)[self.view viewWithTag:302] setHidden:YES];
    [(UILabel *)[self.view viewWithTag:303] setHidden:YES];
    [(UIImageView *)[self.view viewWithTag:310] setHidden:YES];
    [(UILabel *)[self.view viewWithTag:401] setHidden:YES];
    [(UILabel *)[self.view viewWithTag:402] setHidden:YES];
    [(UILabel *)[self.view viewWithTag:403] setHidden:YES];
    [(UIImageView *)[self.view viewWithTag:410] setHidden:YES];
    [self.view setNeedsDisplay];
    
    self.title = @"QuizzingBricks";
    
    QBBoardView *gameView = [[QBBoardView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x+10, self.view.bounds.origin.y+60, size+20, size+120) delegate:self];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y+100, self.view.bounds.size.width, self.view.bounds.size.height-0)];
    [scrollView setContentSize:CGSizeMake(size+20, size+120)];
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
    
    [self fetchGame];
}

- (void)answer:(NSInteger)answer
{
    NSLog(@"gameview received answer: %d", (int)answer);
    
    QBDataManager *dm = [QBDataManager sharedManager];
    QBCommunicationManager *cm = [[QBCommunicationManager alloc] init];
    cm.questionDelegate = self;
    [cm sendAnswerWithToken:dm.token gameId:self.gameID answer:answer];
    
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
    // Not used
}

- (void)getGamesFailed
{
    // Not used
}

- (void)game:(QBGame *)g
{
    NSLog(@"Gameview received game!");
    self.game = g;
    // UPDATE BOARD
    for (int i = 0; i<self.game.board.count; i++) {
        //NSLog(@"board i:%d %d", i, [[self.game.board objectAtIndex:i] intValue]);
        //NSLog(@"%@ %@ %@ %@",self.game.yellowColor,self.game.redColor,self.game.greenColor,self.game.blueColor);
        if ([[self.game.board objectAtIndex:i] intValue] != 0) {
            if ([[self.game.board objectAtIndex:i] intValue] == [self.game.yellowColor.userID intValue]) {
                dispatch_async(dispatch_get_main_queue(),
                               ^{
                                   [[self.gameView.board objectAtIndex:i] setState:1];
                                   [[self.gameView.board objectAtIndex:i] update];
                               });
            } else if ([[self.game.board objectAtIndex:i] intValue] == [self.game.redColor.userID intValue]) {
                dispatch_async(dispatch_get_main_queue(),
                               ^{
                                   [[self.gameView.board objectAtIndex:i] setState:2];
                                   [[self.gameView.board objectAtIndex:i] update];
                               });
            } else if ([[self.game.board objectAtIndex:i] intValue] == [self.game.greenColor.userID intValue]) {
                dispatch_async(dispatch_get_main_queue(),
                               ^{
                                   [[self.gameView.board objectAtIndex:i] setState:3];
                                   [[self.gameView.board objectAtIndex:i] update];
                               });
            } else if ([[self.game.board objectAtIndex:i] intValue] == [self.game.blueColor.userID intValue]) {
                dispatch_async(dispatch_get_main_queue(),
                               ^{
                                   [[self.gameView.board objectAtIndex:i] setState:4];
                                   [[self.gameView.board objectAtIndex:i] update];
                               });
            }
        }
    }
    
    QBDataManager *dm = [QBDataManager sharedManager];
    
    QBGamer *me = nil;
    
    if (self.game.yellowColor != nil) {
        if ([dm.u_id intValue] == [self.game.yellowColor.userID intValue]) {
            me = self.game.yellowColor;
        }
        dispatch_async(dispatch_get_main_queue(),
                       ^{
                           
                           UILabel *status = (UILabel *)[self.view viewWithTag:101];
                           [status setText:[NSString stringWithFormat:@"%d",(int)self.game.yellowColor.state]];
                           UILabel *score = (UILabel *)[self.view viewWithTag:102];
                           [score setText:[NSString stringWithFormat:@"%d",(int)self.game.yellowColor.score]];
                           UILabel *email = (UILabel *)[self.view viewWithTag:103];
                           [email setText:[NSString stringWithFormat:@"%@@notvalid.email",self.game.yellowColor.userID]];
                           
                           [status setHidden:NO];
                           [score setHidden:NO];
                           [email setHidden:NO];
                           UIImageView *image = (UIImageView *)[self.view viewWithTag:110];
                           [image setHidden:NO];
                           
                           [self.view setNeedsDisplay];
                       });
    }
    if (self.game.redColor != nil) {
        if ([dm.u_id intValue] == [self.game.redColor.userID intValue]) {
            me = self.game.redColor;
        }
        dispatch_async(dispatch_get_main_queue(),
                       ^{
                           
                           UILabel *status = (UILabel *)[self.view viewWithTag:201];
                           [status setText:[NSString stringWithFormat:@"%d",(int)self.game.redColor.state]];
                           UILabel *score = (UILabel *)[self.view viewWithTag:202];
                           [score setText:[NSString stringWithFormat:@"%d",(int)self.game.redColor.score]];
                           UILabel *email = (UILabel *)[self.view viewWithTag:203];
                           [email setText:[NSString stringWithFormat:@"%@@notvalid.email",self.game.redColor.userID]];
                           
                           [status setHidden:NO];
                           [score setHidden:NO];
                           [email setHidden:NO];
                           UIImageView *image = (UIImageView *)[self.view viewWithTag:210];
                           [image setHidden:NO];
                           
                           [self.view setNeedsDisplay];
                       });
    }
    if (self.game.greenColor != nil) {
        if ([dm.u_id intValue] == [self.game.greenColor.userID intValue]) {
            me = self.game.greenColor;
        }
        dispatch_async(dispatch_get_main_queue(),
                       ^{
                           UILabel *status = (UILabel *)[self.view viewWithTag:301];
                           [status setText:[NSString stringWithFormat:@"%d",(int)self.game.greenColor.state]];
                           UILabel *score = (UILabel *)[self.view viewWithTag:302];
                           [score setText:[NSString stringWithFormat:@"%d",(int)self.game.greenColor.score]];
                           UILabel *email = (UILabel *)[self.view viewWithTag:303];
                           [email setText:[NSString stringWithFormat:@"%@@notvalid.email",self.game.greenColor.userID]];
                           
                           [status setHidden:NO];
                           [score setHidden:NO];
                           [email setHidden:NO];
                           UIImageView *image = (UIImageView *)[self.view viewWithTag:310];
                           [image setHidden:NO];
                           
                           [self.view setNeedsDisplay];
                       });
    }
    if (self.game.blueColor != nil) {
        if ([dm.u_id intValue] == [self.game.blueColor.userID intValue]) {
            me = self.game.blueColor;
        }
        dispatch_async(dispatch_get_main_queue(),
                       ^{
                           UILabel *status = (UILabel *)[self.view viewWithTag:401];
                           [status setText:[NSString stringWithFormat:@"%d",(int)self.game.blueColor.state]];
                           UILabel *score = (UILabel *)[self.view viewWithTag:402];
                           [score setText:[NSString stringWithFormat:@"%d",(int)self.game.blueColor.score]];
                           UILabel *email = (UILabel *)[self.view viewWithTag:403];
                           [email setText:[NSString stringWithFormat:@"%@@notvalid.email",self.game.blueColor.userID]];
                           
                           [status setHidden:NO];
                           [score setHidden:NO];
                           [email setHidden:NO];
                           UIImageView *image = (UIImageView *)[self.view viewWithTag:410];
                           [image setHidden:NO];
                           
                           [self.view setNeedsDisplay];
                       });
    }
    dispatch_async(dispatch_get_main_queue(),
                   ^{
                       if (me.state == 0) {
                           self.title = @"Place Brick!";
                       } else if (me.state == 1) {
                           self.title = @"Deadlock due to debug!";
                       } else if (me.state == 2) {
                           self.title = @"Shouldn't happen!";
                       } else if (me.state == 3) {
                           self.title = @"Waiting for other player";
                       }
                   });
    
}

- (void)getGameFailed
{
    NSLog(@"Get Game Failed");
}

- (void)playMoveSucceded
{
    // Not used
    NSLog(@"playMoveSucceded");
    
    QBDataManager *dm = [QBDataManager sharedManager];
    QBCommunicationManager *cm = [[QBCommunicationManager alloc] init];
    cm.questionDelegate = self;
    [cm getQuestionWithToken:dm.token gameId:self.gameID];
}

- (void)playMoveFailed
{
    // Not used
    NSLog(@"playMoveFailed");
}

- (void)receivedQuestion:(QBQuestion *)question
{
    // Not used
    NSLog(@"receivedQuestion");
    dispatch_async(dispatch_get_main_queue(),
        ^{
            UINavigationController *nc = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"QuestionNav"];
            nc.modalPresentationStyle = UIModalPresentationFullScreen;
            nc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            QBQuestionViewController *vc = nc.viewControllers[0];
            vc.question = question;
            vc.delegate = self;
            [self presentViewController:nc animated:YES completion:Nil];
        });
}

- (void)questionFailed
{
    // Not used
    NSLog(@"questionFailed");
}

- (void)answerSucceded
{
    // Not used
    NSLog(@"answerSucceded");
}

- (void)answerFailed
{
    // Not used
    NSLog(@"answerFailed");
}


- (void) pressAtColumn:(NSInteger)column row:(NSInteger)row
{
    NSLog(@"Press at column %ld row %ld", (long)column, (long)row);
    //NSInteger index = row*8+column;
    
    QBDataManager *dm = [QBDataManager sharedManager];
    QBCommunicationManager *cm = [[QBCommunicationManager alloc] init];
    cm.playDelegate = self;
    [cm playMoveWithToken:dm.token gameID:self.gameID xCoord:column yCoord:row];
    
    //[[self.gameView.board objectAtIndex:index] updateWithState:2];
}

- (IBAction)cancel:(UIStoryboardSegue *)segue
{
    //[self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"question to game cancel");
    if ([[segue identifier] isEqualToString:@"CancelQuestion"]) {
        //[self dismissViewControllerAnimated: YES completion:NULL];
        NSLog(@"CancelQuestion");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
