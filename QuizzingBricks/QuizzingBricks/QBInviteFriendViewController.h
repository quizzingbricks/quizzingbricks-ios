//
//  QBInviteFriendViewController.h
//  QuizzingBricks
//
//  Created by Linus Hedenberg on 2013-11-18.
//  Copyright (c) 2013 Linus Hedenberg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QBCommunicationManager.h"

@interface QBInviteFriendViewController : UITableViewController <QBFriendsComDelegate>

@property (strong, nonatomic) NSArray *friends;
@property (strong, nonatomic) NSArray *inLobby;
@property (strong, nonatomic) NSMutableArray *invitation;

@end
