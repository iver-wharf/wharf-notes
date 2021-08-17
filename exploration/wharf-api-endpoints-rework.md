---
date: 2021-08-17T14:37
---

# Wharf API endpoints rework

## Why

- Some use plural, some use singular. We need consistency

- Some are misplaced and convoluted

- Some are marked as "NOT YET IMPLEMENTED" while we may not want them anymore.
  Need to trim away the bloat.
  
- Some parameters are lowercased, while some are camelCased.

## Old endpoints

### branch

```ts
POST /branch
GET /branch/{branchid}
GET /branches
```

### branches

```ts
PUT /branches
```

### build

```ts
GET /build/{buildid}
GET /build/{buildid}/log
GET /build/{buildid}/stream
POST /build/search
POST /build/{buildid}/log
PUT /build/{buildid}
```

### artifact

```ts
GET /build/{buildid}/artifact/{artifactid}
GET /build/{buildid}/artifacts
GET /build/{buildid}/test-results
POST /build/{buildid}/artifact
```

### health

```ts
GET /health
GET /ping
```

### project

```ts
DELETE /project/{projectid}
GET /project/{projectid}
GET /projects
GET /projects/{projectid}/builds
POST /project
POST /project/{projectid}/{stage}/run
POST /projects/search
PUT /project
```

### provider

```ts
GET /provider/{providerid}
GET /providers
POST /provider
POST /providers/search
PUT /provider
```

### token

```ts
GET /token/{tokenid}
GET /tokens
POST /token
POST /tokens/search
PUT /token
```

### meta

```ts
GET /version
```
