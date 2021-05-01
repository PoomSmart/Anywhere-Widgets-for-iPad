#import <SpringBoard/SBIcon.h>
#import <SpringBoard/SBIconView.h>
#import <SpringBoardHome/SBIconListGridLayout.h>
#import <SpringBoardHome/SBIconListGridLayoutConfiguration.h>
#import <SpringBoardHome/SBHIconGridSize.h>
#import <SpringBoardHome/SBHIconGridSizeClass.h>

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

%hook SBHDefaultIconListLayoutProvider

- (SBIconListGridLayout *)makeLayoutForIconLocation:(NSString *)iconLocation {
	SBIconListGridLayout *layout = %orig;
	if ([iconLocation hasPrefix:@"SBIconLocationRoot"]) {
		// Landscape: 6x5 -> 8x6
		// Landscape zoomed: 5x4 -> 7x5
		// Portrait: 6x5 -> 8x7
		// Portrait zoomed: 5x4 -> 7x6
		// Recommendation: Don't put icons per page more than 8x6 = 48 icons
		SBIconListGridLayoutConfiguration *config = [layout valueForKey:@"_layoutConfiguration"];
		config.numberOfLandscapeRows += 1;
		config.numberOfLandscapeColumns += 2;
		config.numberOfPortraitRows += 2;
		config.numberOfPortraitColumns += 2;
	}
	return layout;
}

%end

%hook SBIconListView

- (CGPoint)_overrideOriginForIconAtRowIndex:(NSUInteger)rowIndex columnIndex:(NSUInteger)columnIndex gridSize:(SBHIconGridSize)gridSize metrics:(id)metrics {
	// Prevent widgets to be off grid
	return CGPointMake(NAN, NAN);
}

%end
