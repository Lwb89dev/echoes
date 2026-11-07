# Arch Linux package

Two recipes, one package name (`echoes`). Neither is in the official Arch or Arch Linux ARM repositories. A name search on archlinux.org on 2026-11-07 returned no package named `echoes`. If that name is taken later, rename both recipes to `echoes-nostr`.

The package installs:

- the Flutter bundle under `/usr/lib/echoes`
- `/usr/bin/echoes`, which execs that binary so the process does not depend on the current directory
- a desktop entry and hicolor icons

It does not install an autostart entry. The Debian package does; that package is unchanged. Removing this package deletes only the `/usr` files. Notes in Hive and credentials in the Secret Service stay in the home directory.

## Source build

`PKGBUILD` builds from the clone that contains it. Flutter must already be on `PATH`. The recipe does not download an SDK.

The host CPU and `CARCH` must match. Flutter's Linux desktop build does not cross-compile, and the recipe refuses to pretend that it does. Before installing, it checks that every ELF in the bundle is the architecture being packaged.

```bash
cd packaging/arch
makepkg -sf
```

## Prebuilt AArch64 bundle

`echoes-bin/PKGBUILD` packs a tarball produced by `scripts/build-linux-aarch64.sh` or by the `linux-aarch64` CI job. It does not compile and it does not fetch a GitHub release. No AArch64 tarball is published yet, so the recipe has no checksum of its own. `prepare` runs `sha256sum -c` on the `.sha256` file that sits next to the tarball. Replace `COMMIT` in `_tarball` with the commit id from the artifact name.

```bash
cp dist/echoes-linux-aarch64-*.tar.gz packaging/arch/echoes-bin/
cp dist/echoes-linux-aarch64-*.tar.gz.sha256 packaging/arch/echoes-bin/
# edit _tarball in packaging/arch/echoes-bin/PKGBUILD
cd packaging/arch/echoes-bin
makepkg -sf
```

`sha256sums` for that tarball stays `SKIP`. Do not paste a guessed hash into the recipe. The `.sha256` file is the checksum.
