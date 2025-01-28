# dartpm cli tool

## Installation

Install dartpm cli tool globally using dart

```bash
dart pub global activate --source hosted --hosted-url "http://localhost:8080" dartpm
```

## Usage

### 1. Login

```bash
dartpm login
```

This will initiate login and open browser, after complete login, user can publish packages to all the users organisations.

### 2. Logout

```bash
dartpm logout
```

This will remove access from all the organisations.

### 3. Publish

```bash
dartpm publish
```

## Troubleshoot

- If you are already logged in but still not able to publish and getting error like `NO ACCESS`, try `dartpm logout` and `dartpm login` again. This will add missing organisations.

## Run locally

- Clone the repo

- Activate package globally : `dart pub global activate --source path .`

- Run command locally using : `dart run bin/dartpm.dart <Command name>`

- List global packages `dart pub global list`

- Remove global package `dart pub global deactivate dartpm`
