
#import "AACMessagePort.h"
#import <dlfcn.h>
#import <UIKit/UIKit.h>

@interface SBUIController
+(id)sharedInstance;
-(BOOL)clickedMenuButton;
-(BOOL)handleMenuDoubleTap;
-(id)_appSwitcherController;
-(BOOL)_activateAppSwitcher;
-(void)_dismissSwitcherAnimated:(BOOL)animated;
-(BOOL)isAppSwitcherShowing;
@end

@interface SBAppSwitcherModel

+(id)sharedInstance;
-(id)_recentsFromPrefs;	
-(void)_saveRecents;

@end

@interface SBDisplayLayout

@property(readonly, assign, nonatomic) NSArray* displayItems;

@end

@interface SBDisplayItem

@property(readonly, assign, nonatomic) NSString* displayIdentifier;

@end

@interface SBAppSwitcherController

-(void)_quitAppWithDisplayItem:(id)displayItem;

@end

@interface SBApplication

-(id)bundleIdentifier;
-(BOOL)isSystemApplication;
-(id)bundle;
-(id)displayName;
-(id)_copyApplicationMetadata;
-(id)sandboxPath;

@end

@interface SpringBoard

-(void)launchAppWithDictionary:(NSDictionary *)appDict;
-(void)launchApp:(NSString *)identifier forDuration:(int)duration;
-(id)_accessibilityFrontMostApplication;
-(void)showSpringBoardStatusBar;
-(NSDictionary *)allUserApplication;
-(NSDictionary *)dpiUAForIdentifier:(NSDictionary *)appIdentifier;

@end

@interface SBIconController

+(id)sharedInstance;
-(BOOL)canUninstallIcon:(id)icon;
-(void)uninstallIcon:(id)icon animate:(BOOL)animate;

@end

@interface SBIconModel

-(id)leafIconForIdentifier:(NSString*)identifier;
-(id)leafIcons;

@end

@interface SBIcon

-(void)launchFromLocation:(int)location;

@end

@interface SBApplicationController

+(id)sharedInstance;
-(id)allApplications;
-(id)applicationWithBundleIdentifier:(id)bundleIdentifier;

@end

%hook SBAppSwitcherPageViewController

-(void)removeItem:(id)item duration:(double)duration updateScrollPosition:(BOOL)position completion:(id)completion{
	NSMutableArray *__displayLayouts = [self valueForKey:@"_displayLayouts"];
	if ([__displayLayouts containsObject:item])
	{
		%orig;
	}
}

%end

%hook SBAppSwitcherIconController

-(void)removeItem:(id)item duration:(double)duration updateScrollPosition:(BOOL)position completion:(id)completion{
	NSMutableArray *__appList = [self valueForKey:@"_appList"];
	if ([__appList containsObject:item])
	{
		%orig;
	}
}

%end

static void killBackground(){
	BOOL isAppSwitcherShowing = [[objc_getClass("SBUIController") sharedInstance] isAppSwitcherShowing];
	if ([[objc_getClass("SBUIController") sharedInstance] _activateAppSwitcher] || isAppSwitcherShowing)
	{
		[[objc_getClass("SBAppSwitcherModel") sharedInstance] _saveRecents];
		id frontMostApplication = [(SpringBoard*)[UIApplication sharedApplication] _accessibilityFrontMostApplication];
		SBAppSwitcherController *appSwitcherController = [[objc_getClass("SBUIController") sharedInstance] _appSwitcherController];
		NSArray *_prefs = [[[objc_getClass("SBAppSwitcherModel") sharedInstance] _recentsFromPrefs] copy];
		for (SBDisplayLayout* displayLayout in _prefs) {
			if ([[displayLayout displayItems] count] > 0)
			{
				SBDisplayItem *item = [[displayLayout displayItems] objectAtIndex:0];
				NSString *identifier = [item displayIdentifier];
				if ([identifier isEqualToString:[frontMostApplication bundleIdentifier]])
				{
					continue;
				}
				[appSwitcherController _quitAppWithDisplayItem:item];
			}
		}
		[_prefs release];
		if (!isAppSwitcherShowing)
		{
			[[objc_getClass("SBUIController") sharedInstance] _dismissSwitcherAnimated:NO];
		}
		if (frontMostApplication == nil)
		{
			[(SpringBoard *)[UIApplication sharedApplication] showSpringBoardStatusBar];
		}
		[[objc_getClass("SBAppSwitcherModel") sharedInstance] _saveRecents];
	}
}


