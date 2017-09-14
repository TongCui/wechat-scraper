#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#include <string.h>
#include <notify.h>
#import "AACMessagePort.h"

int main(int argc, char **argv, char **envp) {

	if (argc == 2) {
		if (strcmp(argv[1], "killallapps") == 0 || 
				strcmp(argv[1], "killall") == 0 || 
				strcmp(argv[1], "kill") == 0) {			
			AACGetServerPort();
			AACSendTwoWayMessage(AACMessageIdKillBackground, NULL);
			return 0;
		} 
		if (strcmp(argv[1], "stop") == 0) {
			// NSString *notifyString = [NSString stringWithFormat:@"com.plipala.monkeytest.stopanalytics-%s",argv[2]];
			// notify_post([notifyString cStringUsingEncoding:NSUTF8StringEncoding]);
			printf("===WeChat Scraper for %s",argv[2]);
			return 0;
		} 
		
	}
	printf("USAGE : wscraper [start|stop]");
	return 0;
}