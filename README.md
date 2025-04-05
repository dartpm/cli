# dartpm cli tool

## Installation

Install dartpm cli tool globally using dart

```bash
dart pub global activate --source hosted --hosted-url "https://dartpm.com" dartpm
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

### 3. Add

```bash
dartpm add <package_name>
```

Add the package.

### 4. Doctor

```bash
dartpm doctor
```

### 5. Publish

Add `publish_to` in pubspec.yaml
for unscoped package : publish_to: https://dartpm.com
for scoped package: publish_to: https://dartpm.com/registry/<scope>

Scope of package is orgId or user username.

```bash
dart pub publish
```

## Troubleshoot

- If you are already logged in but still not able to publish and getting error like `NO ACCESS`, try `dartpm logout` and `dartpm login` again. This will add missing organisations.

