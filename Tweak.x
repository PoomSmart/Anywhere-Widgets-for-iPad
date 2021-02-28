#import <UIKit/UIKit.h> // FIXME: fix header
#import <Foundation/Foundation.h>
#import <SpringBoard/SBIcon.h>

@interface SBIcon (Additions)
- (BOOL)isWidgetIcon;
@end

%hook SBHDefaultIconListLayoutProvider

- (void)configureSupportedIconGridSizeClasses:(NSUInteger *)iconGridSizeClass forScreenType:(NSUInteger)screenType iconLocation:(NSString *)iconLocation {
	BOOL isFromWidgetPanel = [iconLocation isEqualToString:@"SBIconLocationTodayView"] || [iconLocation isEqualToString:@"SBIconLocationGroupTodayView"];
	%orig(iconGridSizeClass, isFromWidgetPanel ? 13 : screenType, iconLocation); // 13 is for iPhone 12 Pro Max
}

%end

%hook SBHIconManager

- (bool)canAddIconToIgnoredList:(SBIcon *)icon {
	bool value = %orig;
	return !value && [icon isWidgetIcon] ? true : value;
}

- (bool)rootFolder:(id)rootFolder canAddIcon:(SBIcon *)icon toIconList:(id)iconList inFolder:(id)folder {
	return true;
}

%end

%hook SBIconListGridLayout

- (NSUInteger)numberOfColumnsForOrientation:(NSInteger)orientation {
	NSUInteger columns = %orig;
	return columns == 6 || columns == 5 ? columns + 2 : columns;
}

- (NSUInteger)numberOfRowsForOrientation:(NSInteger)orientation {
	NSUInteger rows = %orig;
	return rows == 5 || rows == 4 ? rows + 1 : rows;
}

%end