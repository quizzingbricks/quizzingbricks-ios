//
//  QBGameViewController.h
//  QuizzingBricks
//
//  Created by Linus Hedenberg on 2013-09-22.
//  Copyright (c) 2013 Linus Hedenberg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QBBoardView;

@interface QBGameViewController : UIViewController <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) QBBoardView *gameView;
//@property (weak, nonatomic) IBOutlet UIScrollView *gameScrollView;

@end
