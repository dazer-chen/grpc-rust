#!/bin/sh -e

set -ex

export PROTOBUF_VERSION=3.1.0

rustc --version

export RUST_BACKTRACE=1

ci/install-protobuf.sh

if test "$ACTION" = "test-protoc-plugin"; then
    (
        cargo install protobuf-codegen

        cd grpc-compiler/test-protoc-plugin

        ./gen.sh

        cargo check --all
    )
else
    cargo test --all --all-targets

    # `--all-targets` does not include doctests
    # https://github.com/rust-lang/cargo/issues/6669
    cargo test --doc

    # Check the docs
    cargo doc
fi

# vim: set ts=4 sw=4 et:
