---
date: 2021-02-15T14:46
tags: 
  - stub
---

# gRPC backward compatability

Keeping backward compatability is always important. gRPC is new grounds for many,
so it's easy to get lost in what's considered "breaking changes" or not.

## Non-breaking changes

- Adding a new service

- Adding a new method to a service

- Adding a value to an enum

- Adding a field to the end of a message

  The Go gRPC library does not support added fields to response or request
  messages when they are added at the beginning or middle of the message, as it
  uses the index of the field to map the values.<sup>[verification needed]</sup>

## Breaking changes

Kind of any other changes that are not specified in the "Non-breaking changes"
section above.

- Removing a service

- Changing a service (ex: name)

- Removing methods from a service

- Changing methods from a service (ex: name, signature)

- Removing a field in a message

- Changing the type of a field in a message

- Changing a field number, for example by reordering them.

## How to handle breaking changes

Up the protocol version.

This may happen frequently, and may be another good use case for applying some
git-flow with release-branches.

## References

- <https://docs.microsoft.com/en-us/aspnet/core/grpc/versioning?view=aspnetcore-3.1>

- <https://medium.com/swlh/building-apis-with-grpc-and-go-9a6d369d7ce>

- <https://github.com/hashicorp/go-plugin/tree/779d64e/examples/negotiated>
