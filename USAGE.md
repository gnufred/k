# Usage

---

## Installation

1. **Download the script**
   ```bash
   curl -Lo k https://gitlab.com/gnufred/k/-/raw/main/k
   chmod +x k
   ```

2. **Move to a directory in your `$PATH`**
   ```bash
   mv k /usr/local/bin/
   ```

3. **Ensure dependencies are met**
   - Bash **version 4** or higher

---

## Usage

Once installed, you can replace calls to `kubectl` with `k`:

```bash
# Equivalent to `kubectl get pods`:
$ k get pods
# or using shorthand:
$ k g po

# Wide output + namespace:
$ k g po -W -n kube-system
# Shortcut:
$ k g po -W -n ks

# Watch mode (replaces --watch):
$ k w g no -n ks

# Clean YAML dump (removes metadata fields):
$ k get svc my-service -Z
```

### A few aliases

- **Verbs**: `g` → `get`, `d` → `describe`, `a` → `apply`, `del` → `delete`, etc.
- **Resources**: `po` → `pods`, `cm` → `configmaps`, `svc` → `services`, etc.
- **Contexts & Namespaces**: `-x`/`--context`, `-n`/`--namespace`, `-A`/`--all-namespaces`, `ks` → `kube-system`, etc.

For the full list of aliases, see the top of the `k` script.

---

## Environment Variables

| Variable    | Purpose                                    | Default              |
|-------------|--------------------------------------------|----------------------|
| `DR`        | Dry-run. Only print the `kubectl` command. | false                |
| `KMAP_FILE` | Custom kmap file location. rs)             | `$HOME/.kmap.custom` |
