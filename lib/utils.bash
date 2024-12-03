#!/usr/bin/env bash

set -euo pipefail


ANDROID_COMMAND_LINE_TOOLS_PATH="cmdline-tools"
TOOL_NAME="android"
TOOL_TEST="${ANDROID_COMMAND_LINE_TOOLS_PATH}/bin/sdkmanager --version"

fail() {
	echo -e "asdf-$TOOL_NAME: $*"
	exit 1
}

curl_opts=(-fsSL)


sort_versions() {
	sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
		LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}


list_all_versions() {
	# this is the version of the 'asdf-android' tool itself. technically - it installs androids sdk manager from cmdlinetools but we can actually use that, to update itself...
	# mabey revert this to be the github tags in future?
	local versions=(1)

	echo "${versions[@]}"
}

download_release() {
	local version filename url platform android_sdk_root
	version="11076708"
	filename="$2"
	
	platform=$(get_platform)
	android_sdk_root=$(find_android_sdk_root)

	# Check if file already exists
	if [ -f "$filename" ]; then
		echo "* File $filename already exists, skipping download..."
		return 0
	fi

	# If sdkmanager already exists in SDK root, skip download
	if [ -n "$android_sdk_root" ] && [ -x "$android_sdk_root/$ANDROID_COMMAND_LINE_TOOLS_PATH/latest/bin/sdkmanager" ]; then
		echo "* Found existing sdkmanager in $android_sdk_root, skipping download..."
		return 0
	fi

	url="https://dl.google.com/android/repository/commandlinetools-${platform}-${version}_latest.zip"

	echo "* Downloading $TOOL_NAME release $version..."
	curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

install_command_line_tools() {
	local install_type="$1"
	local version="$2"

	local android_sdk_root=$(find_android_sdk_root)

	if [ "$install_type" != "version" ]; then
		fail "asdf-$TOOL_NAME supports release installs only"
	fi

	(

		# First check if sdkmanager exists in existing SDK installation
		local sdkmanager=""
		local cmdlinetools_version=""
		if [ -n "$android_sdk_root" ] && [ -d "$android_sdk_root/$ANDROID_COMMAND_LINE_TOOLS_PATH/latest" ]; then
			if [ -x "$android_sdk_root/$ANDROID_COMMAND_LINE_TOOLS_PATH/latest/bin/sdkmanager" ]; then
				sdkmanager="$android_sdk_root/$ANDROID_COMMAND_LINE_TOOLS_PATH/latest/bin/sdkmanager"
			fi
		fi

		#Otherwise, use sdkmanager from extracted download (download should have occured if it was unabel to locate an sdkmanager)
		if [ -z "$sdkmanager" ]; then
			sdkmanager="${ASDF_DOWNLOAD_PATH}/extracted/${ANDROID_COMMAND_LINE_TOOLS_PATH}/bin/sdkmanager"
		fi
		
		# check version of cmdline-tools
		cmdlinetools_version=$($sdkmanager --list --sdk_root=$android_sdk_root | grep "cmdline-tools;latest" | awk -F'|' '{print $2}' | tr -d ' ' | head -n1)
		
		# install cmdline-tools
		install_package "cmdline-tools;latest"

		# get installed version of cmdline-tools
		local installed_version
		installed_version=$($sdkmanager --list_installed --sdk_root=$android_sdk_root| grep "cmdline-tools;latest" | awk -F'|' '{print $2}' | tr -d ' ')
		
		# Verify cmdline-tools version matches expected version
		if [ "$installed_version" != "$cmdlinetools_version" ]; then
			echo "* Installed cmdline-tools version ($installed_version) does not match expected version ($cmdlinetools_version)"
			fail "Expected versions to match"
		fi
		

		echo "$TOOL_NAME $version installation was successful!"
	) || (
		fail "An error occurred while installing $TOOL_NAME $version."
	)

}

find_android_sdk_root() {
    # Check common Android SDK locations
    local sdk_locations=(
        "$HOME/Library/Android/sdk"           # macOS default
        "$HOME/Android/Sdk"                   # Linux default
        "${LOCALAPPDATA:-}/Android/sdk"           # Windows default
        "${ANDROID_HOME:-}"                       # Legacy env var
        "${ANDROID_SDK_ROOT:-}"                   # Current env var
    )

    for location in "${sdk_locations[@]}"; do
        if [ -d "$location" ]; then
            echo "$location"
            return 0
        fi
    done

    # Fall back to ASDF install path if no existing SDK found
    echo "${ASDF_INSTALL_PATH%/bin}"
    return 0
}

install_package() {
	local package="$1"
	android_sdk_root=$(find_android_sdk_root)
	sdkmanager="${android_sdk_root}/${ANDROID_COMMAND_LINE_TOOLS_PATH}/latest/bin/sdkmanager"

	echo "* Installing Android package: $package"
	$sdkmanager --install --sdk_root="${android_sdk_root}" $package <<< "y" 
}

# This function is only useful when using mise - in asdf it is ignored
install_additional_tools() {
	local install_path="${1%/bin}/"
	
	# Get all MISE_TOOL_OPTS__ environment variables
	local sdk_packages=()
	while IFS='=' read -r name value; do
		if [[ $name == MISE_TOOL_OPTS__* ]]; then
			# Extract the part after MISE_TOOL_OPTS__
			local package_name=${name#MISE_TOOL_OPTS__}
			# Convert to lowercase and replace _ with -
			package_name=$(echo "$package_name" | tr '[:upper:]' '[:lower:]' | tr '_' '-')
			# Add package name and version to array
			if [ "$value" = "latest" ]; then
				sdk_packages+=("$package_name")
			else
				sdk_packages+=("$package_name;$value")
			fi
		fi
	done < <(env)

	# Only install packages if there are any specified
	if [ ${#sdk_packages[@]} -gt 0 ]; then
		# Install each package using sdkmanager
		for package in "${sdk_packages[@]}"; do
			install_package "$package"
		done
	fi
}

get_platform() {
	local platform;

	case "$(uname -s)" in
		Darwin*)
			platform="mac"
			;;
		Linux*)
			platform="linux" 
			;;
		MINGW*|MSYS*|CYGWIN*)
			platform="win"
			;;
		*)
			fail "Unsupported platform: $(uname -s)"
			;;
	esac

	echo "$platform"
}