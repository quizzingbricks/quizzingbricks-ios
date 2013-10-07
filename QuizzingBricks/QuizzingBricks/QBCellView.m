//
//  QBCellView.m
//  QuizzingBricks
//
//  Created by Linus Hedenberg on 2013-10-07.
//  Copyright (c) 2013 Linus Hedenberg. All rights reserved.
//

#import "QBCellView.h"

@implementation QBCellView
{
    int _row;
    int _column;
    int _state; // Should be changed to board and state should be asked from board.. biatch.
    UIImageView *_imageView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame column:(NSInteger)column row:(NSInteger)row
{
    self = [super initWithFrame:frame];
    if (self) {
        _row = (int)row;
        _column = (int)column;
        _state = 0;
        
        //float x_cord = 5+column*50;
        //float y_cord = 5+row*50;
        
        //CGRect rectangle = CGRectMake(x_cord, y_cord, 40, 40);
        //[self drawRect:rectangle];
        UIImage* cellImage;
        if (_state == 0) {
            cellImage = [UIImage imageNamed: @"BoardCellEmpty"];
        } else if (_state == 1) {
            cellImage = [UIImage imageNamed: @"BoardCellGreen"];
        } else {
            cellImage = [UIImage imageNamed: @"BoardCellBlue"];
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
    _state++;
    if (_state > 2) {
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
        cellImage = [UIImage imageNamed: @"BoardCellGreen"];
    } else {
        cellImage = [UIImage imageNamed: @"BoardCellBlue"];
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
