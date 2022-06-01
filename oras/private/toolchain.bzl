load(":platforms.bzl", "OS_ARCH", "BAZEL_ARCH_CONSTRAINTS", "BAZEL_OS_CONSTRAINTS")

def _oras_toolchain_impl(ctx):
    toolchain_info = platform_common.ToolchainInfo(
        name = ctx.label.name,
        oras_binary = ctx.attr.oras_binary,
    )
    return [toolchain_info]

oras_toolchain = rule(
    implementation = _oras_toolchain_impl,
    attrs = {
        "oras_binary": attr.label(
            mandatory = True,
            cfg = "exec",
            executable = True,
            allow_single_file = True,
        ),
    },
)

def oras_register_toolchains():
    for os, arch in OS_ARCH:
        native.register_toolchains("@rules_oras//oras/toolchains:oras_{}_{}_toolchain".format(os, arch))


def declare_toolchains():
    for os, arch in OS_ARCH:
        oras_toolchain(
            name = "oras_{}_{}".format(os, arch),
            oras_binary = Label("@oras_{}_{}//:oras".format(os, arch)),
        )

        constraints = (
            BAZEL_OS_CONSTRAINTS[os],
            BAZEL_ARCH_CONSTRAINTS[arch],
        )

        native.toolchain(
            name = "oras_{}_{}_toolchain".format(os, arch),
            exec_compatible_with = constraints,
            target_compatible_with = constraints,
            toolchain = ":oras_{}_{}".format(os, arch),
            toolchain_type = "@rules_oras//oras:toolchain",
        )
