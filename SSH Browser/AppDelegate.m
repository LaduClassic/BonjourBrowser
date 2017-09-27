//
//  AppDelegate.m
//  SSH Browser
//
//  Created by Arne Scheffler on 11.12.15.
//  Copyright © 2015 Arne Scheffler. All rights reserved.
//

#import "AppDelegate.h"
#import "ServerRegistry.h"

@interface AppDelegate ()

@property ServerRegistry* sshServers;
@property ServerRegistry* webServers;
@property NSStatusItem* statusItem;

@end


@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	self.sshServers = [[ServerRegistry alloc] initWithServiceType:sshServiceType inDomain:localDomain];
	self.webServers = [[ServerRegistry alloc] initWithServiceType:httpServiceType inDomain:localDomain];

	self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:26];
	NSStatusBarButton* button = self.statusItem.button;
	if (button)
	{
		[button setImage:[NSImage imageNamed:@"MenuIcon"]];
	}
	NSMenu* menu = [[NSMenu alloc] init];
	menu.delegate = self;
	self.statusItem.menu = menu;
}

- (IBAction)connectToSSHServer:(id)sender
{
	Server* server = [sender representedObject];
	if (server)
	{
		NSURL* url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"ssh://%@", server.hostname]];
		[[NSWorkspace sharedWorkspace] openURL:url];
	}
}

- (IBAction)connectToHTTPServer:(id)sender
{
	Server* server = [sender representedObject];
	if (server)
	{
		NSString* path = @"";
		NSData* data = server.netService.TXTRecordData;
		if (data)
		{
			NSDictionary<NSString *, NSData *> * dict = [NSNetService dictionaryFromTXTRecordData:data];
			if (dict)
			{
				NSData* pathData = dict[@"path"];
				if (pathData)
				{
					path = [[NSString alloc] initWithData:pathData encoding:NSUTF8StringEncoding];
				}
			}
		}
		NSURL* url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://%@:%ld%@", server.hostname, (long)server.netService.port, path]];
		[[NSWorkspace sharedWorkspace] openURL:url];
	}
}

- (void)addServersFromRegistry:(ServerRegistry*)registry toMenu:(NSMenu*)menu withTitle:(NSString*)title andAction:(SEL)action
{
	NSMenuItem* item = [[NSMenuItem alloc] initWithTitle:title action:nil keyEquivalent:@""];
	item.enabled = NO;
	[menu addItem:item];
	for (Server* server in registry.list)
	{
		item = [[NSMenuItem alloc] initWithTitle:server.title action:action keyEquivalent:@""];
		item.target = self;
		item.representedObject = server;
		item.indentationLevel = 1;
		[menu addItem:item];
	}
}

- (void)menuWillOpen:(NSMenu *)menu
{
	[self addServersFromRegistry:self.sshServers toMenu:self.statusItem.menu withTitle:@"SSH" andAction:@selector(connectToSSHServer:)];
	[self addServersFromRegistry:self.webServers toMenu:self.statusItem.menu withTitle:@"HTTP" andAction:@selector(connectToHTTPServer:)];
	[self.statusItem.menu addItem:[NSMenuItem separatorItem]];
	NSMenuItem* item = [[NSMenuItem alloc] initWithTitle:@"Quit SSH Browser" action:@selector(terminate:) keyEquivalent:@""];
	[self.statusItem.menu addItem:item];
}

- (void)menuDidClose:(NSMenu *)menu
{
	[self.statusItem.menu removeAllItems];
}

@end

