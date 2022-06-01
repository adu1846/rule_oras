"""Repository macros for oras"""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

load(":platforms.bzl", "OS_ARCH")

ORAS_VERSION = "0.12.0"

_BUILD_FILE_CONTENT = """
exports_files(["oras"])
"""

SHA256S = {
    "oras_0.12.0_darwin_arm64.tar.gz": "0cfb07da7c8d6ceef7a3850140c8d25bf64139b0cb3bf221fa4e7aeb0e0a1a73",
    "oras_0.12.0_darwin_amd64.tar.gz": "3637530cd3d01e2b3dc43fc4692edd36c71919726be9fdbb3b298ce0979bbabb",
    "oras_0.12.0_linux_amd64.tar.gz": "660a4ecd87414d1f29610b2ed4630482f1f0d104431576d37e59752c27de37ed",
    "oras_0.12.0_linux_arm64.tar.gz": "9e8b29529356c70f5ed88e47518d34491e3e0762615be276c8f54604fae65c00",
    "oras_0.12.0_windows_amd64.tar.gz": "bdd9a3a7fa014d0f2676fed72bba90710cd80c1ae49e73a5bfcc944ee0ac4505",
}

def oras_rules_dependencies():
    for os, arch in OS_ARCH:
        archive_format = "tar.gz"
        archive_name = "oras_{v}_{os}_{arch}.{format}".format(
            v = ORAS_VERSION,
            os = os,
            arch = arch,
            format = archive_format,
        )

        http_archive(
            name = "oras_{os}_{arch}".format(os = os, arch = arch),
            sha256 = SHA256S[archive_name],
            urls = [
                "https://github.com/oras-project/oras/releases/download/v{}/{}".format(ORAS_VERSION, archive_name),
            ],
            build_file_content = _BUILD_FILE_CONTENT,
        )

