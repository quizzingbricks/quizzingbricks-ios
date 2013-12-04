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
#import "QBGamer.h"
#import "QBPlayer.h"
#import "QBFriend.h"
#import "QBQuestion.h"

@implementation QBCommunicationManager

//192.168.2.6
NSString *const API_URL = @"130.240.233.81:8000";

#pragma mark - General request handling methods

- (NSMutableURLRequest *)createRequestWithPost:(NSString *)post endpoint:(NSString *)endpoint token:(NSString *)token
{
    NSLog(@"RequestWithPost at %@: %@", endpoint, post);
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
    NSLog(@"Request at %@", endpoint);
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

- (NSMutableURLRequest *)createRequestWithJSON:(NSData *)JSON endpoint:(NSString *)endpoint token:(NSString *)token
{
    NSLog(@"RequestWithJSON at %@: %@", endpoint, JSON);
    NSString *dataLength = [NSString stringWithFormat:@"%d", (int)[JSON length]];
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://%@%@", API_URL, endpoint]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    if (token) {
        [request addValue:token forHTTPHeaderField:@"token"];
    }
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:dataLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:JSON];
    return request;
}

#pragma mark - Register

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
    NSLog(@"receivedRegisterJSON");
    NSString *dataString = [[NSString alloc] initWithData:objectNotation encoding:NSASCIIStringEncoding];
    NSLog(@"data: %@",dataString);
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
    [self.registerDelegate registerFailed];
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
    NSString *dataString = [[NSString alloc] initWithData:objectNotation encoding:NSASCIIStringEncoding];
    NSLog(@"data: %@",dataString);
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
    NSLog(@"receivedFriendsJSON");
    NSString *dataString = [[NSString alloc] initWithData:objectNotation encoding:NSASCIIStringEncoding];
    NSLog(@"data: %@",dataString);
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];
    if (localError != nil) {
        [self getFriendsFailedWithError:localError];
    } else {
        NSLog(@"receivedFriendsJSON else");
        if ([[parsedObject allKeys] containsObject:@"errors"]) {
            NSLog(@"receivedFriendsJSON else failed");
            [self.friendsDelegate getFriendsFailed];
        } else {
            NSLog(@"receivedFriendsJSON else else");
            NSLog(@"%@",parsedObject);
            NSMutableArray *friends = [[NSMutableArray alloc] init];
            for (NSDictionary *friendJSON in [parsedObject objectForKey:@"friends"]) {
                NSLog(@"receivedFriendsJSON: friend: %@",[friendJSON objectForKey:@"email"]);
                QBFriend *f = [[QBFriend alloc] initWithUserID:[friendJSON objectForKey:@"id"] email:[friendJSON objectForKey:@"email"]];
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
    NSLog(@"addFriendpost: %@",post);
    NSMutableURLRequest *request = [self createRequestWithPost:post endpoint:@"/api/users/me/friends/" token:token];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            [self addFriendFailedWithError:error];
        } else {
            [self responseAddFriend:data];
        }
    }];
}

- (void)responseAddFriend:(NSData *)objectNotation
{
    NSLog(@"responseAddFriend");
    NSString *dataString = [[NSString alloc] initWithData:objectNotation encoding:NSASCIIStringEncoding];
    NSLog(@"data: %@",dataString);
    NSError *localError = nil;
    NSString *testString = [[NSString alloc] initWithData:objectNotation encoding:NSASCIIStringEncoding];
    NSLog(@"Teststring: %@",testString);
    if ([testString isEqualToString:@"OK"]) {
        NSLog(@"responseAddFriend returned OK");
        [self.friendsDelegate addFriendSucceded];
    } else {
        NSLog(@"responseAddFriend DID NOT return OK");
        NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];
        if (localError != nil) {
            [self getFriendsFailedWithError:localError];
        } else {
            NSLog(@"responseAddFriend else");
            if ([[parsedObject allKeys] containsObject:@"errors"]) {
                NSLog(@"responseAddFriend else failed");
                [self.friendsDelegate addFriendFailed];
            } else {
                NSLog(@"responseAddFriend no errors");
            }
        }
    }
}

- (void)addFriendFailedWithError:(NSError *)error
{
    NSLog(@"addfriend failed");
    [self.friendsDelegate addFriendFailed];
}

#pragma mark - Lobbies

