//
//  QBCellView.h
//  QuizzingBricks
//
//  Created by Linus Hedenberg on 2013-10-07.
//  Copyright (c) 2013 Linus Hedenberg. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QBCellDelegate <NSObject>

- (void) pressAtColumn:(NSInteger)column row:(NSInteger)row;

@end

@interface QBCellView : UIView

{
    // private variables
    int _row;
    int _column;
    UIImageView *_imageView;
    id <QBCellDelegate> _cellDelegate;
}

- (id) initWithFrame:(CGRect)frame column:(NSInteger)column row:(NSInteger)row delegate:(id)delegate;
- (void)updateWithState:(NSInteger)state;

@property (nonatomic) NSInteger state;
@property (strong,nonatomic) id cellDelegate;

@end