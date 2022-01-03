[![Build Check](https://github.com/kwmt/GraphQLFragmentGenerator/actions/workflows/build.yaml/badge.svg)](https://github.com/kwmt/GraphQLFragmentGenerator/actions/workflows/build.yaml)
[![unit test](https://github.com/kwmt/GraphQLFragmentGenerator/actions/workflows/unit_test.yaml/badge.svg)](https://github.com/kwmt/GraphQLFragmentGenerator/actions/workflows/unit_test.yaml)

## Development

### How to Run

```
$ cd example
$ flutter pub pub run build_runner build --delete-conflicting-outputs
```


## Deployment

1. check

```
$ flutter pub publish --dry-run
```

Need to update changelog

2. publish

```
$ flutter pub publish
```
