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

## Overall changes

- Singular everywhere.

- Moved a lot of endpoints, such as the /branch(es) endpoints, under
  /project/{projectId} as they require a project ID anyway.

- camelCased all path parameters.

- Added ID, meaning to be a Swagger/OpenAPI endpoint ID. Used in code generation.
    
  - Somewhat namespaced, for example getProjectBranchList instead of getBranchList, as it's under /project/...
  - Endpoints returning array of objects ends with "-List"
  - No trailing "-ById" at the end.
  - Prefix mostly defined by the HTTP method:
  
    - POST: create-, upload-, search-, start-
    - GET: get-
    - PUT: update-
    - DELETE: delete-

## Tables of changes

#### Tag: artifact

| Old                                    | New                                    | Method | ID                   | Notes |
|----------------------------------------|----------------------------------------|--------|----------------------|-------|
| /build/{buildid}/artifacts             | /build/{buildId}/artifact              | GET    | getBuildArtifactList | 1.    |
| /build/{buildid}/artifact              | /build/{buildId}/artifact              | POST   | uploadBuildArtifact  | 1.    |
| /build/{buildid}/artifact/{artifactid} | /build/{buildId}/artifact/{artifactId} | GET    | getBuildArtifact     | 1.    |

#### Tag: build

| Old                           | New                          | Method | ID                  | Notes |
|-------------------------------|------------------------------|--------|---------------------|-------|
| /build/search                 | *unchanged*                  | POST   | searchBuild         |       |
| /build/{buildid}              | /build/{buildId}             | GET    | getBuild            | 1.    |
| /build/{buildid}              | /build/{buildId}             | PUT    | updateBuild         | 1.    |
| /build/{buildid}/log          | /build/{buildId}/log         | GET    | getBuildLogs        | 1.    |
| /build/{buildid}/log          | /build/{buildId}/log         | POST   | createBuildLog      | 1.    |
| /build/{buildid}/stream       | /build/{buildId}/stream      | GET    | streamBuildLogs     | 1.    |
| /build/{buildid}/test-results | /build/{buildId}/test-result | GET    | getBuildTestResults | 1. 2. |

#### Tag: health

| Old     | New         | Method | ID        | Notes |
|---------|-------------|--------|-----------|-------|
| /health | *unchanged* | GET    | getHealth |       |
| /ping   | *unchanged* | GET    | ping      |       |

#### Tag: meta

| Old      | New         | Method | ID         | Notes |
|----------|-------------|--------|------------|-------|
| /version | *unchanged* | GET    | getVersion |       |

#### Tag: project

| Old                              | New                                    | Method | ID                      | Notes |
|----------------------------------|----------------------------------------|--------|-------------------------|-------|
| /projects                        | /project                               | GET    | getProjectList          |       |
| /project                         | *unchanged*                            | POST   | createProject           |       |
| /projects/search                 | /project/search                        | POST   | searchProject           |       |
| /project/{projectid}             | /project/{projectId}                   | DELETE | deleteProject           | 1.    |
| /project/{projectid}             | /project/{projectId}                   | GET    | getProject              | 1.    |
| /project                         | /project/{projectId}                   | PUT    | updateProject           | 3.    |
| /branch                          | /project/{projectId}/branch            | GET    | getProjectBranchList    |       |
| /branches                        | /project/{projectId}/branch            | PUT    | updateProjectBranchList |       |
| /branch/{branchid}               | /project/{projectId}/branch/{branchId} | GET    | getProjectBranch        | 1.    |
| /project/{projectid}/builds      | /project/{projectId}/build             | GET    | getProjectBuildList     | 1.    |
| /project/{projectid}/{stage}/run | /project/{projectId}/build             | POST   | startProjectBuild       | 1. 4. |

#### Tag: provider

| Old                    | New                    | Method | ID              | Notes |
|------------------------|------------------------|--------|-----------------|-------|
| /providers             | /provider              | GET    | getProviderList |       |
| /provider              | *unchanged*            | POST   | createProvider  |       |
| /provider/{providerid} | /provider/{providerId} | GET    | getProvider     | 1.    |
| /provider              | /provider/{providerId} | PUT    | updateProvider  | 3.    |
| /providers/search      | /provider/search       | POST   | serachProvider  |       |

#### Tag: token

| Old              | New              | Method | ID           | Notes |
|------------------|------------------|--------|--------------|-------|
| /tokens          | /token           | GET    | getTokenList |       |
| /token           | *unchanged*      | POST   | createToken  |       |
| /tokens/search   | /token/search    | POST   | searchToken  |       |
| /token/{tokenId} | /token/{tokenId} | GET    | getToken     | 1.    |
| /token           | /token/{tokenId} | PUT    | updateToken  | 3.    |

#### Notes legend

1. The path parameter has been transformed from lowercase to camelCase. This
   only affects code generators.

2. Endpoint was moved from tag `artifact` to tag `build`.

3. Added path parameter for value that was previously taken from the HTTP
   request body.

4. The `{stage}` path parameter has been moved to a query parameter. Now uses
   `?stage=ALL` by default.

## Body changes

- Endpoints shall have different models for different endpoints.

  - One for retrieved data, used in GET and search requests, as well as response
    for creations

    No special prefix or suffix required.
  
  - One for creation of data, used in POST requests
  
    Prefixed with "Create-", ex "CreateProject", "CreateProvider", "CreateToken"
  
  - One for editing data, used in PUT requests.
  
    Prefixed with "Edit-", ex "EditProject", "EditProvider", "EditToken"
    
    > Q: Are edit-specific ones really needed? Will not the creation models
    > suffice?
  
  This allows us to provide different Gin-Gonic specific binding attributes to
  the models

- No database models shall be returned. They need to be mapped to request or
  response models.

- To not have name collisions, the models will be placed in new sub-packages:

  - `/pkg/models/request`: HTTP request models, to be returned from the API
  - `/pkg/models/response`: HTTP response models, to be sent to the API
  - `/pkg/models/database`: Database models, that are used in GORM
