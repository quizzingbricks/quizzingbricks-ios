//
//  QBBoardView.h
//  QuizzingBricks
//
//  Created by Linus Hedenberg on 2013-10-07.
//  Copyright (c) 2013 Linus Hedenberg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QBBoardView : UIView

@property (strong, nonatomic) NSArray *board;

- (id)initWithFrame:(CGRect)frame delegate:(id)delegate;

@end
