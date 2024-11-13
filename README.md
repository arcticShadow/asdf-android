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

- `bash`, `curl`, `unzip`, and [POSIX utilities](https://pubs.opengroup.org/onlinepubs/9699919799/idx/utilities.html).

# Install

Plugin:

```shell
#asdf
asdf plugin add android https://github.com/arcticShadow/asdf-android.git

# or, in mise
mise plugins install https://github.com/arcticShadow/asdf-android.git
```

android:

```shell
#
# ASDF
#

# Show all installable versions - becasue of the way this plugin works, there will likly only be one 
asdf list-all android

# Install specific version
asdf install android latest

# Now android commands are available
sdkmanager --version

#
# mise
#

# save the tool version to the mise config
mise use android

# Now android commands are available
sdkmanager --version
```

# How it works. 

This plugin will attempt to locate the Android SDK in a number of common locations. if _not_ found, it will download a temporary copy of cmdline-tools, and use it to setup a root sdk location.

If the Android SDK can be located on your system, this plugin will use it, and references to android tools will point to the respective sdk location.

# Install Android packages (mise only)

In mise, we can take this step further with tool options. You can specify which Android SDK packages to install in your `.mise.toml` configuration file:

```toml
[tools]
android = { build-tools = "35.0.0", platforms = "android-31" }
```


After adding packages to your tool options, run `mise install` to install the specified Android SDK packages.

You can also install packages manually using the `sdkmanager` command:

```shell
sdkmanager "platforms;android-34" "build-tools;34.0.0"
```

# other android tools
if you install the platform-tools, or build-tools - then the plugin will expose these tools in your path for you.

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/arcticShadow/asdf-android/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Cole Diffin](https://github.com/arcticShadow/)
