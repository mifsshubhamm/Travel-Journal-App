//
//  GMSFeatureStyle.h
//  Google Maps SDK for iOS
//
//  Copyright 2022 Google LLC
//
//  Usage of this SDK is subject to the Google Maps/Google Earth APIs Terms of
//  Service: https://cloud.google.com/maps-platform/terms
//
/**
 *   This product or feature is in pre-GA. Pre-GA products and features might have limited support,
 *   and changes to pre-GA products and features might not be compatible with other pre-GA versions.
 *   Pre-GA Offerings are covered by the Google Maps Platform Service Specific Terms
 *   (https://cloud.google.com/maps-platform/terms/maps-service-terms).
 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/** Specification on the way a feature should appear when displayed on a map. */
NS_SWIFT_NAME(FeatureStyle)
@interface GMSFeatureStyle : NSObject

/** Creates a new style. */
+ (instancetype)styleWithFillColor:(nullable UIColor *)fillColor
                       strokeColor:(nullable UIColor *)strokeColor
                       strokeWidth:(CGFloat)strokeWidth
    NS_SWIFT_UNAVAILABLE("Use initializer instead");

/** Initializes a new style. */
- (instancetype)initWithFillColor:(nullable UIColor *)fillColor
                      strokeColor:(nullable UIColor *)strokeColor
                      strokeWidth:(CGFloat)strokeWidth NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_DESIGNATED_INITIALIZER NS_UNAVAILABLE;

/** Specifies the fill color, including the alpha channel. */
@property(nonatomic, readonly, nullable) UIColor *fillColor;

/** Specifies the border color, including the alpha channel. */
@property(nonatomic, readonly, nullable) UIColor *strokeColor;

/** Specifies the border width, in screen points. */
@property(nonatomic, readonly) CGFloat strokeWidth;

@end

/** Value to use for strokeWidth parameter when the stroke width should be unchanged. */
FOUNDATION_EXTERN const float GMSFeatureStyleStrokeWidthUnspecified;

NS_ASSUME_NONNULL_END
