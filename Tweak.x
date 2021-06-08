#import <SpringBoard/SBIcon.h>
#import <SpringBoard/SBIconView.h>
#import <SpringBoardHome/SBHIconGridSize.h>

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

%hook SBIconListView

- (CGPoint)_overrideOriginForIconAtRowIndex:(NSUInteger)rowIndex columnIndex:(NSUInteger)columnIndex gridSize:(SBHIconGridSize)gridSize metrics:(id)metrics {
	// Prevent widgets to be off grid
	return CGPointMake(NAN, NAN);
}

%end
