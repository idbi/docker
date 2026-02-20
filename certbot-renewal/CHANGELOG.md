# Changelog

## [0.2.0](https://github.com/idbi/docker/compare/certbot-renewal@v0.1.0...certbot-renewal@v0.2.0) (2026-02-20)


### Features

* initial release ([b4db9d2](https://github.com/idbi/docker/commit/b4db9d2bd0ccf80c2f34b3b42231480b64ecbac8))

## [1.1.0](https://github.com/idbi/docker/compare/v1.0.0...v1.1.0) (2026-02-20)


### Features

* add automated Certbot renewal with Vault upload as Docker image ([4e66bf0](https://github.com/idbi/docker/commit/4e66bf0a9099277c26d6c39e2c44c0e444d18c0c))
* add coreutils to Docker image dependencies ([9cdbd4d](https://github.com/idbi/docker/commit/9cdbd4d3709e8e1343ace7808bf6c5fdafff58ec))
* add logging to entrypoint and update cronjob for otel integration ([6a118ef](https://github.com/idbi/docker/commit/6a118ef88683b9d70d8921553d084cdcdd467304))


### Bug Fixes

* correct log file path to ensure proper logging ([83b1a58](https://github.com/idbi/docker/commit/83b1a5813128f368efa766e683b8a424b5efbf0d))
* correct logging function export in entrypoint script ([235dddd](https://github.com/idbi/docker/commit/235dddd752391a6cfd035d21b53801b7001f34b1))
* update certbot-renewal Docker entrypoint to ensure script completion ([b52f0f3](https://github.com/idbi/docker/commit/b52f0f350f8646b1ce36c9313df5ce81d439b119))
* update Dockerfile to include non-sh scripts in scripts directory ([7750f0d](https://github.com/idbi/docker/commit/7750f0de18f3a611a94fbb95c41b731ac93cb3b3))
* update entrypoint to remove unnecessary sleep command ([724cbb0](https://github.com/idbi/docker/commit/724cbb08d446e344265c4373a8855bc8ceff683d))
* update script paths for proper execution in container ([73de374](https://github.com/idbi/docker/commit/73de374a8468446241decc9c719afc93539fff2d))
