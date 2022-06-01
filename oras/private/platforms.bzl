BAZEL_OS_CONSTRAINTS = {
    "linux": "@platforms//os:linux",
    "darwin": "@platforms//os:osx",
    "windows": "@platforms//os:windows",
}

BAZEL_ARCH_CONSTRAINTS = {
    "amd64": "@platforms//cpu:x86_64",
    "arm64": "@platforms//cpu:aarch64",
}

OS_ARCH = (
    ("darwin", "amd64"),
    ("linux", "amd64"),
    ("linux", "arm64"),
    ("windows", "amd64"),
)
