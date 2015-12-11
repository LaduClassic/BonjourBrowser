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

@interface SSHServer : NSObject

@property (readonly, atomic) NSString* title;
@property (readonly, atomic) NSString* hostname;

@end

@interface SSHServers : NSObject<NSNetServiceBrowserDelegate, NSNetServiceDelegate>

@property (readonly, atomic) NSMutableArray<SSHServer*>* list;

@end

#endif /* SSHServers_h */
