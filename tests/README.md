# Tests

This directory contains subdirectories for unit and integration tests. To run tests, run the `terraform test` command from the root of the repository, scoped to the appropriate directory:

> [!Note]
> Before running integration tests for the first time, you will need to initialize the test directory using the below command:
>
> ```bash
> terraform init -test-directory=tests/integration
> ```

```bash
# Run unit tests
terraform test -test-directory=tests/unit

# Run integration tests
terraform test -test-directory=tests/integration
```

> [!Warning]
> Running integration tests will deploy resources to your current Azure subscription context and may incur a cost. Before running integration tests, ensure you are logged into Azure using the Azure CLI and verify your subscription context is appropriate for deploying test resources:
>
> - View your current subscription context: `az account show`
> - Change your subscription context: `az account set -s <subscriptionId>`
