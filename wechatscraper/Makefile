ARCHS = armv7 armv7s arm64
TARGET=iphone:latest:8.0

ADDITIONAL_OBJCFLAGS = -fobjc-arc
	
FILES = CGGeometry-KIFAdditions.m \
DDSwizzleManager.m \
KIFTypist.m \
MTAutomationBridge.m \
MTGridWindow.m \
MTMonkeyTestManager.m \
MTSenseLog.m \
MTSenseOperation.m \
MTVCSense.m \
NSBundle-KIFAdditions.m \
NSError-KIFAdditions.m \
NSException-KIFAdditions.m \
NSFileManager-KIFAdditions.m \
NSString+Tools.m \
UIAccessibilityElement-KIFAdditions.m \
UIApplication+Swizzle.m \
UIApplication+Tools.m \
UIApplication-KIFAdditions.m \
UIAutomationBridge.m \
UIEvent+KIFAdditions.m \
UIImage+Swizzle.m \
UIImage+Tools.m \
UIScrollView-KIFAdditions.m \
UITableView-KIFAdditions.m \
UITouch-KIFAdditions.m \
UIView+Tools.m \
UIView-Debugging.m \
UIView-KIFAdditions.m \
UIViewController+Swizzle.m \
UIViewController+Tools.m \
UIWindow-KIFAdditions.m

include theos/makefiles/common.mk

TWEAK_NAME = wechatscraper
wechatscraper_FILES = $(FILES) Tweak.xm
wechatscraper_FRAMEWORKS = UIKit CoreGraphics Foundation SystemConfiguration CFNetwork Security MobileCoreServices IOKit WebKit

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
