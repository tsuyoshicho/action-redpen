# GitHub Action: Run redpen with reviewdog

[![Docker Image CI](https://github.com/tsuyoshicho/action-redpen/workflows/Docker%20Image%20CI/badge.svg)](https://github.com/tsuyoshicho/action-redpen/actions)
[![Release](https://github.com/tsuyoshicho/action-redpen/workflows/release/badge.svg)](https://github.com/tsuyoshicho/action-redpen/releases)

This action runs [redpen](https://github.com/redpen-cc/redpen) with
[reviewdog](https://github.com/reviewdog/reviewdog) on pull requests to improve
text review experience.

based on [reviewdog/action-vint](https://github.com/reviewdog/action-vint)

![github-pr-check example](https://user-images.githubusercontent.com/96727/72157699-e4673b80-33fb-11ea-8b18-7f952cb8d4a8.png)

![github-pr-review example](https://user-images.githubusercontent.com/96727/72157708-ed580d00-33fb-11ea-8a83-ca54df7ac3e6.png)

![github-check example](https://user-images.githubusercontent.com/96727/72157719-f47f1b00-33fb-11ea-9fca-ba9274f10306.png)

## Inputs

### `github_token`

**Required**. Default is `${{ github.token }}`.

### `level`

Optional. Report level for reviewdog [info,warning,error].
It's same as `-level` flag of reviewdog.

### `reporter`

Reporter of reviewdog command [github-pr-check,github-check,github-pr-review].
Default is github-pr-review.
It's same as `-reporter` flag of reviewdog.

github-pr-review can use Markdown and add a link to rule page in reviewdog reports.

### `filter_mode`

Optional. Filtering mode for the reviewdog command [added,diff_context,file,nofilter].
Default is added.

### `fail_level`

Optional.  Exit code control for reviewdog, [none,any,info,warning,error]
Default is `none`.

### `fail_on_error`

**Deprecated.**

Optional.  Exit code for reviewdog when errors are found [true,false]
Default is `false`.

If `true` is set, it will be interpreted as "-fail-level=error".
But if "-fail-level" is set non-`none`, it will be ignored.

### `reviewdog_flags`

Optional. Additional reviewdog flags

### `basedir`

redpen target document base directory (i.e. `doc`)
Default: `.`.

### `targets`

redpen target file glob (i.e. `*.md`)
Search recursively.
Default: `*`.

### `config`

redpen config file path (i.e. `config/redpen-conf-en.xml`)
Default: `` (use redpen default rule).

## Example usage

### [.github/workflows/reviewdog.yml](.github/workflows/reviewdog.yml)

```yml
name: reviewdog
on: [pull_request]
jobs:
  redpen:
    name: runner / redpen
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
        with:
          submodules: true
      - name: redpen-github-pr-check
        uses: tsuyoshicho/action-redpen@v1
        with:
          github_token: ${{ secrets.github_token }}
          reporter: github-pr-check
          basedir: "doc"
          targets: "*.md"
          config: "config/redpen-conf-ja.xml"
      - name: redpen-github-check
        uses: tsuyoshicho/action-redpen@v1
        with:
          github_token: ${{ secrets.github_token }}
          reporter: github-check
          basedir: "doc"
          targets: "*.md"
          config: "config/redpen-conf-ja.xml"
      - name: redpen-github-pr-review
        uses: tsuyoshicho/action-redpen@v1
        with:
          github_token: ${{ secrets.github_token }}
          reporter: github-pr-review
          basedir: "doc"
          targets: "*.md"
          config: "config/redpen-conf-ja.xml"
```
