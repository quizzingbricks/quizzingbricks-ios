//
//  QBLobbyViewController.h
//  QuizzingBricks
//
//  Created by Linus Hedenberg on 2013-11-12.
//  Copyright (c) 2013 Linus Hedenberg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QBCommunicationManager.h"

@class QBLobby;

@interface QBLobbyViewController : UITableViewController <QBLobbyComDelegate>

@property (strong, nonatomic) QBLobby *lobby;
@property (strong, nonatomic) NSString *lobbyID;
@property (nonatomic) BOOL isOwner;

- (IBAction)reloadLobby:(id)sender;

@end
