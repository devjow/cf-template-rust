# Skeletons to start with cyberfabric and modkit

You can copy/paste what's inside `Init` or use the modules from `Modules` as a base for your projects.

These templates are intended to work with [cyberfabric-cli](https://github.com/cyberfabric/cf-cli)

Check the `README.md` in each of the modules to see the architecture and how it works.

## Developing templates

Generate a project manually with `cargo generate --path Init --name my-project` or `cargo generate --path Modules/<template> --name my-module`.

Validate every template from the repo root with `bacon`. The default Bacon job fans out one validation per template from `bacon.toml`, while `scripts/validate-templates.sh` validates a single template at a time. Each validation writes generated output under `.bacon/validate-templates`, uses its own Cargo target directory there, then runs `cargo clippy --workspace --all-targets --all-features -- -D warnings` and `cargo test --workspace --all-targets --all-features` on the generated output.

If you want bacon to watch the whole repository from the root, run `bacon --watch .`.
