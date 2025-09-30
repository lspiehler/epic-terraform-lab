## What are the guiding principles for this project?
1. **No literals should be used anywhere in the code** -  All variables should be defined outside the code in a file that reflects the environment being deployed. This allows the same code to accommodate all customers, and it allows our customers to use the same code for all of their environments. This ensures consistency across environments with the ability to customize environments by simply changing the variables file.
2. **Under construction**

## Why do we wrap every resource in its own module?
[This AWS best practices document](https://docs.aws.amazon.com/prescriptive-guidance/latest/terraform-aws-provider-best-practices/structure.html#modularity) says to avoid wrapping single resources in modules, however, we have found that if we want to have consistent references to resources whether we are creating them or referencing an existing resource provided by a customer, it requires that we wrap resources in a module so we can normalize the output. This may not be the best practice, but it is the best practice for our use case.

We also learned early on that if we start out building resources by using Terraform resource blocks outside a module and later decided to wrap them in a module, refactoring the code will result in a new resource being created and the old resource being destroyed because of the resulting changes in the Terraform state file. We decided to start out with a module for all resources from the beginning to avoid this issue.

## What branching strategy should be used for this project?
We use different directories for each environment, to avoid the need to maintain long-lived branches. This allows us to use a single branch for all environments and to use feature branches to develop new features. Pipelines can be run against a feature branch to validate the changes in any of the environments before merging them into the master branch. We can then merge the feature branches into the master branch and run the pipeline to deploy the changes to all environments.

## Why don't we use Terraform to write long-form declarative infrastructure?
This method of writing IaC requires infrastructure to deployed incrementally. Resources that are dependencies for other resources must be created first so that their IDs can be looked up and supplied as input to the dependent resources. This process is slow and cumbersome. Our goal is to require as little input as possible to avoid human error, and enable rapid, reliable deployment of infrastructure.

## What are the naming conventions for this project?
**Under construction**