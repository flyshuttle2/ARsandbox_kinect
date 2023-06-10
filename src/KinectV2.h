#ifndef _KINECT_V2_H_
#define _KINECT_V2_H_

// 头文件的路径
// 根据头文件的路径，看用了哪些文件和静态库lib,动态库dll,头文件和动态库直接拖到项目中，dll在生成的dll目录下
#include <godot_cpp/classes/node.hpp>
#include <godot_cpp/godot.hpp>
#include <godot_cpp/classes/image.hpp>
#include <godot_cpp/core/class_db.hpp>

#include <godot_cpp/classes/ref_counted.hpp>
#include <godot_cpp/variant/quaternion.hpp>
#include <vector>

// 下面是自己变编写的
#include "KinectSensorWrap.h"

#include "ColorFrameSourceWrap.h"
#include "DepthFrameSourceWrap.h"
#include "BodyIndexFrameSourceWrap.h"
#include "BodyFrameSourceWrap.h"
#include "CoordinateMapperWrap.h"
namespace godot
{
    //  Reference 在4.0中是RefCounted
    class KinectV2 : public RefCounted
    {
        GDCLASS(KinectV2, RefCounted)
    public:
        static void _bind_methods();

        KinectV2();
        ~KinectV2();

        void _init(); // our initializer called by Godot
        //void _process(float delta);
        //六个参数：起点X坐标偏移，起点Y坐标偏移，X方向长度，Y方向宽度，探测最远深度，沙体最大高度;
        void update();

        void set_parameter(int, int);


        godot::Ref<godot::Image> get_color_image() const { return _color_image; }
        godot::Ref<godot::Image> get_depth_image() const { return _depth_image; }
        godot::Ref<godot::Image> get_depth_space_index_image() const { return _depth_space_index_image; }
        godot::Ref<godot::Image> get_body_index_image() const { return _body_index_image; }


        //godot::PackedByteArray get_depth_data() const { return _depth_data; }
        godot::PackedInt32Array get_depth_data() const { return _depth_data_raw; }




        int get_frame_width() const { return 512; }
        int get_frame_height() const { return 424; }










        bool is_tracked(int index)
        {
            if (unsigned(short(index)) >= BODY_COUNT)
            {
                return false;
            }
            return _is_tracked[index];
        }

        int get_tracking_state(int body_index, int joint_index)
        {
            if (unsigned(short(body_index)) >= BODY_COUNT)
            {
                return TrackingState_NotTracked;
            }
            if (unsigned(short(joint_index)) >= JointType_Count)
            {
                return TrackingState_NotTracked;
            }
            return _joints[body_index][joint_index].TrackingState;
        }

        godot::Vector3 get_joint_camera_position(int body_index, int joint_index)
        {
            if (unsigned(short(body_index)) >= BODY_COUNT)
            {
                return godot::Vector3();
            }
            if (unsigned(short(joint_index)) >= JointType_Count)
            {
                return godot::Vector3();
            }
            auto pos = _joints[body_index][joint_index].Position;
            return godot::Vector3(pos.X, pos.Y, pos.Z);
        }

        godot::Vector2 get_joint_color_position(int body_index, int joint_index)
        {
            if (unsigned(short(body_index)) >= BODY_COUNT)
            {
                return godot::Vector2();
            }
            if (unsigned(short(joint_index)) >= JointType_Count)
            {
                return godot::Vector2();
            }
            ColorSpacePoint pos;
            _coordinate_mapper->kari()->MapCameraPointToColorSpace(_joints[body_index][joint_index].Position, &pos);
            return godot::Vector2(pos.X, pos.Y);
        }

        godot::Vector2 get_joint_depth_position(int body_index, int joint_index)
        {
            if (unsigned(short(body_index)) >= BODY_COUNT)
            {
                return godot::Vector2();
            }
            if (unsigned(short(joint_index)) >= JointType_Count)
            {
                return godot::Vector2();
            }
            DepthSpacePoint pos;
            _coordinate_mapper->kari()->MapCameraPointToDepthSpace(_joints[body_index][joint_index].Position, &pos);
            return godot::Vector2(pos.X, pos.Y);
        }
        // Quat 变成了 Quaternion
        godot::Quaternion get_joint_orientation(int body_index, int joint_index)
        {
            if (unsigned(short(body_index)) >= BODY_COUNT)
            {
                return godot::Quaternion();
            }
            if (unsigned(short(joint_index)) >= JointType_Count)
            {
                return godot::Quaternion();
            }
            auto pos = _joint_orientations[body_index][joint_index].Orientation;
            return godot::Quaternion(pos.x, pos.y, pos.z, pos.w);
        }

    private:
        KinectSensorWrap _kinect_sensor;
        std::unique_ptr<ColorFrameSourceWrap> _color_frame_source;
        std::unique_ptr<DepthFrameSourceWrap> _depth_frame_source;
        std::unique_ptr<BodyIndexFrameSourceWrap> _body_index_frame_source;
        std::unique_ptr<BodyFrameSourceWrap> _body_frame_source;
        std::unique_ptr<CoordinateMapperWrap> _coordinate_mapper;

        godot::PackedByteArray _color_data;
        godot::Ref<godot::Image> _color_image;

        std::vector<UINT16> _depth_data_buffer;
        //godot::PackedByteArray _depth_data_raw;
        //godot::PackedByteArray _depth_data;
        godot::PackedInt32Array  _depth_data_raw;
        godot::PackedByteArray  _depth_data;


        godot::Ref<godot::Image> _depth_image;

        godot::PackedByteArray _depth_space_points;
        godot::Ref<godot::Image> _depth_space_index_image;

        godot::PackedByteArray _body_index_data;
        godot::Ref<godot::Image> _body_index_image;

        IBody *_bodies[BODY_COUNT];
        BOOLEAN _is_tracked[BODY_COUNT];
        Joint _joints[BODY_COUNT][JointType_Count];
        JointOrientation _joint_orientations[BODY_COUNT][JointType_Count];

        bool kari;


        int far_distance;
        int sand_maxdepth; 









    };
}
#endif
