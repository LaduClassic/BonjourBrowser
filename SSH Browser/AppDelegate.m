//
//  AppDelegate.m
//  SSH Browser
//
//  Created by Arne Scheffler on 11.12.15.
//  Copyright © 2015 Arne Scheffler. All rights reserved.
//

#import "AppDelegate.h"
#import "SSHServers.h"

@interface AppDelegate ()

@property SSHServers* sshServers;
@property NSStatusItem* statusItem;

@end


@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	self.sshServers = [SSHServers new];

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
	SSHServer* server = [sender representedObject];
	if (server)
	{
		NSURL* url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"ssh://%@", server.hostname]];
		[[NSWorkspace sharedWorkspace] openURL:url];
	}
}

- (void)menuWillOpen:(NSMenu *)menu
{
	NSMenuItem* item = [[NSMenuItem alloc] initWithTitle:@"SSH Hosts:" action:nil keyEquivalent:@""];
	item.enabled = NO;
	[self.statusItem.menu addItem:item];

	for (SSHServer* server in self.sshServers.list)
	{
		NSMenuItem* item = [[NSMenuItem alloc] initWithTitle:server.title action:@selector(connectToSSHServer:) keyEquivalent:@""];
		item.target = self;
		item.representedObject = server;
		item.indentationLevel = 1;
		[self.statusItem.menu addItem:item];
	}
	[self.statusItem.menu addItem:[NSMenuItem separatorItem]];
	item = [[NSMenuItem alloc] initWithTitle:@"Quit SSH Browser" action:@selector(terminate:) keyEquivalent:@""];
	[self.statusItem.menu addItem:item];
}

- (void)menuDidClose:(NSMenu *)menu
{
	[self.statusItem.menu removeAllItems];
}

@end
