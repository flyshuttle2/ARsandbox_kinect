#!/usr/bin/env python
import subprocess
import os
import sys

env = SConscript("godot-cpp/SConstruct")

# For reference:
# - CCFLAGS are compilation flags shared between C and C++
# - CFLAGS are for C-specific compilation flags
# - CXXFLAGS are for C++-specific compilation flags
# - CPPFLAGS are for pre-processor flags
# - CPPDEFINES are for pre-processor defines
# - LINKFLAGS are for linking flags

# tweak this if you want to use different folders, or more folders, to store your source code in.

# 解决这个警告warning C4819: 该文件包含不能在当前代码页(936)中表示的字符。请将该文件保存为 Unicode 格式以防止数据丢失
env.Append(CPPFLAGS=["/source-charset:utf-8"])

# env.Append(CPPPATH=["src/"])
# env.Append(LIBPATH=["src/librealsense2/lib"])
# # env.Append(LIBPATH=[
# #            'D:\\Godot\\4.0\\gdextension_realsense\\src\\librealsense2\\lib'])
# env.Append(LIBS=["realsense2"])

# Kinect 路径
env.Append(
    CPPPATH=["C:/Program Files/Microsoft SDKs/Kinect/v2.0_1409/inc"])

env.Append(
    LIBPATH=["src/lib"])

# LINKFLAGS 是一个变量，用于存储链接器的选项
# env.Append(=[
#            "C:/Program Files/Microsoft SDKs/Kinect/v2.0_1409/Lib/x64/Kinect20.lib"])

env.Append(LIBS=["Kinect20"])

sources = Glob("src/*.cpp")


if env["platform"] == "macos":
    library = env.SharedLibrary(
        "app/bin/libgkinect.{}.{}.framework/libgkinect.{}.{}".format(
            env["platform"], env["target"], env["platform"], env["target"]
        ),
        source=sources,
    )
else:
    env["LINKFLAGS"] = ["-static-libgcc -static-libstdc++ -static -pthread"]
    library = env.SharedLibrary(
        # 动态库生成的路径及其文件名
        "app/bin/libgkinect{}{}".format(env["suffix"], env["SHLIBSUFFIX"]),
        source=sources,

    )

Default(library)

#!python

# 引入外部的静态库和动态库，路径，文件的路径
# import os
# import subprocess
# import sys

# opts = Variables([], ARGUMENTS)

# # Gets the standard flags CC, CCX, etc.
# # env = DefaultEnvironment()
# env = SConscript("godot-cpp/SConstruct")

# # Define our options
# opts.Add(EnumVariable('target', "Compilation target",
#          'debug', ['d', 'debug', 'r', 'release']))
# opts.AddVariables(
#     PathVariable(
#         'target_path', 'The path where the lib is installed.', 'demo/bin/'),
#     PathVariable('target_name', 'The library name.',
#                  'libkinect', PathVariable.PathAccept),
# )
# opts.Add(BoolVariable('use_llvm', "Use the LLVM / Clang compiler", 'no'))

# # Local dependency paths, adapt them to your setup
# godot_headers_path = "godot-cpp/godot_headers/"
# cpp_bindings_path = "godot-cpp/"
# cpp_library = "libgodot-cpp"

# # only support 64 at this time..
# bits = 64

# # only support windows
# platform = 'windows'

# kinectpath = os.environ['KINECTSDK20_DIR']

# # Updates the environment with the option variables.
# opts.Update(env)

# # Process some arguments
# if env['use_llvm']:
#     env['CC'] = 'clang'
#     env['CXX'] = 'clang++'

# # For the reference:
# # - CCFLAGS are compilation flags shared between C and C++
# # - CFLAGS are for C-specific compilation flags
# # - CXXFLAGS are for C++-specific compilation flags
# # - CPPFLAGS are for pre-processor flags
# # - CPPDEFINES are for pre-processor defines
# # - LINKFLAGS are for linking flags

# # Check our platform specifics
# if platform == "windows":
#     env['target_path'] += 'win64/'
#     cpp_library += '.windows'
#     # This makes sure to keep the session environment variables on windows,
#     # that way you can run scons in a vs 2017 prompt and it will find all the required tools
#     env.Append(ENV=os.environ)

#     env.Append(CPPDEFINES=['WIN32', '_WIN32',
#                '_WINDOWS', '_CRT_SECURE_NO_WARNINGS'])
#     # env.Append(CCFLAGS=['-W3', '-GR'])
#     # if env['target'] in ('debug', 'd'):
#     #     env.Append(CPPDEFINES=['_DEBUG'])
#     #     env.Append(CCFLAGS=['-EHsc', '-MDd', '-ZI'])
#     #     env.Append(LINKFLAGS=['-DEBUG'])
#     # else:
#     #     env.Append(CPPDEFINES=['NDEBUG'])
#     #     env.Append(CCFLAGS=['-O2', '-EHsc', '-MD'])

# if env['target'] in ('debug', 'd'):
#     cpp_library += '.debug'
# else:
#     cpp_library += '.release'

# cpp_library += '.' + str(bits)

# env.Append(CPPPATH=[
#     '.',
#     godot_headers_path,
#     cpp_bindings_path + 'include/',
#     cpp_bindings_path + 'include/core/',
#     cpp_bindings_path + 'include/gen/',
#     kinectpath + 'inc/'])

# print('k: %s' % kinectpath + 'inc/')
# # make sure our binding library is properly includes
# env.Append(LIBPATH=[cpp_bindings_path + 'bin/'])
# env.Append(LIBS=[cpp_library])

# env.Append(LIBPATH=[kinectpath + 'lib/x64'])
# env.Append(LINKFLAGS=['Kinect20.lib'])

# # tweak this if you want to use different folders, or more folders, to store your source code in.
# env.Append(CPPPATH=['src/'])
# sources = Glob('src/*.cpp')

# library = env.SharedLibrary(
#     target=env['target_path'] + env['target_name'], source=sources)

# Default(library)

# # Generates help for the -h scons option.
# Help(opts.GenerateHelpText(env))
