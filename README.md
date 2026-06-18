# Bashx.Checks
A few check scripts.

---

## Release

`0.0.3`
| [GitHub](https://github.com/stanbashx/Bashx.Checks/releases/tag/0.0.3)
| [Key](https://stanbashx.github.io/release-public.pem)

### Build and Install

```
$ ./assemble.sh \
 && ./src/test/bash/unit_test.sh \
 && unzip -d /opt/Bashx.Checks-0.0.3 ./build/zip/Bashx.Checks-0.0.3.zip
```

### Download and Install

```
$ TMP_PATH="$(mktemp)"; \
 curl -L 'https://github.com/stanbashx/Bashx.Checks/releases/download/0.0.3/Bashx.Checks-0.0.3.zip' \
  -o "${TMP_PATH}" && unzip -d /opt/Bashx.Checks-0.0.3 "${TMP_PATH}" && rm "${TMP_PATH}"
```

---
