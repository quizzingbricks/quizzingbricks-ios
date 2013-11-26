//
//  QBCommunicationManager.m
//  QuizzingBricks
//
//  Created by Linus Hedenberg on 2013-11-05.
//  Copyright (c) 2013 Linus Hedenberg. All rights reserved.
//

#import "QBCommunicationManager.h"
#import "QBLobby.h"
#import "QBGame.h"
#import "QBPlayer.h"
#import "QBFriend.h"

@implementation QBCommunicationManager

//192.168.2.6
NSString *const API_URL = @"130.240.233.81:8000";

#pragma mark - General request handling methods

- (NSMutableURLRequest *)createRequestWithPost:(NSString *)post endpoint:(NSString *)endpoint token:(NSString *)token
{
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", (int)[postData length]];
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://%@%@", API_URL, endpoint]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    if (token) {
        [request addValue:token forHTTPHeaderField:@"token"];
    }
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    return request;
}

- (NSMutableURLRequest *)createRequestWithEndpoint:(NSString *)endpoint token:(NSString *)token
{
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://%@%@", API_URL, endpoint]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    if (token) {
        NSLog(@"token: %@", token);
        [request addValue:token forHTTPHeaderField:@"token"];
    }
    [request setURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    return request;
}

#pragma mark - Login

- (void)registerWithEmail:(NSString *)email password:(NSString *)password
{
    NSString *post = [NSString stringWithFormat:@"email=%@&password=%@", email, password];
    NSMutableURLRequest *request = [self createRequestWithPost:post endpoint:@"/api/users/" token:nil];
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            [self registerFailedWithError:error];
        } else {
            [self receivedRegisterJSON:data];
        }
    }];
}

- (void)receivedRegisterJSON:(NSData *)objectNotation
{
    NSError *localError = nil;
    if (objectNotation != nil) {
        NSLog(@"Not nil");
    } else {
        NSLog(@"nil");
    }
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];
    if (parsedObject != nil) {
        if (localError != nil) {
            [self registerFailedWithError:localError];
            NSLog(@"error registring");
        } else  {
            if ([[parsedObject allKeys] containsObject:@"errors"]) {
                NSLog(@"errors:%@", [parsedObject objectForKey:@"errors"]);
                [self registerFailedWithError:localError];
            } else {
                //NSLog(@"receivedToken:%@", [parsedObject objectForKey:@"token"]);
                [self.registerDelegate registerSuccess];
            }
        }
    } else {
        NSLog(@"Parsed nil not error");
        [self.registerDelegate registerSuccess];
    }
}

- (void)registerFailedWithError:(NSError *)error
{
    NSLog(@"failed with error: %@",error);
    [self.loginDelegate loginFailed];
}


#pragma mark - Login

- (void)loginWithEmail:(NSString *)email password:(NSString *)password
{
    NSString *post = [NSString stringWithFormat:@"email=%@&password=%@", email, password];
    NSMutableURLRequest *request = [self createRequestWithPost:post endpoint:@"/api/users/login/" token:nil];
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            [self loginFailedWithError:error];
        } else {
            [self receivedLoginJSON:data];
        }
    }];
}

- (void)receivedLoginJSON:(NSData *)objectNotation
{
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];
    if (localError != nil) {
        [self loginFailedWithError:localError];
        NSLog(@"error wtf");
    } else {
        if ([[parsedObject allKeys] containsObject:@"errors"]) {
            NSLog(@"errors:%@", [parsedObject objectForKey:@"errors"]);
            [self loginFailedWithError:localError];
        } else {
            NSLog(@"receivedToken:%@", [parsedObject objectForKey:@"token"]);
            [self.loginDelegate loginToken:[parsedObject objectForKey:@"token"]];
        }
    }
}

- (void)loginFailedWithError:(NSError *)error
{
    NSLog(@"failed with error: %@",error);
    [self.loginDelegate loginFailed];
}

#pragma mark - Friends

- (void)getFriendsWithToken:(NSString *)token
{
    NSLog(@"getFriends");
    NSMutableURLRequest *request = [self createRequestWithEndpoint:@"/api/users/me/friends/" token:token];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            [self getFriendsFailedWithError:error];
        } else {
            [self receivedFriendsJSON:data];
        }
    }];
}

