//
//  QBQuestionViewController.h
//  QuizzingBricks
//
//  Created by Linus Hedenberg on 2013-12-03.
//  Copyright (c) 2013 Linus Hedenberg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QBQuestion;

@protocol QBAnswerDelegate <NSObject>

- (void)answer:(NSInteger)answer;

@end

@interface QBQuestionViewController : UITableViewController

@property (strong, nonatomic) QBQuestion *question;
@property (nonatomic) NSInteger answer;
@property (strong, nonatomic) id <QBAnswerDelegate> delegate;

@end
