def _oras_push_impl(ctx):
    toolchain = ctx.toolchains["@rules_oras//oras:toolchain"]
    binary = toolchain.oras_binary
    binary_file = binary.files.to_list()[0]

    output = ctx.actions.declare_file(ctx.attr.target.replace("/", "_").replace(":", "_"))

    cmd_opts = [binary_file.path]
    if ctx.attr.username:
        cmd_opts += ["-u", ctx.attr.username]
    if ctx.attr.password:
        cmd_opts += ["-p", ctx.attr.password]
    cmd_opts += ["push", ctx.attr.target]
    if ctx.attr.manifest_config:
        cmd_opts += ["--manifest-config", ctx.attr.manifest_config]
    if ctx.attr.manifest_annotations:
        cmd_opts += ["--manifest-annotations", ctx.attr.manifest_annotations]
    cmd_opts += [f.path for f in ctx.files.srcs]
    cmd_opts += ["--disable-path-validation","--insecure"]
    cmd_opts += [">", output.path]

    print(">>>>"+str(" ".join(cmd_opts),))
    ctx.actions.run_shell(
        command = " ".join(cmd_opts),
        inputs = depset(ctx.files.srcs),
        progress_message = "Upload oci artifact of %s" % ctx.attr.target,
        tools = [binary_file],
        outputs = [output],
        use_default_shell_env = True,
    )

    # file_depsets = [src.files for src in ctx.attr.srcs]
    # files = depset(transitive = file_depsets)
    # return [
    #     DefaultInfo(
    #         files = files,
    #     ),
    # ]

    return [DefaultInfo(files = depset([output]))]

oras_push = rule(
    implementation = _oras_push_impl,
    attrs = {
        "srcs": attr.label_list(
            doc = "list of files to push",
            allow_files = True,
            mandatory = True,
        ),
        "target": attr.string(
            doc = "target location to push to",
            mandatory = True,
        ),
        "manifest_config": attr.string(
            doc = "content type",
            mandatory = False,
            default = "/dev/null:application/vnd.tencent.coding.config",
        ),
        "manifest_annotations": attr.label(
            doc = "manifest annotations file",
            mandatory = False,
            allow_single_file = True,
        ),
        "username": attr.string(
            doc = "username for basic auth",
            mandatory = False,
        ),
        "password": attr.string(
            doc = "password for basic auth",
            mandatory = False,
        ),
    },
    toolchains = ["@rules_oras//oras:toolchain"],
)
