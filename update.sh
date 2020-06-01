#!/bin/bash
set -eo pipefail

declare -A compose=(
	[debian]='debian'
	[ol]='ol'
)

declare -A base=(
	[debian]='debian'
	[ol]='ol'
)

declare -A variant_version=(
	[debian]='10'
	[ol]='7'
)

variants=(
	debian
	ol
)

min_version='2'


# version_greater_or_equal A B returns whether A >= B
function version_greater_or_equal() {
	[[ "$(printf '%s\n' "$@" | sort -V | head -n 1)" != "$1" || "$1" == "$2" ]];
}

dockerRepo="monogramm/docker-bitnami-jenkins"
# Retrieve automatically the latest versions
latests=( $( curl -fsSL 'https://api.github.com/repos/bitnami/bitnami-docker-jenkins/tags' |tac|tac| \
	grep -oE '[[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+' | \
	sort -urV ) )

# Remove existing images
echo "reset docker images"
find ./images -maxdepth 1 -type d -regextype sed -regex '\./images/[[:digit:]]\+' -exec rm -r '{}' \;
#rm -rf ./images/*

echo "update docker images"
travisEnv=
for latest in "${latests[@]}"; do
	version=$(echo "$latest" | cut -d. -f1)

	# Only add versions >= "$min_version"
	if version_greater_or_equal "$version" "$min_version"; then

		if [ -d "images/$version" ]; then
			continue
		fi

		for variant in "${variants[@]}"; do
			echo "Updating $latest [$version-$variant]"

			# Create the version directory with a Dockerfile.
			dir="images/$version/$variant"
			mkdir -p "$dir"

			template="Dockerfile.${base[$variant]}.template"
			cp "template/$template" "$dir/Dockerfile"

			# Replace the variables.
			sed -ri -e '
				s/%%VARIANT%%/'"$variant-${variant_version[$variant]}"'/g;
				s/%%VERSION%%/'"$version"'/g;
			' "$dir/Dockerfile"

			cp "template/.dockerignore" "$dir/.dockerignore"
			cp -r "template/hooks" "$dir/hooks"
			cp -r "template/test" "$dir/"
			cp "template/.env" "$dir/.env"
			cp "template/docker-compose_${compose[$variant]}.yml" "$dir/docker-compose.test.yml"

			travisEnv='\n    - VERSION='"$version"' VARIANT='"$variant$travisEnv"

			if [[ $1 == 'build' ]]; then
				tag="$version-$variant"
				echo "Build Dockerfile for ${tag}"
				docker build -t "${dockerRepo}:${tag}" "${dir}"
			fi
		done
	fi

done

# update .travis.yml
travis="$(awk -v 'RS=\n\n' '$1 == "env:" && $2 == "#" && $3 == "Environments" { $0 = "env: # Environments'"$travisEnv"'" } { printf "%s%s", $0, RS }' .travis.yml)"
echo "$travis" > .travis.yml