- (void)getLobbiesWithToken:(NSString *)token
{
    NSLog(@"getLobbies");
    NSMutableURLRequest *request = [self createRequestWithEndpoint:@"/api/games/lobby/" token:token];
    
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
    NSLog(@"receivedLobbiesJSON");
    NSString *dataString = [[NSString alloc] initWithData:objectNotation encoding:NSASCIIStringEncoding];
    NSLog(@"data: %@",dataString);
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];
    if (localError != nil) {
        [self lobbiesFailedWithError:localError];
    } else {
        NSArray *ls = [parsedObject objectForKey:@"lobbies"];
        NSMutableArray *lobbies = [[NSMutableArray alloc] init];
        for (NSDictionary *lobbyDict in ls) {
            NSLog(@"lobbyRecieved: %@", [lobbyDict objectForKey:@"l_id"]);
            NSString *lobbyID = [lobbyDict objectForKey:@"l_id"];
            NSInteger lobbySize = [[lobbyDict objectForKey:@"size"] integerValue];
            BOOL isOwner = [[lobbyDict objectForKey:@"owner"] boolValue];
            NSArray *jsonPlayers = [lobbyDict objectForKey:@"players"];
            NSMutableArray *players = [[NSMutableArray alloc] init];
            for (NSDictionary *jsonPlayer in jsonPlayers) {
                NSString *statusString = [jsonPlayer objectForKey:@"status"];
                if ([[jsonPlayer objectForKey:@"status"] isEqualToString:@"accepted"]) {
                    statusString = @"accepted";
                } else if ([[jsonPlayer objectForKey:@"status"] isEqualToString:@"waiting"]) {
                    statusString = @"waiting";
                }
                QBPlayer *player = [[QBPlayer alloc] initWithUserID:[[jsonPlayer objectForKey:@"u_id"] stringValue] email:[jsonPlayer objectForKey:@"u_mail"] status:statusString];
                [players addObject:player];
            }
            QBLobby *lobby = [[QBLobby alloc] initWithID:lobbyID size:lobbySize isOwner:isOwner players:players];
            [lobbies addObject:lobby];
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
    NSMutableURLRequest *request = [self createRequestWithEndpoint:[NSString stringWithFormat:@"/api/games/lobby/%@/", l_id] token:token];
    
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
    NSLog(@"receivedLobbyJSON");
    NSString *dataString = [[NSString alloc] initWithData:objectNotation encoding:NSASCIIStringEncoding];
    NSLog(@"data: %@",dataString);
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];
    if (localError != nil) {
        [self getLobbyFailedWithError:localError];
    } else {
        if ([[parsedObject allKeys] containsObject:@"errors"]) {
            NSLog(@"receivedLobbyJSON else failed");
            [self.lobbyDelegate getLobbyFailed];
        } else {
            NSLog(@"receivedLobbyJSON no errors");
            NSDictionary *lobbyDict = [parsedObject objectForKey:@"lobby"];
            NSLog(@"lobbyRecieved: %@", [lobbyDict objectForKey:@"l_id"]);
            NSString *lobbyID = [lobbyDict objectForKey:@"l_id"];
            NSInteger lobbySize = [[lobbyDict objectForKey:@"size"] integerValue];
            BOOL isOwner = [[lobbyDict objectForKey:@"owner"] boolValue];
            NSArray *jsonPlayers = [lobbyDict objectForKey:@"players"];
            NSMutableArray *players = [[NSMutableArray alloc] init];
            for (NSDictionary *jsonPlayer in jsonPlayers) {
                NSString *statusString = [jsonPlayer objectForKey:@"status"];
                if ([[jsonPlayer objectForKey:@"status"] isEqualToString:@"accepted"]) {
                    statusString = @"accepted";
                } else if ([[jsonPlayer objectForKey:@"status"] isEqualToString:@"waiting"]) {
                    statusString = @"waiting";
                }
                QBPlayer *player = [[QBPlayer alloc] initWithUserID:[[jsonPlayer objectForKey:@"u_id"] stringValue] email:[jsonPlayer objectForKey:@"u_mail"] status:statusString];
                [players addObject:player];
            }
            QBLobby *lobby = [[QBLobby alloc] initWithID:lobbyID size:lobbySize isOwner:isOwner players:players];
            [self.lobbyDelegate lobby:lobby];
        }
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
    NSMutableURLRequest *request = [self createRequestWithPost:post endpoint:@"/api/games/lobby/" token:token];
    
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
    NSLog(@"receivedCreatedLobbyJSON");
    NSString *dataString = [[NSString alloc] initWithData:objectNotation encoding:NSASCIIStringEncoding];
    NSLog(@"data: %@",dataString);
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];
    if (localError != nil) {
        [self createLobbyFailedWithError:localError];
        NSLog(@"error creating lobby");
    } else {
        NSDictionary *lobbyDict = [parsedObject objectForKey:@"lobby"];
        NSLog(@"createdLobbyID:%@", [lobbyDict objectForKey:@"l_id"]);
        NSString *lobbyID = [lobbyDict objectForKey:@"l_id"];
        NSInteger lobbySize = [[lobbyDict objectForKey:@"size"] integerValue];
        BOOL isOwner = [[lobbyDict objectForKey:@"owner"] boolValue];
        NSArray *jsonPlayers = [lobbyDict objectForKey:@"players"];
        NSMutableArray *players = [[NSMutableArray alloc] init];
        for (NSDictionary *jsonPlayer in jsonPlayers) {
            NSString *statusString = [jsonPlayer objectForKey:@"status"];
            if ([[jsonPlayer objectForKey:@"status"] isEqualToString:@"accepted"]) {
                statusString = @"accepted";
            } else if ([[jsonPlayer objectForKey:@"status"] isEqualToString:@"waiting"]) {
                statusString = @"waiting";
            }
            QBPlayer *player = [[QBPlayer alloc] initWithUserID:[[jsonPlayer objectForKey:@"u_id"] stringValue] email:[jsonPlayer objectForKey:@"u_mail"] status:statusString];
            [players addObject:player];
        }
        QBLobby *lobby = [[QBLobby alloc] initWithID:lobbyID size:lobbySize isOwner:isOwner players:players];
        [self.lobbyDelegate createdLobby:lobby];
    }
}

