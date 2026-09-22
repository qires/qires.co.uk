#!/usr/bin/env python3
"""Re-download the self-hosted Inter subsets from Google Fonts.

The site serves Inter from its own origin so that viewing a page sends no
request to a third party. This script fetches the current woff2 files and
regenerates static/css/fonts.css. Run it with `make fonts`.

Inter is licensed under the SIL Open Font License 1.1, which permits
redistribution; static/fonts/LICENSE.txt travels with the files.
"""

import os
import re
import urllib.request

# en-GB site: the Latin subsets are all that is needed.
SUBSETS = ("latin", "latin-ext")
FAMILY_URL = "https://fonts.googleapis.com/css2?family=Inter:wght@400..800&display=swap"
UA = (
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 "
    "(KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36"
)
FONT_DIR = "static/fonts"
CSS_PATH = "static/css/fonts.css"

HEADER = """/* Inter, self-hosted.
   Variable weight 400-800, Latin subsets only (this is an en-GB site).
   Downloaded from Google Fonts so that no visitor request reaches a third
   party. Inter is licensed under the SIL Open Font License 1.1 — see
   static/fonts/LICENSE.txt.
   Regenerate with: make fonts */
"""


def main():
    # A modern User-Agent is required, or Google returns truetype rather than woff2.
    req = urllib.request.Request(FAMILY_URL, headers={"User-Agent": UA})
    css = urllib.request.urlopen(req).read().decode("utf-8")

    blocks = re.findall(r"/\*\s*([a-z-]+)\s*\*/\s*(@font-face\s*\{.*?\})", css, re.S)
    if not blocks:
        raise SystemExit("No @font-face blocks found — has the Google Fonts API changed?")

    os.makedirs(FONT_DIR, exist_ok=True)
    faces = [HEADER]
    written = 0

    for subset, block in blocks:
        if subset not in SUBSETS:
            continue
        url = re.search(r"url\((https://[^)]+)\)", block).group(1)
        name = f"inter-{subset}.woff2"
        urllib.request.urlretrieve(url, os.path.join(FONT_DIR, name))
        size = os.path.getsize(os.path.join(FONT_DIR, name))
        print(f"  {name}  {size / 1024:.1f} KB")
        unicode_range = re.search(r"unicode-range:\s*([^;]+);", block).group(1).strip()
        # Relative URL: the site may be served from a subpath on GitHub Pages.
        faces.append(
            f"""
/* {subset} */
@font-face {{
  font-family: 'Inter';
  font-style: normal;
  font-weight: 400 800;
  font-display: swap;
  src: url('../fonts/{name}') format('woff2');
  unicode-range: {unicode_range};
}}"""
        )
        written += 1

    if written != len(SUBSETS):
        raise SystemExit(f"Expected {len(SUBSETS)} subsets, wrote {written}")

    with open(CSS_PATH, "w") as fh:
        fh.write("\n".join(faces) + "\n")
    print(f"  wrote {CSS_PATH}")


if __name__ == "__main__":
    main()
