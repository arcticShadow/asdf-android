<div align="center">

# asdf-android [![Build](https://github.com/arcticShadow/asdf-android/actions/workflows/build.yml/badge.svg)](https://github.com/arcticShadow/asdf-android/actions/workflows/build.yml) [![Lint](https://github.com/arcticShadow/asdf-android/actions/workflows/lint.yml/badge.svg)](https://github.com/arcticShadow/asdf-android/actions/workflows/lint.yml)

[android](https://github.com/arcticShadow/asdf-android) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

**TODO: adapt this section**

- `bash`, `curl`, `tar`, and [POSIX utilities](https://pubs.opengroup.org/onlinepubs/9699919799/idx/utilities.html).
- `SOME_ENV_VAR`: set this environment variable in your shell config to load the correct version of tool x.

# Install

Plugin:

```shell
asdf plugin add android
# or
asdf plugin add android https://github.com/arcticShadow/asdf-android.git
```

android:

```shell
# Show all installable versions
asdf list-all android

# Install specific version
asdf install android latest

# Set a version globally (on your ~/.tool-versions file)
asdf global android latest

# Now android commands are available
sdkmanager --version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/arcticShadow/asdf-android/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Cole Diffin](https://github.com/arcticShadow/)