- (void)createLobbyFailedWithError:(NSError *)error
{
    [self.lobbyDelegate createLobbyFailed];
}

#pragma mark - Invite Friend to Lobby

- (void)inviteFriendWithToken:(NSString *)token lobbyID:(NSString *)l_id friendIDs:(NSArray *)f_ids
{
    NSError *localError = nil;
    NSLog(@"inviteFriendWithToken");
    NSDictionary *invite = [NSDictionary dictionaryWithObject:f_ids forKey:@"invite"];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:invite
                                                       options:NSJSONWritingPrettyPrinted error:&localError];
    if (localError != nil) {
        [self inviteFriendToLobbyFailedWithError:localError];
    }
    NSString *jsonString =[[NSString alloc] initWithData:jsonData encoding:NSASCIIStringEncoding];
    NSLog(@"invite jsondata: %@",jsonString);
    NSMutableURLRequest *request = [self createRequestWithJSON:jsonData endpoint:[NSString stringWithFormat:@"/api/games/lobby/%@/invite/",l_id] token:token];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            [self inviteFriendToLobbyFailedWithError:error];
        } else {
            [self receivedinviteFriendLobbyJSON:data];
        }
    }];
}

- (void)receivedinviteFriendLobbyJSON:(NSData *)objectNotation
{
    NSLog(@"receivedinviteFriendLobbyJSON");
    NSString *dataString = [[NSString alloc] initWithData:objectNotation encoding:NSASCIIStringEncoding];
    NSLog(@"data: %@",dataString);
    NSError *localError = nil;
    NSString *testString = [[NSString alloc] initWithData:objectNotation encoding:NSASCIIStringEncoding];
    NSLog(@"Teststring: %@",testString);
    if ([testString isEqualToString:@"OK"]) {
        NSLog(@"receivedinviteFriendLobbyJSON returned OK");
        [self.lobbyDelegate inviteFriendSucceded];
    } else {
        NSLog(@"receivedinviteFriendLobbyJSON DID NOT return OK");
        NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];
        if (localError != nil) {
            [self inviteFriendToLobbyFailedWithError:localError];
        } else {
            NSLog(@"receivedinviteFriendLobbyJSON else");
            if ([[parsedObject allKeys] containsObject:@"errors"]) {
                NSLog(@"receivedinviteFriendLobbyJSON failed with error: %@",[parsedObject objectForKey:@"errors"]);
                [self.lobbyDelegate inviteFriendFailed];
            } else {
                NSLog(@"receivedinviteFriendLobbyJSON failed but no errors");
            }
        }
    }
}

