//
//  QBFriendsViewController.h
//  QuizzingBricks
//
//  Created by Linus Hedenberg on 2013-11-14.
//  Copyright (c) 2013 Linus Hedenberg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QBCommunicationManager.h"

@interface QBFriendsViewController : UITableViewController <QBFriendsComDelegate>

@property (strong, nonatomic) NSArray *friends;

@end
