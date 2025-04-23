# `k`

A `kubectl` wrapper for [Infinite Monkeys](https://en.wikipedia.org/wiki/Infinite_monkey_theorem) randomly rewriting the Internet.

Actually, a lightweight Bash script that provides shorthand aliases for `kubectl` commands, resources, and options.

It saves you **a ton of typing** — and maybe even a few keystroke-induced rage quits.

You can **download it**, add it to your `$PATH`, or alias it directly in your shell config.

➡️ Check the [script itself](k) for the full list of supported aliases.

---

## 🔧 Example Usage

```bash
$ k g po -W -n ks
NAME                          READY   STATUS    RESTARTS      AGE    IP          NODE   NOMINATED NODE   READINESS GATES
coredns-76f75df574-gdkxc      1/1     Running   2 (13m ago)   114m   10.88.0.6   cp0    <none>           <none>
...
```

```bash
$ k g no -N
node/cp0
...
```

---

## 👀 Watch It!

I prefer using `watch -n1` over the default `--watch`, so there's a **special alias** just for that:

```bash
$ k w g po -n ks
Every 1.0s: kubectl get pods --namespace kube-system

NAME                          READY   STATUS    RESTARTS   AGE
coredns-76f75df574-dmhwv      1/1     Running   0          2m11s
etcd-cp0                      1/1     Running   0          2m11s
...
```

Use `w` at the beginning of your command and it'll auto-wrap with `watch -n1`.

---

## 🗂️ Custom Aliases with `.kmap.custom`

You can extend `k` with your own custom aliases for things like:

- Kubernetes contexts (`-x`)
- Namespaces (`-n`)
- Resource types or CRDs
- Shorthand commands

Just create a file at:

```bash
~/.kmap.custom
```

Use simple `key=value` pairs, one per line:

```ini
# ~/.kmap.custom

# Context aliases
mlc=my-local-cluster
gcc=google-cloud-cluster
mwc=microsoft-windows-cluster

# Custom resources
db=databases.mycompany.io
svc=services

# Namespace shortcuts
ks=kube-system
df=default
```

These entries are **automatically loaded** every time `k` runs — no restart or reload required.

### 🧪 Example

```bash
$ k -x mlc g po -n df -W
kubectl --context my-local-cluster get pods --namespace default -o wide
...
```

You can modify the file at any time to add or change aliases. It's your own `kubectl` booster pack.

---

## 🙌 Contribute

Fork it. Copy it. Bash it. Rewrite it in Rust if you want.

If your customizations might be useful to others, feel free to [open an issue](https://github.com/gnufred/k/issues) or submit a [pull request](https://github.com/gnufred/k/pulls).

---

## 🪪 License

This project is licensed under [The Unlicense](https://unlicense.org) — public domain, no strings attached.
