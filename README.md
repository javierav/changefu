# ChangeFu

> A command-line utility that help you to keep a good changelog.


## Table of Contents

- [Installation](#installation)
- [Getting Started](#getting-started)
- [Configuration](#configuration)
- [Available Commands](#available-commands)
- [Testing](#testing)
- [Contributing](#contributing)
- [License](#license)


## Installation

```bash
$ gem install changefu
```


## Getting Started

1. Run setup command to add the configuration to project:

    ```
    $ changefu setup
          create  changelog
          create  changelog/releases
          create  changelog/unreleased
          create  changelog/releases/.keep
          create  changelog/unreleased/.keep
          create  changelog/releases.yml
          create  .changefu.yml
    ```

2. Add a changelog entry

    ```
    $ changefu add "Fix user login" --type fixed
          create  changelog/unreleased/20200210122512_fix_user_login.yml
    ```

3. Generate the changelog

    ```
    $ changefu generate
          created  CHANGELOG.md
    ```


## Configuration

```
TODO: Write configuration guide
```


## Available Commands

```
TODO: Write list of available commands
```

### setup

```
$ changefu setup
```

### add

```
$ changefu add "Show user status in user list table" --type changed --issue 4466 --username javierav
```

### release

```
$ changefu release 1.0.0 --date 2020-02-10 --skip-generate --tag v1.0.0
```

### generate

```
$ changefu generate
```


## Testing

```
TODO: Write testing instructions
```


## Contributing

Contributions are welcome, please follow [CONTRIBUTING.md](CONTRIBUTING.md) guide.


## License

Copyright (c) 2020 Javier Aranda - Released under [MIT](LICENSE) license.
