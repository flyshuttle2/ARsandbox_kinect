#include "KinectV2.h"
// 并行的库 concurrency
// 微软并行模式库(PPL)

#include <godot_cpp/variant/utility_functions.hpp>
#include <ppl.h>

const int COLOR_WIDTH = 1920;
const int COLOR_HEIGHT = 1080;
const int DEPTH_WIDTH = 512;
const int DEPTH_HEIGHT = 424;
const float DEPTH_NORMALIZE = 255.0f / 2000.f;

//const float DEPTH_MAX = 300.0f;
//const float Distance_FAR = 2000.0f;




using namespace godot;

KinectV2::KinectV2()
{
    kari = false;
    for (auto &body : _bodies)
        body = nullptr;
    UtilityFunctions::print("hello world 0 ");
    _init();
}

KinectV2::~KinectV2()
{
    _coordinate_mapper->release();
    _body_frame_source->release();
    _body_index_frame_source->release();
    _depth_frame_source->release();
    _color_frame_source->release();
    _kinect_sensor.release();
}

void KinectV2::_init()

{
    //  KinectSensorWrap _kinect_sensor;

    UtilityFunctions::print("hello world 1 ");

    _kinect_sensor.init();
    //
    _color_frame_source = _kinect_sensor.create<ColorFrameSourceWrap>();
    //这段代码创建了一个 DepthFrameSourceWrap 类型的对象，并将其赋值给 _depth_frame_source 变量

    _depth_frame_source = _kinect_sensor.create<DepthFrameSourceWrap>(); ///////

    _body_index_frame_source = _kinect_sensor.create<BodyIndexFrameSourceWrap>();
    _body_frame_source = _kinect_sensor.create<BodyFrameSourceWrap>();
    _coordinate_mapper = _kinect_sensor.create<CoordinateMapperWrap>();

    auto &color_desc = _color_frame_source->getFrameDescription();

    _color_data.resize(color_desc._bytes_per_pixel * color_desc._length_in_pixels);
    if (_color_image.is_null())
    {
        // _color_image.instance();
        _color_image.instantiate();
        _color_image->create_from_data(COLOR_WIDTH, COLOR_HEIGHT, false, Image::FORMAT_RGBA8, _color_data);
    }

    auto &depth_desc = _depth_frame_source->getFrameDescription();
    _depth_data_raw.resize(depth_desc._length_in_pixels);

    _depth_data.resize(depth_desc._length_in_pixels); /////////////////

    _depth_data_buffer.resize(depth_desc._length_in_pixels);

    if (_depth_image.is_null())
    {
        _depth_image.instantiate();
        _depth_image->create_from_data(DEPTH_WIDTH, DEPTH_HEIGHT, false, Image::FORMAT_L8, _depth_data);
    }

    _depth_space_points.resize(color_desc._length_in_pixels * 2);
    if (_depth_space_index_image.is_null())
    {
        _depth_space_index_image.instantiate();
        _depth_space_index_image->create_from_data(COLOR_WIDTH, COLOR_HEIGHT, false, Image::FORMAT_RG8, _depth_space_points);
    }

    _body_index_data.resize(depth_desc._length_in_pixels);
    if (_body_index_image.is_null())
    {
        _body_index_image.instantiate();
        _body_index_image->create_from_data(DEPTH_WIDTH, DEPTH_HEIGHT, false, Image::FORMAT_L8, _body_index_data);
    }
    UtilityFunctions::print("hello world 2 ");
}

// void KinectV2::_process(float delta)
// {
// }

//const float DEPTH_MAX = 300.0f;
//const float Distance_FAR = 2000.0f;

void KinectV2::set_parameter(int _far_distance, int _sand_maxdepth)

{
    far_distance = _far_distance;
    sand_maxdepth = _sand_maxdepth; 

}


void KinectV2::update()
{
    UtilityFunctions::print("hello world 3 ");
    UtilityFunctions::print(far_distance);
    UtilityFunctions::print(sand_maxdepth);
    auto is_update_color = _color_frame_source->update([&](IColorFrame *frame)
                                                       {
        // frame->CopyConvertedFrameDataToArray(_color_data.size(), _color_data.ptrw(), ColorImageFormat_Rgba);
        frame->CopyConvertedFrameDataToArray(_color_data.size(), _color_data.ptrw(), ColorImageFormat_Rgba);
        _color_image->create_from_data(COLOR_WIDTH, COLOR_HEIGHT, false, Image::FORMAT_RGBA8, _color_data); });

    // 这段代码使用了一个 lambda 表达式作为参数调用了 _depth_frame_source 对象的 update 方法，这个方法会从深度帧源中获取新的深度帧数据，然后将其拷贝到 _depth_data_buffer 中。
    // 调用了 frame 的 CopyFrameDataToArray 方法，将深度帧数据拷贝到 _depth_data_buffer 中
    // update 方法返回一个布尔值，表示深度帧源是否已更新。这个布尔值被保存在 is_update_depth 变量中。
    auto is_update_depth = _depth_frame_source->update([&](IDepthFrame *frame)
                                                       { frame->CopyFrameDataToArray(_depth_data_buffer.size(), _depth_data_buffer.data()); });

    UtilityFunctions::print(is_update_depth);
    auto is_update_body_index = _body_index_frame_source->update([&](IBodyIndexFrame *frame)
                                                                 {
        frame->CopyFrameDataToArray(_body_index_data.size(), _body_index_data.ptrw());
       _body_index_image->create_from_data(DEPTH_WIDTH, DEPTH_HEIGHT, false, Image::FORMAT_L8, _body_index_data); });

    auto is_update_body = _body_frame_source->update([&](IBodyFrame *frame)
                                                     {
        for (auto& body : _bodies) {
            if (body == nullptr) {
                continue;
            }
            body->Release();
            body = nullptr;
        }

        frame->GetAndRefreshBodyData(BODY_COUNT, _bodies);
        
        concurrency::parallel_for(0, BODY_COUNT, [&](int i) {
            _bodies[i]->get_IsTracked(&_is_tracked[i]);
            if (_is_tracked[i]) {
                _bodies[i]->GetJoints(JointType_Count, _joints[i]);
                _bodies[i]->GetJointOrientations(JointType_Count, _joint_orientations[i]);
            }
        }); });

    if (is_update_depth)
    {
        UtilityFunctions::print("depth updated ");
        auto depth_data_raw_ptr = _depth_data_raw.ptrw();
        auto depth_data_ptr = _depth_data.ptrw();

        concurrency::parallel_for(0, DEPTH_WIDTH * DEPTH_HEIGHT, [&](int i)
                                  {
            depth_data_raw_ptr[i] = _depth_data_buffer[i];
            //UtilityFunctions::print(depth_data_raw_ptr [i]);
            //depth_data_ptr[i] = depth_data_raw_ptr[i] * DEPTH_NORMALIZE; });
            //depth_data_ptr[i] = (far_distance - depth_data_raw_ptr[i] ) / sand_maxdepth * 255.0f; });
            //depth_data_ptr[i] = depth_data_raw_ptr[i] ; });
            //depth_data_ptr[i] = _depth_data_buffer[i] * DEPTH_NORMALIZE; });
            depth_data_ptr[i] = _depth_data_buffer[i] ; });

           //UtilityFunctions::print(depth_data_ptr[i]);

        //_depth_image->create_from_data(DEPTH_WIDTH, DEPTH_HEIGHT, false, Image::FORMAT_L8, _depth_data);
        _depth_image->create_from_data(DEPTH_WIDTH, DEPTH_HEIGHT, false, Image::FORMAT_R8, _depth_data);
        UtilityFunctions::print(_depth_data.size());

        //UtilityFunctions::print(_depth_image.get_size());

        // Heavy
        if (kari)
        {
            int color_dot_count = COLOR_WIDTH * COLOR_HEIGHT;
            std::vector<DepthSpacePoint> depth_space_points(color_dot_count);
            _coordinate_mapper->kari()->MapColorFrameToDepthSpace(
                _depth_data_buffer.size(),
                _depth_data_buffer.data(),
                color_dot_count,
                depth_space_points.data());

            auto depth_space_from = depth_space_points.data();
            auto depth_space_to = _depth_space_points.ptrw();
            concurrency::parallel_for(0, color_dot_count, [&](int base)
                                      {
                depth_space_to[base*2+0] = depth_space_from[base].X * 0.498046875;
                depth_space_to[base*2+1] = depth_space_from[base].Y * 0.6014150943396226; });

            _depth_space_index_image->create_from_data(COLOR_WIDTH, COLOR_HEIGHT, false, Image::FORMAT_RG8, _depth_space_points);
        }
        kari = !kari;
    }
    UtilityFunctions::print("hello world 4 ");
}

void KinectV2::_bind_methods()
{
    //ClassDB::bind_method(D_METHOD("_process"), &KinectV2::_process);
    ClassDB::bind_method(D_METHOD("update"), &KinectV2::update);
    ClassDB::bind_method(D_METHOD("get_color_image"), &KinectV2::get_color_image);
    ClassDB::bind_method(D_METHOD("get_depth_image"), &KinectV2::get_depth_image);
    ClassDB::bind_method(D_METHOD("get_depth_space_index_image"), &KinectV2::get_depth_space_index_image);
    ClassDB::bind_method(D_METHOD("get_body_index_image"), &KinectV2::get_body_index_image);
    ClassDB::bind_method(D_METHOD("is_tracked"), &KinectV2::is_tracked);
    ClassDB::bind_method(D_METHOD("get_tracking_state"), &KinectV2::get_tracking_state);
    ClassDB::bind_method(D_METHOD("get_joint_camera_position"), &KinectV2::get_joint_camera_position);
    ClassDB::bind_method(D_METHOD("get_joint_color_position"), &KinectV2::get_joint_color_position);
    ClassDB::bind_method(D_METHOD("get_joint_depth_position"), &KinectV2::get_joint_depth_position);
    ClassDB::bind_method(D_METHOD("get_joint_orientation"), &KinectV2::get_joint_orientation);

    ClassDB::bind_method(D_METHOD("get_depth_data"), &KinectV2::get_depth_data);
    ClassDB::bind_method(D_METHOD("get_frame_width"), &KinectV2::get_frame_width);
    ClassDB::bind_method(D_METHOD("get_frame_height"), &KinectV2::get_frame_height);

    ClassDB::bind_method(D_METHOD("set_parameter"), &KinectV2::set_parameter);

}
