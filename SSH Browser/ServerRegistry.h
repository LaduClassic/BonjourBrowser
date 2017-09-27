//
//  SSHServers.h
//  SSH Browser
//
//  Created by Arne Scheffler on 11.12.15.
//  Copyright © 2015 Arne Scheffler. All rights reserved.
//

#ifndef SSHServers_h
#define SSHServers_h

#import <AppKit/AppKit.h>

@interface Server : NSObject

@property (readonly, atomic) NSString* title;
@property (readonly, atomic) NSString* hostname;
@property (readonly, atomic) NSNetService* netService;

@end

@interface ServerRegistry : NSObject<NSNetServiceBrowserDelegate, NSNetServiceDelegate>

@property (readonly, atomic) NSMutableArray<Server*>* list;

@end

#endif /* SSHServers_h */
