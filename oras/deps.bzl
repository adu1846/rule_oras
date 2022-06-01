load(
    "@rules_oras//oras/private:repositories.bzl",
    _oras_rules_dependencies = "oras_rules_dependencies",
)

load(
    "@rules_oras//oras/private:toolchain.bzl",
    _oras_register_toolchains = "oras_register_toolchains",
)

oras_rules_dependencies = _oras_rules_dependencies
oras_register_toolchains = _oras_register_toolchains
