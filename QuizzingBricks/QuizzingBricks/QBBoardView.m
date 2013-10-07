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

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        for (int x = 0; x < 9; x++) {
            for (int y = 0; y < 9; y++) {
                float x_cord = x*50;
                float y_cord = y*50;
                QBCellView *cell = [[QBCellView alloc] initWithFrame:CGRectMake(x_cord, y_cord, 50, 50) column:x row:y];
                [self addSubview:cell];
            }
        }
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
