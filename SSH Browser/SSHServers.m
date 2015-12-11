//
//  SSHServers.m
//  SSH Browser
//
//  Created by Arne Scheffler on 11.12.15.
//  Copyright © 2015 Arne Scheffler. All rights reserved.
//

#import "SSHServers.h"

@implementation SSHServer

- (instancetype)initWithTitle:(NSString*)title andHost:(NSString*)host
{
	self =[super init];
	if (self)
	{
		self->_title = title;
		self->_hostname = host;
	}
	return self;
}

@end

@interface SSHServers ()

@property NSNetServiceBrowser* browser;
@property NSMutableArray<NSNetService*>* services;

@end

@implementation SSHServers

- (instancetype)init
{
	self = [super init];
	if (self)
	{
		self->_list = [NSMutableArray new];
		self.services = [NSMutableArray new];
		self.browser = [NSNetServiceBrowser new];
		self.browser.delegate = self;
		[self.browser scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
		[self.browser searchForServicesOfType:@"_ssh._tcp" inDomain:@"local"];
	}
	return self;
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)browser didFindService:(NSNetService *)service moreComing:(BOOL)moreComing
{
	service.delegate = self;
	[service scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
	[service resolveWithTimeout:10.];
	[self.services addObject:service];
}

- (void)netServiceDidResolveAddress:(NSNetService *)sender
{
	SSHServer* server = [[SSHServer alloc] initWithTitle:sender.name andHost:sender.hostName];
	[self.list addObject:server];
	[self.services removeObject:sender];
}

@end