- (void)receivedFriendsJSON:(NSData *)objectNotation
{
    NSLog(@"friendsReceived");
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];
    if (localError != nil) {
        [self getFriendsFailedWithError:localError];
    } else {
        if ([[parsedObject allKeys] containsObject:@"errors"]) {
            [self.friendsDelegate getFriendsFailed];
        } else {
            NSMutableArray *friends = [[NSMutableArray alloc] init];
            for (NSDictionary *friendJSON in [parsedObject objectForKey:@"friends"]) {
                
                QBFriend *f = [[QBFriend alloc] initWithUserID:[friendJSON objectForKey:@"u_id"] email:[friendJSON objectForKey:@"email"]];
                [friends addObject:f];
            }
            NSLog(@"friends assembled");
            [self.friendsDelegate returnFriends:friends];
        }
    }
}

- (void)getFriendsFailedWithError:(NSError *)error
{
    [self.friendsDelegate getFriendsFailed];
}

- (void)addFriendWithToken:(NSString *)token email:(NSString *)email
{
    NSLog(@"addFriend");
    NSString *post = [NSString stringWithFormat:@"friend=%@", email];
    NSMutableURLRequest *request = [self createRequestWithPost:post endpoint:@"/api/users/me/friends/" token:token];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            [self addFriendFailedWithError:error];
        } else {
            [self receivedFriendsJSON:data];
        }
    }];
}

- (void)addFriendFailedWithError:(NSError *)error
{
    NSLog(@"addfriend failed");
    [self.friendsDelegate getFriendsFailed];
}

#pragma mark - Lobbies

- (void)getLobbiesWithToken:(NSString *)token
{
    NSLog(@"getLobbies");
    NSMutableURLRequest *request = [self createRequestWithEndpoint:@"/api/game/lobby/" token:token];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            [self lobbiesFailedWithError:error];
        } else {
            [self receivedLobbiesJSON:data];
        }
    }];
}

- (void)receivedLobbiesJSON:(NSData *)objectNotation
{
    NSLog(@"lobbiesreceived");
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];
    if (localError != nil) {
        [self lobbiesFailedWithError:localError];
    } else {
        NSArray *ls = [parsedObject objectForKey:@"lobbies"];
        NSMutableArray *lobbies = [[NSMutableArray alloc] init];
        for (NSDictionary *l_id in ls) {
            [lobbies addObject:[l_id objectForKey:@"l_id"]];
        }
        [self.lobbyDelegate lobbies:lobbies];
    }
}

- (void)lobbiesFailedWithError:(NSError *)error
{
    [self.lobbyDelegate getLobbiesFailed];
}

#pragma mark - Lobby

- (void)getLobbyWithToken:(NSString *)token lobbyId:(NSString *)l_id
{
    NSLog(@"getLobby");
    NSMutableURLRequest *request = [self createRequestWithEndpoint:[NSString stringWithFormat:@"/api/game/lobby/%@/", l_id] token:token];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            [self getLobbyFailedWithError:error];
        } else {
            [self receivedLobbyJSON:data];
        }
    }];
}

- (void)receivedLobbyJSON:(NSData *)objectNotation
{
    NSLog(@"lobbyReceived here");
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];
    if (localError != nil) {
        [self getLobbyFailedWithError:localError];
    } else {
        NSLog(@"lobbyRecieved: %@", [parsedObject objectForKey:@"l_id"]);
        NSInteger lobbySize = [[parsedObject objectForKey:@"size"] integerValue];
        BOOL isOwner = [[parsedObject objectForKey:@"owner"] boolValue];
        NSArray *jsonPlayers = [parsedObject objectForKey:@"players"];
        NSMutableArray *players = [[NSMutableArray alloc] init];
        for (NSDictionary *jsonPlayer in jsonPlayers) {
            NSString *statusString = [jsonPlayer objectForKey:@"status"];
            if ([[jsonPlayer objectForKey:@"status"] isEqualToString:@"accepted"]) {
                statusString = @"accepted";
            } else if ([[jsonPlayer objectForKey:@"status"] isEqualToString:@"waiting"]) {
                statusString = @"waiting";
            }
            QBPlayer *player = [[QBPlayer alloc] initWithUserID:[jsonPlayer objectForKey:@"u_id"] email:[jsonPlayer objectForKey:@"u_mail"] status:statusString];
            [players addObject:player];
        }
        QBLobby *lobby = [[QBLobby alloc] initWithSize:lobbySize isOwner:isOwner players:players];
        [self.lobbyDelegate lobby:lobby];
    }
}

- (void)getLobbyFailedWithError:(NSError *)error
{
    [self.lobbyDelegate getLobbyFailed];
}

#pragma mark - Create lobby

- (void)createLobbyWithToken:(NSString *)token size:(int)size
{
    NSLog(@"createLobby");
    NSString *post = [NSString stringWithFormat:@"size=%d", size];
    NSMutableURLRequest *request = [self createRequestWithPost:post endpoint:@"/api/game/lobby/create/" token:token];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            [self createLobbyFailedWithError:error];
        } else {
            [self receivedCreatedLobbyJSON:data];
        }
    }];
}

