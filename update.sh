#!/bin/bash
set -eo pipefail

cd "$(dirname "$(readlink -f "$BASH_SOURCE")")"

versions=( "$@" )
if [ ${#versions[@]} -eq 0 ]; then
	versions=( */ )
fi
versions=( "${versions[@]%/}" )

packagesBase='http://apt.postgresql.org/pub/repos/apt/dists/jessie-pgdg'
mainList="$(curl -fsSL "$packagesBase/main/binary-amd64/Packages.bz2" | bunzip2)"

travisEnv=
for version in "${versions[@]}"; do
	versionList="$(echo "$mainList"; curl -fsSL "$packagesBase/$version/binary-amd64/Packages.bz2" | bunzip2)"
	fullVersion="$(echo "$versionList" | awk -F ': ' '$1 == "Package" { pkg = $2 } $1 == "Version" && pkg == "postgresql-'"$version"'" { print $2; exit }' || true)"
	(
		set -x
		cp functional "$version/"
		cp init-user-db.sh "$version/"
		sed 's/%%PG_MAJOR%%/'"$version"'/g; s/%%PG_VERSION%%/'"$fullVersion"'/g' Dockerfile.template > "$version/Dockerfile"
	)

	for variant in alpine; do
		if [ ! -d "$version/$variant" ]; then
			continue
		fi
		(
			set -x
			cp functional "$version/$variant/"
			cp init-user-db.sh "$version/$variant/"
			sed -e 's/%%PG_MAJOR%%/'"$version"'/g' \
				"Dockerfile-$variant.template" > "$version/$variant/Dockerfile"
		)
		travisEnv="\n  - VERSION=$version VARIANT=$variant$travisEnv"
	done

	travisEnv='\n  - VERSION='"$version$travisEnv"
done

travis="$(awk -v 'RS=\n' '$1 == "env:" { $0 = "env:'"$travisEnv"'" } { printf "%s%s", $0, RS }' .travis.yml)"
echo "$travis" > .travis.yml
