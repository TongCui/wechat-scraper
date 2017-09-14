
#import <Foundation/Foundation.h>
#import "AACMessagePort.h"

int main(int argc, char **argv, char **envp) {
	if (argc == 2) {
		if (strcmp(argv[1], "killallapps") == 0 || strcmp(argv[1], "killall") == 0 || strcmp(argv[1], "kill") == 0) {
			AACGetServerPort();
			AACSendTwoWayMessage(AACMessageIdKillBackground, NULL);
			return 0;
		} else if (strcmp(argv[1], "list") == 0) {
			AACGetServerPort();
			CFDataRef returnData = AACSendTwoWayMessage(AACMessageIdListAllApps, NULL);
			NSDictionary *applist = [AACConsume(AACTransformDataToPropertyList, returnData, nil) objectForKey:@"Apps"];
			NSLog(@"%@",applist);
			return 0;
		} else if (strcmp(argv[1], "listjson") == 0) {
			AACGetServerPort();
			CFDataRef returnData = AACSendTwoWayMessage(AACMessageIdListAllApps, NULL);
			NSDictionary *applist = [AACConsume(AACTransformDataToPropertyList, returnData, nil) objectForKey:@"Apps"];
			NSData *jsonData = [NSJSONSerialization dataWithJSONObject:applist options:0 error:nil];
			NSLog(@"%@",[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
			return 0;
		}
	} else if (argc == 3) {

		NSString *identifier = [NSString stringWithCString:argv[2] encoding:NSUTF8StringEncoding];
		NSLog(@"%@", identifier);

		NSDictionary *appDict = [NSDictionary dictionaryWithObjectsAndKeys:identifier,@"Identifier", @"100", @"Duration",nil];

		if (strcmp(argv[1], "launch") == 0) {
			AACGetServerPort();
			AACSendTwoWayMessage(AACMessageIdLaunchAppForTime, (CFDataRef)AACTransformPropertyListToData(appDict));
			return 0;
		} else if (strcmp(argv[1], "kill") == 0) {
			AACGetServerPort();
			CFDataRef returnData = AACSendTwoWayMessage(AACMessageIdListAllApps, NULL);
			NSDictionary *applist = [AACConsume(AACTransformDataToPropertyList, returnData, nil) objectForKey:@"Apps"];
			NSLog(@"%@",applist);
			return 0;
		} 
	}

	printf("USAGE : wmanager [killall|killallapps|kill] # Kill Backgrond Applications");
	printf("								 [list] # List all Applications");
	printf("								 [listjson] # List all Applications with json format");

	return 0;
}