- (void)inviteFriendToLobbyFailedWithError:(NSError *)error
{
    [self.lobbyDelegate inviteFriendFailed];
}


#pragma mark - AcceptInvitation

- (void)acceptInviteWithToken:(NSString *)token lobbyID:(NSString *)l_id
{
    NSLog(@"acceptInviteWithToken");
    NSMutableURLRequest *request = [self createRequestWithPost:@"" endpoint:[NSString stringWithFormat:@"/api/games/lobby/%@/accept/",l_id] token:token];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            [self acceptInviteFailedWithError:error];
        } else {
            [self acceptInviteJSON:data];
        }
    }];
}

- (void)acceptInviteJSON:(NSData *)objectNotation
{
    NSLog(@"acceptInviteJSON");
    NSString *dataString = [[NSString alloc] initWithData:objectNotation encoding:NSASCIIStringEncoding];
    NSLog(@"data: %@",dataString);
    NSError *localError = nil;
    NSString *testString = [[NSString alloc] initWithData:objectNotation encoding:NSASCIIStringEncoding];
    NSLog(@"Teststring: %@",testString);
    if ([testString isEqualToString:@"OK"]) {
        NSLog(@"acceptInviteJSON returned OK");
        [self.lobbyDelegate acceptInviteSucceeded];
    } else {
        NSLog(@"acceptInviteJSON DID NOT return OK");
        NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];
        if (localError != nil) {
            [self acceptInviteFailedWithError:localError];
        } else {
            NSLog(@"acceptInviteJSON else");
            if ([[parsedObject allKeys] containsObject:@"errors"]) {
                NSLog(@"acceptInviteJSON failed with error: %@",[parsedObject objectForKey:@"errors"]);
                [self.lobbyDelegate acceptInviteFailed];
            } else {
                NSLog(@"acceptInviteJSON failed but no errors");
            }
        }
    }
}

- (void)acceptInviteFailedWithError:(NSError *)error
{
    [self.lobbyDelegate acceptInviteFailed];
}


# pragma mark - Start Lobby

- (void)startGameWithToken:(NSString *)token lobbyID:(NSString *)l_id
{
    NSLog(@"startGameWithToken");
    NSMutableURLRequest *request = [self createRequestWithPost:@"" endpoint:[NSString stringWithFormat:@"/api/games/lobby/%@/start/",l_id] token:token];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            [self startGameFailedWithError:error];
        } else {
            [self startGameResponse:data];
        }
    }];
}

- (void)startGameResponse:(NSData *)objectNotation
{
    NSLog(@"startGameResponse");
    NSString *dataString = [[NSString alloc] initWithData:objectNotation encoding:NSASCIIStringEncoding];
    NSLog(@"data: %@",dataString);
    if ([dataString isEqualToString:@"OK"]) {
        NSLog(@"startGameResponse returned OK");
        [self.lobbyDelegate startGameSucceeded];
    } else {
        NSError *localError = nil;
        NSLog(@"startGameResponse DID NOT return OK");
        NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];
        if (localError != nil) {
            [self startGameFailedWithError:localError];
        } else {
            NSLog(@"startGameResponse else");
            if ([[parsedObject allKeys] containsObject:@"errors"]) {
                NSLog(@"startGameResponse failed with error: %@",[parsedObject objectForKey:@"errors"]);
                [self.lobbyDelegate startGameFailed];
            } else {
                NSLog(@"startGameResponse failed but no errors");
            }
        }
    }
}

- (void)startGameFailedWithError:(NSError *)error
{
    [self.lobbyDelegate startGameFailed];
}

#pragma mark - Games

