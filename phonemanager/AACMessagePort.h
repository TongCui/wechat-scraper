
#define kAACMessageServerName CFSTR("AppLauncher.springboard")
#define kAACMessageWaitingRunLoopMode CFSTR("applauncher.waiting-on-springboard")

enum{
	AACMessageIdLaunchAppForTime = 0,
	AACMessageIdKillBackground = 1,
	AACMessageIdListAllApps = 2,
	AACMessageIdInstallApp = 3,
};

static CFMessagePortRef serverPort;

#define AACConsume(transformer, data, defaultValue) ({ \
	__typeof__(data) _data = data; \
	__typeof__(transformer(_data)) result; \
	if (_data) { \
		result = transformer(_data); \
		CFRelease((CFTypeRef)_data); \
	} else { \
		result = defaultValue; \
	} \
	result; \
})

static inline CFMessagePortRef AACGetServerPort()
{
	if (serverPort && CFMessagePortIsValid(serverPort))
		return serverPort;
	return (serverPort = CFMessagePortCreateRemote(kCFAllocatorDefault, kAACMessageServerName));
}

static inline void AACSendOneWayMessage(SInt32 messageId, CFDataRef data)
{
	CFMessagePortRef messagePort = AACGetServerPort();
	if (messagePort) {
		CFMessagePortSendRequest(messagePort, messageId, data, 2.0, 2.0, NULL, NULL);
	}
}

static inline CFDataRef AACSendTwoWayMessage(SInt32 messageId, CFDataRef data)
{
	CFDataRef outData = NULL;
	CFMessagePortRef messagePort = AACGetServerPort();
	if (messagePort) {
		CFMessagePortSendRequest(messagePort, messageId, data, 2.0, 2.0, kAACMessageWaitingRunLoopMode, &outData);
	}
	return outData;
}

static inline id AACTransformDataToPropertyList(CFDataRef data)
{
	return [NSPropertyListSerialization propertyListFromData:(NSData *)data mutabilityOption:0 format:NULL errorDescription:NULL];
}

static inline NSData *AACTransformPropertyListToData(id propertyList)
{
	return [NSPropertyListSerialization dataFromPropertyList:propertyList format:NSPropertyListBinaryFormat_v1_0 errorDescription:NULL];
}