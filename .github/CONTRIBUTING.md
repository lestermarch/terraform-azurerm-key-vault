# How to Contribute

Thank you for taking the time to contribute to this module! This document provides guidance and guidelines on contributing.

## Recommended Tooling

This repo provides a [devcontainer](https://containers.dev/) which comes pre-configured with all recommended tooling and VS Code extensions. The devcontainer is compatible with GitHub Codespaces for easy development through your web browser. Alternatively, the Dockerfile can be built and used for local development ([VS Code devcontainers extension](https://code.visualstudio.com/docs/devcontainers/containers) is recommended).

If you prefer not to use the devcontainer, then the following open-source tools are highly recommended for use during development of Teras modules alongside Terraform:

| Tool | Description |
| ---- | ----------- |
| [Checkov](https://github.com/bridgecrewio/checkov) | Security and compliance configuration analyzer for provider-specific resources (e.g. Azure). |
| [Terraform-Docs](https://github.com/terraform-docs/terraform-docs) | Documentation generator for Terraform modules (inputs, outputs, providers, etc.). |
| [TFLint](https://github.com/terraform-linters/tflint) | Linting tool for Terraform and provider-specific resources (e.g. Azure). |
| [Pre-Commit](https://github.com/pre-commit/pre-commit) | Git hook framework for running checks and fixing trivial issues before code commits. |

After initializing Pre-Commit from the root of the repository (`pre-commit install`) each tool will be run automatically, in addition to other basic hooks, on every `git commit` to expedite development and enforce code quality standards.

> [!Note]
> Configuration files for each tool are provided and should not require modification:
>
> - [checkov.yaml](/.config/checkov.yaml)
> - [terraform-docs.yaml](/.config/terraform-docs.yaml)
> - [tflint.hcl](/.config/tflint.hcl)
> - [pre-commit-config.yaml](/.pre-commit-config.yaml)

## Testing

This module uses the native [Terraform test](https://developer.hashicorp.com/terraform/language/tests) framework. Before [submitting changes](#submitting-changes), please run _unit tests_ and _integration tests_ as described below, updating or adding tests as necessary.

Unit tests are based on the output of `terraform plan` using mock resources and data sources for dependencies. All unit tests are contained in the [tests/unit](/tests/unit/) directory and can be run with the following command from the root of the repository:

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
ARM_SUBSCRIPTION_ID="00000000-0000-0000-0000-000000000000" # Your Azure subscription ID
terraform test -test-directory=tests/integration
```

> [!Warning]
> Running integration tests will deploy resources to your current Azure subscription context and may incur a cost. Before running integration tests, ensure you are logged into Azure using the Azure CLI and verify your subscription context is appropriate for deploying test resources:
>
> - View your current subscription context: `az account show`
> - Change your subscription context: `az account set -s <subscriptionId>`

## Requesting and Submitting Changes

This module uses [GitHub Issues](https://docs.github.com/en/issues/tracking-your-work-with-issues/about-issues) to track feature requests and bugs. Ideally, an issue should be raised for any module improvements (features), or fixes before raising submitting changes.

When contributing changes, follow the ([GitHub Flow](https://docs.github.com/en/get-started/using-github/github-flow)) process below:

1. Create a new branch (e.g. `feat/<description>` for a feature, or `fix/<description>` for a fix);
2. Make your changes locally (ideally using [recommended tooling](#recommended-tooling));
3. Push your branch to the remote repo;
4. Ensure the [CI pipeline] passes;
5. Raise a [Pull Request](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/about-pull-requests), linking to any associated issues, and assigning any additional reviewers.
6. :rocket: :rocket: :rocket:

## Coding Conventions

Conformity to coding standards is mostly enforced through the [recommended tooling](#recommended-tooling) and CI pipeline. However, there are some additional conventions which should be taken into account:

1. **Move complex module logic to local variables**</br>This prevents complex code from being used directly in resource definitions, instead allowing resources to reference either variables (`var.<variableName>`) or locals (`local.<localName>`) directly. The logic in `locals.tf` can then be described adequately with code comments as necessary.
2. **Example code for complex variables**</br>Complex variables (e.g. of type `object`, or `map`) should use a heredoc-style description to encapsulate an example codeblock to demonstrate the attributes of the object type and example values. The codeblock should be surrounded by triple backticks (markdown codeblock formatting) to be interpreted by Terraform Docs to rendered properly as a codeblock in the module README file.
3. **Alphabetized attributes, variables, and outputs**</br>Object attributes should generally be listed in two blocks; one block of required attributes, and another of optional attributes specified in the module. Each block of attributes should be listed in alphabetical order for ease of human interpretation. Similarly, variables, locals, and outputs (in `variables.tf`, `locals.tf`, and `outputs.tf`) should be listed in alphabetical order to aid readability.
4. **Split modules resources into dedicated files**</br>Aside from the core `main.tf`, `variables.tf`, `outputs.tf`, and `locals.tf` files, module resources and closely-associated resources should reside in their own dedicated Terraform file (e.g. `key-vault.tf`) to aid readability for large modules.
