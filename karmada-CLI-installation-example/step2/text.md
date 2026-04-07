### Install karmadactl

**Install `karmadactl`:**

RUN `curl -s https://raw.githubusercontent.com/karmada-io/karmada/master/hack/install-cli.sh | sudo bash`{{exec}}

This downloads and installs the `karmadactl` CLI tool from the official Karmada repository.

**Verify installation:**

RUN `karmadactl version`{{exec}}

This confirms that `karmadactl` is installed correctly and shows the installed version.