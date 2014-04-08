THEOS_DEVICE_IP = 192.168.1.192
TARGET = iphone:7.0:6.0
ARCHS = armv7 armv7s arm64

include theos/makefiles/common.mk

TWEAK_NAME = Weixin
Weixin_FILES = Tweak_Account.xm Account/AccountListController.m Account/NSDictionary+Keychain.m
Weixin_FRAMEWORKS = UIKit CoreFoundation Foundation CoreGraphics QuartzCore Security

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 MicroMessenger"