- (void)receivedCreatedLobbyJSON:(NSData *)objectNotation
{
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];
    if (localError != nil) {
        [self createLobbyFailedWithError:localError];
        NSLog(@"error creating lobby");
    } else {
        NSLog(@"createdLobbyID:%@", [parsedObject objectForKey:@"l_id"]);
        NSInteger lobbySize = [[parsedObject objectForKey:@"size"] integerValue];
        BOOL isOwner = [[parsedObject objectForKey:@"owner"] boolValue];
        NSArray *jsonPlayers = [parsedObject objectForKey:@"players"];
        NSMutableArray *players = [[NSMutableArray alloc] init];
        for (NSDictionary *jsonPlayer in jsonPlayers) {
            NSString *statusString = [jsonPlayer objectForKey:@"status"];
            if ([[jsonPlayer objectForKey:@"status"] isEqualToString:@"accepted"]) {
                statusString = @"accepted";
            } else if ([[jsonPlayer objectForKey:@"status"] isEqualToString:@"waiting"]) {
                statusString = @"waiting";
            }
            QBPlayer *player = [[QBPlayer alloc] initWithUserID:[jsonPlayer objectForKey:@"u_id"] email:[jsonPlayer objectForKey:@"u_mail"] status:statusString];
            [players addObject:player];
        }
        QBLobby *lobby = [[QBLobby alloc] initWithSize:lobbySize isOwner:isOwner players:players];
        [self.lobbyDelegate createdLobby:lobby];
    }
}

- (void)createLobbyFailedWithError:(NSError *)error
{
    [self.lobbyDelegate createLobbyFailed];
}

#pragma mark - Games

- (void)getGamesWithToken:(NSString *)token{
    NSLog(@"getGames");
    NSMutableURLRequest *request = [self createRequestWithEndpoint:@"/api/users/me/activegames/" token:token];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            [self gamesFailedWithError:error];
        } else {
            [self receivedGamesJSON:data];
        }
    }];
}

- (void)receivedGamesJSON:(NSData *)objectNotation
{
    NSLog(@"gamesReceived");
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];
    if (localError != nil) {
        [self gamesFailedWithError:localError];
    } else {
        NSArray *gs = [parsedObject objectForKey:@"games"];
        NSMutableArray *games = [[NSMutableArray alloc] init];
        for (NSDictionary *g in gs) {
            NSString *g_id = [g objectForKey:@"g_id"];
            NSLog(@"gID: %@", g_id);
            NSInteger size = [[g objectForKey:@"size"] integerValue];
            NSLog(@"size: %ld", (long)size);
            NSString *status = [g objectForKey:@"status"];
            NSLog(@"status: %@", g_id);
            [games addObject:[[QBGame alloc] initWithSize:size gameID:g_id status:status]];
        }
        [self.gameDelegate games:games];
    }
}

- (void)gamesFailedWithError:(NSError *)error
{
    [self.gameDelegate getGamesFailed];
}

#pragma mark - Game

- (void)getGameWithToken:(NSString *)token gameId:(NSString *)g_id{
    NSLog(@"getGame");
    NSMutableURLRequest *request = [self createRequestWithEndpoint:@"/api/game/%@/" token:token];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            [self getGameFailedWithError:error];
        } else {
            [self receivedGameJSON:data];
        }
    }];
}

- (void)receivedGameJSON:(NSData *)objectNotation
{
    NSLog(@"gameReceived");
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];
    if (localError != nil) {
        [self getGameFailedWithError:localError];
    } else {
        NSInteger gameSize = [[parsedObject objectForKey:@"size"] integerValue];
        NSString *gameStatus = [[parsedObject objectForKey:@"status"] stringValue];
        NSArray *jsonPlayers = [parsedObject objectForKey:@"players"];
        NSMutableArray *players = [[NSMutableArray alloc] init];
        for (NSDictionary *jsonPlayer in jsonPlayers) {
            QBPlayer *player = [[QBPlayer alloc] initWithUserID:[jsonPlayer objectForKey:@"u_id"] email:[jsonPlayer objectForKey:@"u_mail"]];
            [players addObject:player];
        }
        //QBLobby *lobby = [[QBLobby alloc] initWithSize:lobbySize isOwner:isOwner players:players];
        QBGame *game = [[QBGame alloc] initWithSize:gameSize status:gameStatus players:players];
        [self.gameDelegate game:game];
    }
}

- (void)getGameFailedWithError:(NSError *)error
{
    [self.gameDelegate getGameFailed];
}



@end
