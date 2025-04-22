# STYLE_GUIDE.md

This project follows the official [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html).

---

## Shebang & Safety

- Use Bash 4+:
  ```bash
  #!/usr/bin/env bash
  set -euo pipefail
  ```

## Formatting

- Indent with **2 spaces** (no tabs).
- Wrap variables in quotes: `"$var"`.
- Use `$(…)` for command substitution, not backticks.
- Collapse multiple spaces with `shfmt`:
  ```shell
  ./tools/shfmt
  ```

## 3. Linting

- Run ShellCheck with the project config:
  ```shell
  ./tools/shck
  ```
- Disable rules in `.shellcheckrc` as needed.

## 4. Testing

- Keep expansions under test with Bats in `tests/`:
  ```shell
  ./tools/tests
  ```

## 5. Contributions

- Run `./tools/*` before each PR.
- Follow existing naming conventions and avoid complex one‑liners.
- Keep functions small and focused.

---

That’s it—stay consistent and happy scripting!
