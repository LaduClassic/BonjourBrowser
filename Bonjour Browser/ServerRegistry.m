//
//  SSHServers.m
//  Bonjour Browser
//
//  Created by Arne Scheffler on 11.12.15.
//  Copyright © 2015 Arne Scheffler. All rights reserved.
//

#import "ServerRegistry.h"

@implementation Server

- (instancetype)initWithTitle:(NSString*)title host:(NSString*)host service:(NSNetService*)service
{
	self =[super init];
	if (self)
	{
		self->_title = title;
		self->_hostname = host;
		self->_netService = service;
	}
	return self;
}

@end

@interface ServerRegistry ()

@property NSNetServiceBrowser* browser;
@property NSMutableArray<NSNetService*>* services;

@end

@implementation ServerRegistry

-(instancetype)initWithServiceType:(NSString*)serviceType inDomain:(NSString*)domain;
{
	self = [super init];
	if (self)
	{
		self->_list = [NSMutableArray new];
		self.services = [NSMutableArray new];
		self.browser = [NSNetServiceBrowser new];
		self.browser.delegate = self;
		[self.browser scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
		[self.browser searchForServicesOfType:serviceType inDomain:domain];
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

- (void)netServiceBrowser:(NSNetServiceBrowser *)browser didRemoveService:(NSNetService *)service moreComing:(BOOL)moreComing
{
	for (Server* server in self.list)
	{
		if ([server.netService.name isEqualToString:service.name]
			&& [server.netService.type isEqualToString:service.type]
			&& [server.netService.domain isEqualToString:service.domain]
			)
		{
			[self.list removeObject:server];
			break;
		}
	}
}

- (void)netServiceDidResolveAddress:(NSNetService *)sender
{
	Server* server = [[Server alloc] initWithTitle:sender.name host:sender.hostName service:sender];
	[self.list addObject:server];
	[self.services removeObject:sender];
	[sender removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
	[self.list sortUsingComparator:^NSComparisonResult(Server*  _Nonnull obj1, Server*  _Nonnull obj2) {
		return [obj1.title compare:obj2.title options:NSDiacriticInsensitiveSearch|NSCaseInsensitiveSearch];
	}];
}

@end

