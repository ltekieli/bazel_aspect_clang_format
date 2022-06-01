CollectedCppFilesInfo = provider(
    fields = {
        'files': 'depset of cpp files'
    }
)


def _extract_cpp_files(rule, attr):
    collected_cpp_files = []
    if hasattr(rule.attr, attr):
        for src in getattr(rule.attr, attr):
            for f in src.files.to_list():
                collected_cpp_files.append(f)
    return collected_cpp_files


def _collected_cpp_files_aspect_impl(target, ctx):
    collected_cpp_files = []
    collected_cpp_files += _extract_cpp_files(ctx.rule, 'srcs')
    collected_cpp_files += _extract_cpp_files(ctx.rule, 'hdrs')
    collected_cpp_files_deps = [dep[CollectedCppFilesInfo].files for dep in ctx.rule.attr.deps]
    return [CollectedCppFilesInfo(files = depset(collected_cpp_files, transitive=collected_cpp_files_deps))]


collected_cpp_files_aspect = aspect(
    implementation = _collected_cpp_files_aspect_impl,
    attr_aspects = ['deps'],
)


def _collect_cpp_files_impl(ctx):
    out_filename = ctx.label.name
    out = ctx.actions.declare_file("%s.txt" % out_filename)

    accumulated = []
    for dep in ctx.attr.deps:
        accumulated.append(dep[CollectedCppFilesInfo].files)

    content = ""
    for cpp_filename in depset(transitive=accumulated).to_list():
        content += "%s\n" % cpp_filename.path

    ctx.actions.write(out, content)
    return [DefaultInfo(files = depset([out]), runfiles = ctx.runfiles([out]))]


collect_cpp_files = rule(
    implementation = _collect_cpp_files_impl,
    attrs = {
        "deps": attr.label_list(
                    aspects = [collected_cpp_files_aspect],
                    providers = [CcInfo])
    },
)
