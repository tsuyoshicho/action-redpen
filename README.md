# GitHub Action: Run redpen with reviewdog

[![Docker Image CI](https://github.com/tsuyoshicho/action-redpen/workflows/Docker%20Image%20CI/badge.svg)](https://github.com/tsuyoshicho/action-redpen/actions)
[![Release](https://github.com/tsuyoshicho/action-redpen/workflows/release/badge.svg)](https://github.com/tsuyoshicho/action-redpen/releases)
[![DeepWiki](https://img.shields.io/badge/DeepWiki-tsuyoshicho%2Faction--redpen-blue.svg?logo=data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACwAAAAyCAYAAAAnWDnqAAAAAXNSR0IArs4c6QAAA05JREFUaEPtmUtyEzEQhtWTQyQLHNak2AB7ZnyXZMEjXMGeK/AIi+QuHrMnbChYY7MIh8g01fJoopFb0uhhEqqcbWTp06/uv1saEDv4O3n3dV60RfP947Mm9/SQc0ICFQgzfc4CYZoTPAswgSJCCUJUnAAoRHOAUOcATwbmVLWdGoH//PB8mnKqScAhsD0kYP3j/Yt5LPQe2KvcXmGvRHcDnpxfL2zOYJ1mFwrryWTz0advv1Ut4CJgf5uhDuDj5eUcAUoahrdY/56ebRWeraTjMt/00Sh3UDtjgHtQNHwcRGOC98BJEAEymycmYcWwOprTgcB6VZ5JK5TAJ+fXGLBm3FDAmn6oPPjR4rKCAoJCal2eAiQp2x0vxTPB3ALO2CRkwmDy5WohzBDwSEFKRwPbknEggCPB/imwrycgxX2NzoMCHhPkDwqYMr9tRcP5qNrMZHkVnOjRMWwLCcr8ohBVb1OMjxLwGCvjTikrsBOiA6fNyCrm8V1rP93iVPpwaE+gO0SsWmPiXB+jikdf6SizrT5qKasx5j8ABbHpFTx+vFXp9EnYQmLx02h1QTTrl6eDqxLnGjporxl3NL3agEvXdT0WmEost648sQOYAeJS9Q7bfUVoMGnjo4AZdUMQku50McDcMWcBPvr0SzbTAFDfvJqwLzgxwATnCgnp4wDl6Aa+Ax283gghmj+vj7feE2KBBRMW3FzOpLOADl0Isb5587h/U4gGvkt5v60Z1VLG8BhYjbzRwyQZemwAd6cCR5/XFWLYZRIMpX39AR0tjaGGiGzLVyhse5C9RKC6ai42ppWPKiBagOvaYk8lO7DajerabOZP46Lby5wKjw1HCRx7p9sVMOWGzb/vA1hwiWc6jm3MvQDTogQkiqIhJV0nBQBTU+3okKCFDy9WwferkHjtxib7t3xIUQtHxnIwtx4mpg26/HfwVNVDb4oI9RHmx5WGelRVlrtiw43zboCLaxv46AZeB3IlTkwouebTr1y2NjSpHz68WNFjHvupy3q8TFn3Hos2IAk4Ju5dCo8B3wP7VPr/FGaKiG+T+v+TQqIrOqMTL1VdWV1DdmcbO8KXBz6esmYWYKPwDL5b5FA1a0hwapHiom0r/cKaoqr+27/XcrS5UwSMbQAAAABJRU5ErkJggg==)](https://deepwiki.com/tsuyoshicho/action-redpen)
<!-- DeepWiki badge generated by https://deepwiki.ryoppippi.com/ -->

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
