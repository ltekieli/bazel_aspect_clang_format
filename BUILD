load("@bazel_skylib//rules:common_settings.bzl", "bool_flag")
load("//bazel/tools/clang_format:clang_format.bzl", "clang_format")


bool_flag(
    name = "use_main_2",
    build_setting_default = False,
)


config_setting(
    name = "use_main_2_setting",
    flag_values = {
        ":use_main_2": "True",
    },
)


cc_binary(
    name = "hello",
    srcs =
        select({
            ":use_main_2_setting": ["main2.cpp"],
            "//conditions:default": ["main.cpp"]
        }),
    deps = ["//lib/log"],
)


# Note! Needs needs to be the last declaration in the file
# in order to correctly pick up earlier declared cc_* rules.
clang_format()
