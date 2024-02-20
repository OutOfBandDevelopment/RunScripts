

## Summary

Add the ability to reuse a container image versus partial execution

## Check if container exists

This command will return an error if it does not exists

```shell
docker inspect --format '{{.Id}}' memgraph
```