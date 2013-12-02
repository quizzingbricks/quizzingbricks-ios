//
//  QBBoardView.m
//  QuizzingBricks
//
//  Created by Linus Hedenberg on 2013-10-07.
//  Copyright (c) 2013 Linus Hedenberg. All rights reserved.
//

#import "QBBoardView.h"
#import "QBCellView.h"

@implementation QBBoardView

- (id)initWithFrame:(CGRect)frame delegate:(id)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSMutableArray *mutableBoard = [[NSMutableArray alloc] init];
        for (int y = 0; y < 8; y++) {
            for (int x = 0; x < 8; x++) {
                float x_cord = x*50;
                float y_cord = y*50;
                QBCellView *cell = [[QBCellView alloc] initWithFrame:CGRectMake(x_cord, y_cord, 50, 50) column:x row:y delegate:delegate];
                [self addSubview:cell];
                [mutableBoard addObject:cell];
            }
        }
        self.board = mutableBoard;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
