# Contributing to Claude Smart Memory

Thanks for your interest in improving Smart Memory. This project is intentionally
simple — pure markdown, zero dependencies — and contributions should keep it that way.

## How to Contribute

### Reporting Issues

Open an issue on GitHub with:
- What you expected to happen
- What actually happened
- Your Claude Code version (`claude --version`)
- Whether you're using the plugin install or manual setup

### Suggesting New Features

Open an issue with the `enhancement` label. Describe:
- The problem you're solving
- Your proposed approach
- Why it fits the "pure markdown, zero dependencies" philosophy

### Submitting Changes

1. Fork the repo
2. Create a branch from `main`
3. Make your changes
4. Test locally with `claude --plugin-dir ./claude-smart-memory`
5. Open a PR with a clear description

## What Makes a Good Contribution

**Yes:**
- Improved skill instructions that make Claude more reliable
- Better default templates and examples
- Bug fixes in the hook scripts
- Documentation improvements
- New shard templates for common tech stacks

**No:**
- Adding external dependencies (databases, servers, APIs)
- Features that require a build step
- Changes that break the "works with just markdown files" principle

## Development Setup

```bash
git clone https://github.com/iamadawra/claude-smart-memory.git
cd claude-smart-memory

# Test the plugin locally
claude --plugin-dir .
```

## Code Style

- Shell scripts: POSIX-compatible bash, `set -euo pipefail`
- Markdown: ATX headings, one sentence per line in paragraphs
- Keep files focused — one concern per file

## License

By contributing, you agree that your contributions will be licensed under the MIT License.
