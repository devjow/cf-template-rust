#!/usr/bin/env bash

set -euo pipefail

slugify() {
    printf '%s' "$1" | tr '[:upper:]' '[:lower:]' | sed -E 's#[^a-z0-9]+#-#g; s#(^-|-$)##g'
}

state_root="${VALIDATE_TEMPLATES_STATE_ROOT:-.bacon/validate-templates}"
target_root="${VALIDATE_TEMPLATES_TARGET_ROOT:-${CARGO_TARGET_DIR:-$state_root/target}}"

if (($# != 1)); then
    echo "usage: $0 <template-dir>" >&2
    exit 1
fi

template_dir=$1
project_name="generated-$(slugify "$template_dir")"
project_root="$state_root/$project_name"
manifest_path="$project_root/Cargo.toml"
template_target_dir="$target_root/$(slugify "$template_dir")"

mkdir -p "$project_root" "$template_target_dir"
find "$project_root" -mindepth 1 -maxdepth 1 -exec rm -rf {} +

echo "==> Validating $template_dir"
cargo generate --path "$template_dir" --destination "$project_root" --name "$project_name" --silent --vcs none --overwrite --init >/dev/null
CARGO_TARGET_DIR="$template_target_dir" cargo clippy --manifest-path "$manifest_path" --workspace --all-targets --all-features -- -D warnings
CARGO_TARGET_DIR="$template_target_dir" cargo test --manifest-path "$manifest_path" --workspace --all-targets --all-features
echo "==> Passed $template_dir"
