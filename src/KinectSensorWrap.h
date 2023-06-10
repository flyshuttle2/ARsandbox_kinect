#ifndef _KINECT_SENSOR_WRAP_H_
#define _KINECT_SENSOR_WRAP_H_

#include "Kinect.h"
#include <memory>
class KinectSensorWrap
{
public:
    KinectSensorWrap() : _kinect_sensor(nullptr) {}
    ~KinectSensorWrap() {}

    void init()
    {
        // 使用 GetDefaultKinectSensor 函数获取默认的 Kinect V2 传感器。如果获取失败，函数直接返回。如果获取成功，将返回一个 IKinectSensor 接口的指针，表示获取到的 Kinect V2 传感器。
        if (FAILED(GetDefaultKinectSensor(&_kinect_sensor)))
        {
            return;
        }
        // 检查获取到的 Kinect V2 传感器是否已经打开。如果没有打开，调用 _kinect_sensor 对象的 Open 方法，打开传感器。在这里，Open 方法是通过 IKinectSensor 接口实现的，用于打开 Kinect V2 传感器。
        BOOLEAN is_open = false;
        _kinect_sensor->get_IsOpen(&is_open);
        if (!is_open)
        {
            _kinect_sensor->Open();
        }
    }

    void release()
    {
        if (!_kinect_sensor)
        {
            return;
        }
        BOOLEAN is_open = false;
        _kinect_sensor->get_IsOpen(&is_open);
        if (is_open)
        {
            _kinect_sensor->Close();
        }
        _kinect_sensor->Release();
        _kinect_sensor = nullptr;
    }

    template <class T>
    std::unique_ptr<T> create() const
    {
        auto instance = std::make_unique<T>();
        instance->init(_kinect_sensor);
        return std::move(instance);
    }

private:
    IKinectSensor *_kinect_sensor;
};

#endif
