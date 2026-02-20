#!/usr/bin/env bash
set -euo pipefail

# Validates which components have releases on the current commit
# Outputs JSON with component build info

git fetch --tags --force

# Build list of components from manifest keys:
COMPONENTS=$(cat .release-please-manifest.json | jq -r 'keys[]')

echo "Components from manifest:"
echo "$COMPONENTS" >&2

# Build JSON array of components to publish
BUILDS=$(jq -n '[]')

for comp in $COMPONENTS; do
  # comp looks like "php-builder"
  # Find latest tag for this component (because include-component-in-tag=true):
  # tag pattern: <component>@vX.Y.Z
  latest_tag=$(git tag --list "${comp}@v*" --sort=-version:refname | head -n 1 || true)

  if [ -z "${latest_tag}" ]; then
    echo "No tag found for ${comp}, skipping." >&2
    continue
  fi

  # Only build if the latest tag points at current commit (means release happened on this push)
  tag_commit=$(git rev-list -n 1 "${latest_tag}")
  head_commit=$(git rev-parse HEAD)

  if [ "${tag_commit}" != "${head_commit}" ]; then
    echo "Latest ${comp} tag (${latest_tag}) is not on HEAD, skipping." >&2
    continue
  fi

  version="${latest_tag#${comp}@v}"   # X.Y.Z
  major="v${version%%.*}"            # vX

  echo "Validating ${comp} => version=${version}, major=${major}" >&2

  BUILDS=$(echo "$BUILDS" | jq --arg comp "$comp" --arg version "$version" --arg major "$major" \
    '. += [{"component": $comp, "version": $version, "major": $major}]')
done

# Output JSON for GitHub Actions
echo "$BUILDS"
