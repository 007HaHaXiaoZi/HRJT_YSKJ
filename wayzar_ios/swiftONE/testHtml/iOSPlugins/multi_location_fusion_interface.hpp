
#pragma once
#include <string>
#import <Foundation/Foundation.h>

#define EXPORT_API  // XCode does not need annotating exported functions, so
                    // define is empty

extern "C" {

/**
 *@brief for accessibility testing
 * */
EXPORT_API int dummy(int x, int y);

/**
 * @brief initialize fusion system
 **/
EXPORT_API bool init_system(std::string log_path);

/**
 *
 * */
typedef void (*LogCallback)(const char*);
EXPORT_API void logs_callback(LogCallback log_callback);

/**
 * @brief feed global position by VPS(visual positioning system)
 * @param src_position position(xyz ordered), yield by VIO
 * @param src_orientation attitude(xyz ordered), yield by VIO
 * @param dst_position yield by VPS, time synced with source data
 * @param dst_orientation yield by VPS, time synced with source data
 * @param is_android_device if android, unity camera rotate 90-degrees by z-axis to align with vps camera, but ios not
 *need
 * @param sync_calculation calculate it when data inserted, otherwise, decided by calculation thread
 *
 **/
EXPORT_API bool feed_location_pair(const double* src_position,
                                   const double* src_orientation,
                                   const double* dst_position,
                                   const double* dst_orientation,
                                   const bool is_android_device,
                                   const bool sync_calculation = true);

/**
 * @brief get realtime pose of dest frame
 * @param src_position position(xyz ordered)
 * @param src_orientation attitude(xyzw ordered)
 * @param dst_position position return
 * @param dst_orientation quaternion return
 **/
EXPORT_API bool get_realtime_transform(const double* src_position,
                                       const double* src_orientation,
                                       double* dst_position,
                                       double* dst_orientation);

/**
 * @brief set callback function to receive fusion result
 *
 *
 **/
#pragma pack(push, 1)
struct FusionStatus {
public:
    FusionStatus() :
        valid(false),
        latest_is_outliner(false),
        latest_translation{0.},
        latest_rotation{0.},
        translation_src2dst{0.},
        quaternion_src2dst{0., 0., 0., 1.},
        rotation_scale(1.0)
    {}

public:
    bool valid;
    bool latest_is_outliner;
    double latest_translation[3];
    double latest_rotation[4];
    double translation_src2dst[3];
    double quaternion_src2dst[4];
    double rotation_scale;
};
#pragma pack(pop)

typedef void (*StatusCallback)(const FusionStatus);
EXPORT_API void status_callback(StatusCallback status_callback);
}
