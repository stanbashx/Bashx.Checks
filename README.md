# Checks
A few checks scripts.

---

## Release

`0.0.1`
| [GitHub](https://github.com/StanleyProjects/Checks/releases/tag/0.0.1)
| [Key](https://StanleyProjects.github.io/release-public.pem)

### Build and Install

```
$ ./assemble.sh \
 && ./src/test/bash/unit_test.sh \
 && unzip -d /opt/Checks-0.0.1 ./build/zip/Checks-0.0.1.zip
```

### Download and Install

```
$ TMP_PATH="$(mktemp)"; \
 curl -L 'https://github.com/StanleyProjects/Checks/releases/download/0.0.1/Checks-0.0.1.zip' \
  -o "${TMP_PATH}" && unzip -d /opt/Checks-0.0.1 "${TMP_PATH}" && rm "${TMP_PATH}"
```

---
