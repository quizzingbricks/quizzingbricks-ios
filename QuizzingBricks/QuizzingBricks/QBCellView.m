//
//  QBCellView.m
//  QuizzingBricks
//
//  Created by Linus Hedenberg on 2013-10-07.
//  Copyright (c) 2013 Linus Hedenberg. All rights reserved.
//

#import "QBCellView.h"

@implementation QBCellView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame column:(NSInteger)column row:(NSInteger)row delegate:(id)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        self.cellDelegate = delegate;
        _row = (int)row;
        _column = (int)column;
        _state = 0;
        
        UIImage* cellImage;
        if (_state == 0) {
            cellImage = [UIImage imageNamed: @"BoardCellEmpty"];
        } else if (_state == 1) {
            cellImage = [UIImage imageNamed: @"BoardCellGreen"];
        } else if (_state == 2) {
            cellImage = [UIImage imageNamed: @"BoardCellBlue"];
        } else if (_state == 3) {
            cellImage = [UIImage imageNamed: @"BoardCellRed"];
        } else {
            cellImage = [UIImage imageNamed: @"BoardCellYellow"];
        }
        _imageView = [[UIImageView alloc] initWithImage: cellImage];
        [self addSubview:_imageView];
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                                 initWithTarget:self action:@selector(cellTapped:)];
        [self addGestureRecognizer:tapRecognizer];
    }
    return self;
}

- (void)cellTapped:(UITapGestureRecognizer*)recognizer
{
    
    NSLog(@"Row: %d, Cell: %d", _row, _column);
    [self.cellDelegate pressAtColumn:_column row:_row];
}

- (void)updateWithState:(NSInteger)state
{
    //_state++;
    _state = state;
    if (_state > 4) {
        _state = 0;
    }
    [self update];
}

- (void)update
{
    UIImage* cellImage;
    if (_state == 0) {
        cellImage = [UIImage imageNamed: @"BoardCellEmpty"];
    } else if (_state == 1) {
        cellImage = [UIImage imageNamed: @"BoardCellYellow"];
    } else if (_state == 2) {
        cellImage = [UIImage imageNamed: @"BoardCellRed"];
    } else if (_state == 3) {
        cellImage = [UIImage imageNamed: @"BoardCellGreen"];
    } else if (_state == 4) {
        cellImage = [UIImage imageNamed: @"BoardCellBlue"];
    } else if (_state == 5) {
        cellImage = [UIImage imageNamed: @"BoardCellYellowPending"];
    } else if (_state == 6) {
        cellImage = [UIImage imageNamed: @"BoardCellRedPending"];
    } else if (_state == 7) {
        cellImage = [UIImage imageNamed: @"BoardCellGreenPending"];
    } else if (_state == 8) {
        cellImage = [UIImage imageNamed: @"BoardCellBluePending"];
    }
    _imageView = [[UIImageView alloc] initWithImage: cellImage];
    [self addSubview:_imageView];
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