- (void)getGamesWithToken:(NSString *)token{
    NSLog(@"getGamesWithToken");
    NSMutableURLRequest *request = [self createRequestWithEndpoint:@"/api/games/" token:token];
    
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
    NSLog(@"receivedGamesJSON");
    NSString *dataString = [[NSString alloc] initWithData:objectNotation encoding:NSASCIIStringEncoding];
    NSLog(@"data: %@",dataString);
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];
    if (localError != nil) {
        [self gamesFailedWithError:localError];
    } else {
        NSArray *gs = [parsedObject objectForKey:@"games"];
        NSMutableArray *games = [[NSMutableArray alloc] init];
        for (NSDictionary *g in gs) {
            QBGame *game = [[QBGame alloc] initWithGameID:[g objectForKey:@"id"]
                                                     size:[[g objectForKey:@"size"] integerValue]
                                                    state:[[g objectForKey:@"state"] integerValue]];
            [games addObject:game];
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
    NSLog(@"getGameWithToken");
    NSMutableURLRequest *request = [self createRequestWithEndpoint:[NSString stringWithFormat:@"/api/games/%@/",g_id] token:token];
    
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
    NSLog(@"receivedGameJSON");
    NSString *dataString = [[NSString alloc] initWithData:objectNotation encoding:NSASCIIStringEncoding];
    NSLog(@"data: %@",dataString);
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];
    if (localError != nil) {
        [self getGameFailedWithError:localError];
    } else {
        NSArray *jsonPlayers = [parsedObject objectForKey:@"players"];
        NSMutableArray *players = [[NSMutableArray alloc] init];
        for (NSDictionary *jsonPlayer in jsonPlayers) {
            QBGamer *gamer = [[QBGamer alloc] initWithUserID:[jsonPlayer objectForKey:@"userId"]
                                                       email:[jsonPlayer objectForKey:@"email"]
                                                       score:[[jsonPlayer objectForKey:@"score"] integerValue]
                                                       state:[[jsonPlayer objectForKey:@"state"] integerValue]
                                                           x:[[jsonPlayer objectForKey:@"x"] integerValue]
                                                           y:[[jsonPlayer objectForKey:@"y"] integerValue]
                                                     correct:[[jsonPlayer objectForKey:@"answeredCorrectly"] boolValue]];
            [players addObject:gamer];
        }
        
        QBGame *game = [[QBGame alloc] initWithGameID:[parsedObject objectForKey:@"gameId"]
                                                board:[parsedObject objectForKey:@"board"]
                                              players:players];
        int i = 0;
        for (QBGamer *g in players) {
            switch (i) {
                case 0:
                    game.redColor = g;
                    break;
                case 1:
                    game.yellowColor = g;
                    break;
                case 2:
                    game.greenColor = g;
                    break;
                case 3:
                    game.blueColor = g;
                    break;
                    
                default:
                    break;
            }
            i++;
        }
        [self.gameDelegate game:game];
    }
}

- (void)getGameFailedWithError:(NSError *)error
{
    [self.gameDelegate getGameFailed];
}

#pragma mark - Play

- (void)playMoveWithToken:(NSString *)token gameID:(NSString *)g_id xCoord:(NSInteger)x yCoord:(NSInteger)y
{
    NSLog(@"acceptInviteWithToken");
    NSMutableURLRequest *request = [self createRequestWithPost:[NSString stringWithFormat:@"x=%d&y=%d",(int)x,(int)y] endpoint:[NSString stringWithFormat:@"/api/games/%@/play/move/",g_id] token:token];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            [self playMoveFailedWithError:error];
        } else {
            [self playMoveResponse:data];
        }
    }];
}

- (void)playMoveResponse:(NSData *)objectNotation
{
    NSLog(@"playMoveResponse");
    NSString *dataString = [[NSString alloc] initWithData:objectNotation encoding:NSASCIIStringEncoding];
    NSLog(@"data: %@",dataString);
    NSError *localError = nil;
    NSString *testString = [[NSString alloc] initWithData:objectNotation encoding:NSASCIIStringEncoding];
    NSLog(@"Teststring: %@",testString);
    if ([testString isEqualToString:@"OK"]||[testString isEqualToString:@""]) {
        NSLog(@"playMoveResponse returned OK");
        [self.playDelegate playMoveSucceded];
    } else {
        NSLog(@"playMoveResponse DID NOT return OK");
        NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];
        if (localError != nil) {
            [self playMoveFailedWithError:localError];
        } else {
            NSLog(@"playMoveResponse else");
            if ([[parsedObject allKeys] containsObject:@"errors"]) {
                NSLog(@"playMoveResponse failed with error: %@",[parsedObject objectForKey:@"errors"]);
                [self.playDelegate playMoveFailed];
            } else {
                NSLog(@"playMoveResponse failed but no errors");
            }
        }
    }
}

- (void)playMoveFailedWithError:(NSError *)error
{
    [self.playDelegate playMoveFailed];
}

#pragma mark - Question

