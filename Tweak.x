#import <UIKit/UIKit.h> // FIXME: fix header
#import <Foundation/Foundation.h>
#import <SpringBoard/SBIcon.h>

typedef struct SBHIconGridSize {
	uint16_t columns;
	uint16_t rows;
} SBHIconGridSize;

@interface SBIconListGridlLayoutConfiguration : NSObject
@property NSUInteger numberOfLandscapeRows;
@property NSUInteger numberOfLandscapeColumns;
@property NSUInteger numberOfPortraitRows;
@property NSUInteger numberOfPortraitColumns;
@end

@interface SBIconListGridLayout : NSObject
@end

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

%hook SBHDefaultIconListLayoutProvider

- (SBIconListGridLayout *)makeLayoutForIconLocation:(NSString *)iconLocation {
	SBIconListGridLayout *layout = %orig;
	if ([iconLocation hasPrefix:@"SBIconLocationRoot"]) {
		SBIconListGridlLayoutConfiguration *config = [layout valueForKey:@"_layoutConfiguration"];
		config.numberOfLandscapeRows += 1;
		config.numberOfLandscapeColumns += 2;
		config.numberOfPortraitRows += 1;
		config.numberOfPortraitColumns += 2;
	}
	return layout;
}

%end

// %hook SBIconListView

// - (SBHIconGridSize)iconGridSizeForClass:(int)iconGridSizeClass {
// 	SBHIconGridSize size = %orig;
// 	return size;
// }

// %end