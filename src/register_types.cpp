#include "register_types.h"

// #include "gdexample.h"
#include "KinectV2.h"

#include <gdextension_interface.h>
#include <godot_cpp/core/defs.hpp>
#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/godot.hpp>

using namespace godot;
// 该函数通过检查参数p_level的值来确定在哪个初始化级别下注册该类。在这个例子中，只有在场景初始化级别时才会注册该类，这意味着该类只能在场景中使用。如果初始化级别不是场景级别
void initialize_gkinect_module(ModuleInitializationLevel p_level)
{
    if (p_level != MODULE_INITIALIZATION_LEVEL_SCENE)
    {
        return;
    }
    // 在GDScript中注册一个C++类GDExample，使得GDScript可以访问并使用该类
    // register_class()函数需要传递要注册的类的类型，这里使用了模板函数register_class<>()，其参数是GDExample类的类型
    ClassDB::register_class<KinectV2>();
}

void uninitialize_gkinect_module(ModuleInitializationLevel p_level)
{
    if (p_level != MODULE_INITIALIZATION_LEVEL_SCENE)
    {
        return;
    }
}

// 这段代码用于初始化一个GDExtension绑定库，并注册一个C++类，使得GDScript可以访问该类，并使用其函数和成员变量。
// 使用extern "C"语法时，编译器会将函数名按照C语言的约定进行命名，而不会对其进行修饰，在GDScript中直接访问这些函数
extern "C"
{
    // Initialization.
    // example_library_init()，用于在GDScript中注册一个C++类，并将该类暴露给GDScript使用
    // 动态库编译后暴露给godot引擎的访问接口，就是gdextension文件中的entry_symbol的属性
    GDExtensionBool GDE_EXPORT gkinect_library_init(const GDExtensionInterface *p_interface, const GDExtensionClassLibraryPtr p_library, GDExtensionInitialization *r_initialization)
    {
        // 在我们的绑定库中调用一个函数来创建一个初始化对象init_obj
        godot::GDExtensionBinding::InitObject init_obj(p_interface, p_library, r_initialization);

        // 该对象注册了 GDExtension 的初始化和终止函数。此外，它设置初始化级别（核心、服务器、场景、编辑器、级别）（ (core, servers, scene, editor, level)）。
        // 这些函数将在绑定库的初始化和终止阶段执行，用于初始化和清理资源
        init_obj.register_initializer(initialize_gkinect_module);
        init_obj.register_terminator(uninitialize_gkinect_module);
        // 绑定库的最小初始化级别设置为MODULE_INITIALIZATION_LEVEL_SCENE，这意味着该库只能在场景初始化级别时使用
        init_obj.set_minimum_library_initialization_level(MODULE_INITIALIZATION_LEVEL_SCENE);

        // init_obj调用init()函数来初始化绑定库并返回是否成功的结果
        return init_obj.init();
    }
}