- (void)getQuestionWithToken:(NSString *)token gameId:(NSString *)g_id
{
    NSLog(@"getQuestionWithToken");
    NSMutableURLRequest *request = [self createRequestWithPost:@"" endpoint:[NSString stringWithFormat:@"/api/games/%@/play/question/",g_id] token:token];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            [self getQuestionFailedWithError:error];
        } else {
            [self receivedQuestionJSON:data];
        }
    }];
}

- (void)receivedQuestionJSON:(NSData *)objectNotation
{
    NSLog(@"receivedQuestionJSON");
    NSString *dataString = [[NSString alloc] initWithData:objectNotation encoding:NSASCIIStringEncoding];
    NSLog(@"data: %@",dataString);
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];
    if (localError != nil) {
        [self getQuestionFailedWithError:localError];
    } else {
        NSArray *jsonAlternatives = [parsedObject objectForKey:@"alternatives"];
        QBQuestion *question = [[QBQuestion alloc] initWithQuestion:[parsedObject objectForKey:@"question"]
                                                            answer1:[jsonAlternatives objectAtIndex:0]
                                                            answer2:[jsonAlternatives objectAtIndex:1]
                                                            answer3:[jsonAlternatives objectAtIndex:2]
                                                            answer4:[jsonAlternatives objectAtIndex:3]];
        [self.questionDelegate receivedQuestion:question];
    }
}

- (void)getQuestionFailedWithError:(NSError *)error
{
    [self.questionDelegate questionFailed];
}

#pragma mark - Answer

- (void)sendAnswerWithToken:(NSString *)token gameId:(NSString *)g_id answer:(NSInteger)answer
{
    NSLog(@"sendAnswerWithToken");
    NSMutableURLRequest *request = [self createRequestWithPost:[NSString stringWithFormat:@"answer=%d",(int)answer] endpoint:[NSString stringWithFormat:@"/api/games/%@/play/answer/",g_id] token:token];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            [self answerFailedWithError:error];
        } else {
            [self answerResponse:data];
        }
    }];
}

- (void)answerResponse:(NSData *)objectNotation
{
    NSLog(@"playMoveResponse");
    NSString *dataString = [[NSString alloc] initWithData:objectNotation encoding:NSASCIIStringEncoding];
    NSLog(@"data: %@",dataString);
    NSError *localError = nil;
    if ([dataString isEqualToString:@"OK"]||[dataString isEqualToString:@""]) {
        NSLog(@"answerResponse returned OK");
        [self.questionDelegate answerSucceded];
    } else {
        NSLog(@"answerResponse DID NOT return OK");
        NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];
        if (localError != nil) {
            [self answerFailedWithError:localError];
        } else {
            NSLog(@"answerResponse else");
            if ([[parsedObject allKeys] containsObject:@"errors"]) {
                NSLog(@"answerResponse failed with error: %@",[parsedObject objectForKey:@"errors"]);
                [self.questionDelegate answerFailed];
            } else {
                NSLog(@"answerResponse failed but no errors");
                if ([parsedObject objectForKey:@"isCorrect"]) {
                    [self.questionDelegate answerSucceded];
                } else if ([parsedObject objectForKey:@"isCorrect"]) {
                    [self.questionDelegate answerSucceded];
                }
            }
        }
    }
}

- (void)answerFailedWithError:(NSError *)error
{
    [self.questionDelegate answerFailed];
}


#pragma mark - Me
- (void)getMeWithToken:(NSString *)token{
    NSLog(@"getMeWithToken");
    NSMutableURLRequest *request = [self createRequestWithEndpoint:@"/api/users/me/" token:token];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            [self getMeFailedWithError:error];
        } else {
            [self receivedMeJSON:data];
        }
    }];
}

- (void)receivedMeJSON:(NSData *)objectNotation
{
    NSLog(@"receivedMeJSON");
    NSString *dataString = [[NSString alloc] initWithData:objectNotation encoding:NSASCIIStringEncoding];
    NSLog(@"data: %@",dataString);
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];
    if (localError != nil) {
        [self getMeFailedWithError:localError];
    } else {
        [self.meDelegate returnMeWithUserID:[parsedObject objectForKey:@"id"] email:[parsedObject objectForKey:@"email"]];
    }
}

- (void)getMeFailedWithError:(NSError *)error
{
    [self.meDelegate getMeFailed];
}

@end
