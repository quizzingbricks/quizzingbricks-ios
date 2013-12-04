//
//  QBGameViewController.h
//  QuizzingBricks
//
//  Created by Linus Hedenberg on 2013-09-22.
//  Copyright (c) 2013 Linus Hedenberg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QBCommunicationManager.h"
#import "QBQuestionViewController.h"
#import "QBCellView.h"

@class QBBoardView;
@class QBGame;

@interface QBGameViewController : UIViewController <UIScrollViewDelegate, QBGameComDelegate, QBPlayDelegate, QBQuestionDelegate, QBCellDelegate, QBAnswerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) QBBoardView *gameView;
@property (strong, nonatomic) NSString *gameID;
@property (strong, nonatomic) QBGame *game;

//@property (weak, nonatomic) IBOutlet UIScrollView *gameScrollView;

- (IBAction)cancel:(UIStoryboardSegue *)segue;

@end
