//
//  AppDelegate.m
//  Moody
//
//  Created by David Mohl on 17.02.12.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize menu;
@synthesize oldSkypeStatus;
@synthesize currentSong;
@synthesize pollingItem;
@synthesize prefWindow;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{    
    moody = [MoodyController new];
    
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
    statusItem.image = [NSImage imageNamed:@"menu_icon.png"];
    statusItem.alternateImage = [NSImage imageNamed:@"menu_alt_icon.png"];
    statusItem.highlightMode = YES;
    statusItem.menu = menu;

    oldSkypeStatus = [moody getSkypeMood];
    
    
    
    NSMethodSignature *sgn = [self methodSignatureForSelector:@selector(onTick:)];
    NSInvocation *inv = [NSInvocation invocationWithMethodSignature: sgn];
    [inv setTarget: self];
    [inv setSelector:@selector(onTick:)];
    
    
    
    NSTimer *timer = [NSTimer timerWithTimeInterval:5.0 invocation:inv repeats:YES];
    NSRunLoop *runner = [NSRunLoop currentRunLoop];
    [runner addTimer:timer forMode:NSDefaultRunLoopMode];

}
- (void)onTick:(NSTimer *)timer {
    NSString *spotify_current = [moody getSpotifySong];
    
    if (![spotify_current isEqualToString:currentSong]) {
        if (spotify_current != NULL) {
            NSString *mood = [NSString stringWithFormat:@"(music) %@", spotify_current];
            [moody setSkypeMood:mood];
            
            currentSong = spotify_current;   
        }
    }
}
                      
- (IBAction)onQuit:(id)sender {
    [moody setSkypeMood:oldSkypeStatus];
    exit(0);
}

- (IBAction)prefAction:(id)sender {
    [prefWindow makeKeyAndOrderFront:self];
    [NSApp activateIgnoringOtherApps:YES];
}

- (IBAction)hideAction:(id)sender {
    [prefWindow orderOut:self]; 
}
@end
