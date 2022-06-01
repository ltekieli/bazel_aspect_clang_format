load(":collect_cpp_files.bzl", "collect_cpp_files")


def clang_format(name="empty"):
    if "clang_format" in native.existing_rules():
        fail("clang_format rule already defined")

    deps = []
    for rule_name, rule in native.existing_rules().items():
        if rule["kind"] in ["cc_binary", "cc_library"]:
            deps.append(rule_name)

    collect_cpp_files(
        name = "clang_format_cpp_files",
        deps = deps
    )

    native.py_binary(
        name = "clang_format",
        srcs = ["//bazel/tools/clang_format:clang_format_runner.py"],
        main = "clang_format_runner.py",
        args = [
            "$(location :clang_format_cpp_files)",
        ],
        data = [":clang_format_cpp_files"]
    )
