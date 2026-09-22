#!/bin/sh
#
# Compile the Tailwind stylesheet: assets/css/tailwind.css -> static/css/tailwind.css
#
# This is the single source of truth for how the stylesheet is built. It is
# called from three places, which is why it is plain POSIX sh and works with
# either curl or wget:
#
#   * a developer's machine, via `make css`
#   * .github/workflows/pages.yml   (ubuntu-latest: bash, curl, glibc)
#   * .gitlab-ci.yml                (Alpine Hugo image: no bash, no curl, musl)
#
# Keeping the logic here means the Tailwind version is pinned once, and the two
# CI configurations cannot drift apart on how the CSS is produced.

set -eu

TAILWIND_VERSION="v4.3.3"
INPUT="assets/css/tailwind.css"
OUTPUT="static/css/tailwind.css"
BIN_DIR=".bin"
BIN="${BIN_DIR}/tailwindcss"
BASE_URL="https://github.com/tailwindlabs/tailwindcss/releases/download/${TAILWIND_VERSION}"

# --- Work out which standalone build this machine needs -----------------------
case "$(uname -s)" in
    Darwin)
        case "$(uname -m)" in
            arm64) TARGET="macos-arm64" ;;
            *)     TARGET="macos-x64" ;;
        esac
        ;;
    Linux)
        case "$(uname -m)" in
            aarch64|arm64) ARCH="arm64" ;;
            *)             ARCH="x64" ;;
        esac
        # The Hugo CI image is Alpine, which is musl. The glibc build segfaults
        # there, so pick the musl variant when musl's loader is present.
        if ls /lib/ld-musl-* >/dev/null 2>&1; then
            TARGET="linux-${ARCH}-musl"
        else
            TARGET="linux-${ARCH}"
        fi
        ;;
    *)
        echo "build-css.sh: unsupported platform $(uname -s)" >&2
        exit 1
        ;;
esac

# --- Download helper: curl locally and on GitHub, wget inside Alpine ----------
fetch() { # fetch <url> <destination>
    if command -v curl >/dev/null 2>&1; then
        curl -sfL -o "$2" "$1"
    elif command -v wget >/dev/null 2>&1; then
        wget -q -O "$2" "$1"
    else
        echo "build-css.sh: need curl or wget to download Tailwind" >&2
        exit 1
    fi
}

sha256_of() { # sha256_of <file>
    if command -v sha256sum >/dev/null 2>&1; then
        sha256sum "$1" | cut -d' ' -f1
    elif command -v shasum >/dev/null 2>&1; then
        shasum -a 256 "$1" | cut -d' ' -f1
    else
        echo ""   # no checksum tool: skip verification rather than fail the build
    fi
}

# --- Fetch the binary once, then verify it before running it -----------------
if [ ! -x "$BIN" ]; then
    mkdir -p "$BIN_DIR"
    echo "Fetching Tailwind ${TAILWIND_VERSION} (${TARGET})..."
    fetch "${BASE_URL}/tailwindcss-${TARGET}" "$BIN"

    if fetch "${BASE_URL}/sha256sums.txt" "${BIN_DIR}/sha256sums.txt" 2>/dev/null; then
        expected=$(grep "tailwindcss-${TARGET}\$" "${BIN_DIR}/sha256sums.txt" | cut -d' ' -f1)
        actual=$(sha256_of "$BIN")
        if [ -n "$expected" ] && [ -n "$actual" ] && [ "$expected" != "$actual" ]; then
            echo "build-css.sh: checksum mismatch for tailwindcss-${TARGET}" >&2
            echo "  expected $expected" >&2
            echo "  actual   $actual" >&2
            rm -f "$BIN"
            exit 1
        fi
    fi

    chmod +x "$BIN"
fi

"$BIN" -i "$INPUT" -o "$OUTPUT" --minify