static CFDataRef messageServerCallback(CFMessagePortRef local, SInt32 messageId, CFDataRef data, void *info)
{
	switch (messageId) {
		case AACMessageIdLaunchAppForTime :{
			NSDictionary *appDict = AACTransformDataToPropertyList(data);
			[[UIApplication sharedApplication] performSelectorOnMainThread:@selector(launchAppWithDictionary:) withObject:appDict waitUntilDone:NO];
			return NULL;
		}
		break;
		case AACMessageIdKillBackground : {
			killBackground();
			return NULL;
		}
		break;
		case AACMessageIdListAllApps :{
			NSDictionary *allApps = [(SpringBoard*)[UIApplication sharedApplication] allUserApplication];
			return (CFDataRef)[AACTransformPropertyListToData(@{@"Apps":allApps}) retain];
		}
		break;
	}
	return NULL;
}

%hook SpringBoard

%new
-(NSDictionary *)allUserApplication{
	NSArray *applications = [[objc_getClass("SBApplicationController") sharedInstance] allApplications];
	NSMutableDictionary *result = [NSMutableDictionary dictionary];
	for (SBApplication *app in applications){
		if (![app isSystemApplication])
		{
			NSDictionary *bundleInfo = [[app bundle] infoDictionary];
			
			[result setObject:[NSString stringWithFormat:@"%@|%@|%@|%@",
				[bundleInfo objectForKey:@"CFBundleShortVersionString"]?[bundleInfo objectForKey:@"CFBundleShortVersionString"]:@"",
				[app displayName],
				[[app _copyApplicationMetadata] objectForKey:@"itemId"]?[[app _copyApplicationMetadata] objectForKey:@"itemId"]:@"",
				[bundleInfo objectForKey:@"CFBundleExecutable"]?[bundleInfo objectForKey:@"CFBundleExecutable"]:@""] forKey:[bundleInfo objectForKey:@"CFBundleIdentifier"]];
		}
	}
	return result;
}

%new
-(void)launchAppWithDictionary:(NSDictionary *)appDict{
	NSString *bundleIdentifier = [appDict objectForKey:@"Identifier"];
	int duration = [[appDict objectForKey:@"Duration"] intValue];
	[(SpringBoard *)[UIApplication sharedApplication] launchApp:bundleIdentifier forDuration:duration];
}

%new
-(void)launchApp:(NSString *)identifier forDuration:(int)duration{
	NSLog(@"LaunchApp %@",identifier);
	NSLog(@"duration %d",duration);
	[[[[objc_getClass("SBIconController") sharedInstance] valueForKey:@"_iconModel"] leafIconForIdentifier:identifier] launchFromLocation:0];
	if (duration > 0)
	{
		[(id)self performSelector:@selector(quitApp) withObject:nil afterDelay:duration];
		[(id)self performSelector:@selector(printDPIForIdentifier:) withObject:identifier afterDelay:duration+5];
	}
}

%new
-(void)quitApp{
	NSLog(@"quitapp");
	[[objc_getClass("SBUIController") sharedInstance] clickedMenuButton];
}

%new
-(void)printDPIForIdentifier:(NSString *)identifier{
	NSLog(@"Print DPI %@",identifier);
	id application = [[objc_getClass("SBApplicationController") sharedInstance] applicationWithBundleIdentifier:identifier];
	if (application != nil)
	{
		NSString *sandboxPath = [application sandboxPath];
		NSString *dpiPath = [sandboxPath stringByAppendingPathComponent:@"Library/Caches/DPIUA.plist"];
		NSDictionary *dpiResult = [NSDictionary dictionaryWithContentsOfFile:dpiPath];
		if (dpiResult != nil)
		{
			NSLog(@"DPI %@",dpiResult);
		}
	}
}

%new
-(void)uninstallAllApp{
	SBIconModel* _iconModel = [[objc_getClass("SBIconController") sharedInstance] valueForKey:@"_iconModel"];
	if (_iconModel)
	{
		for (id icon in [[_iconModel leafIcons] allObjects]) {
			if ([[objc_getClass("SBIconController") sharedInstance] canUninstallIcon:icon])
			{
				[[objc_getClass("SBIconController") sharedInstance] uninstallIcon:icon animate:YES];
			}
		}
	}
}

-(void)applicationDidFinishLaunching:(id)application{
	%orig;
	CFMessagePortRef localPort = CFMessagePortCreateLocal(kCFAllocatorDefault, kAACMessageServerName, messageServerCallback, NULL, NULL);
	CFRunLoopSourceRef source = CFMessagePortCreateRunLoopSource(kCFAllocatorDefault, localPort, 0);
	CFRunLoopAddSource(CFRunLoopGetCurrent(), source, kCFRunLoopDefaultMode);
}

%end
