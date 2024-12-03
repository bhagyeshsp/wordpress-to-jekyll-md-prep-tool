# WordPress to Jekyll Markdown Cleaner (WSL2 Friendly)

## Overview

This Ruby script is specifically designed for users working with WordPress markdown exports in a Windows Subsystem for Linux 2 (WSL2) environment. It converts exported WordPress markdown files (via [Gatsby exporter](https://wordpress.org/plugins/wp-gatsby-markdown-exporter/)) into Jekyll-ready blog post files while handling Windows and WSL2 path conversions seamlessly.

## Key Features

- Extracts YAML front matter
- Filters to specific allowed keys
- Adds 'layout: post'
- Cleans HTML content
- Renames files with date prefix
- Converts paths for WSL2 compatibility

## WSL2-specific concerns handled

- Automatically converts Windows paths (e.g., `C:\path\to\files`) to WSL2 paths (e.g., `/mnt/c/path/to/files`)
- Handles path separators (`\` to `/`)
- Supports mixed Windows and WSL2 path inputs

## Prerequisites

- Windows Subsystem for Linux 2 (WSL2)
- Ruby (version 3.0 or later recommended)
- Required gems:
  - nokogiri
  - fileutils
  - cgi
  - yaml
  - date

## Installation

1. Ensure WSL2 is set up on your Windows machine
2. Clone the repository in your WSL2 environment
3. Install required gems:
   ```bash
   gem install nokogiri fileutils
   ```

## Usage

1. Set your input and output directories in the script
   - Works with both Windows-style paths (e.g., `C:\path\to\input`)
   - Works with WSL2 paths (e.g., `/mnt/c/path/to/input`)
2. Run the script:
   ```bash
   ruby wpMdCleaner.rb
   ```

### Configuration

Modify these variables in the script:
- `input_directory`: Path to directory containing exported WordPress markdown files
- `output_directory`: Path where cleaned Jekyll-compatible files will be saved

### Path Conversion Example

The script automatically converts:
- `C:\Users\YourName\Documents\files` → `/mnt/c/Users/YourName/Documents/files`
- `D:\Blog\WordPress\exports` → `/mnt/d/Blog/WordPress/exports`

### Allowed YAML Keys
- title
- date
- status
- permalink
- author
- excerpt
- type
- id
- category
- tag
- layout

## Compatibility

- Tested with WordPress exports via Gatsby exporter
- Works with Jekyll static site generator
- Fully compatible with WSL2 environments

## Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for details.

## License

This software is licensed under the Standard [MIT License](License.txt).

## Troubleshooting WSL2 Paths

- Ensure you're using absolute paths
- Double-check drive letter mapping in WSL2
- Verify file permissions in your WSL2 environment