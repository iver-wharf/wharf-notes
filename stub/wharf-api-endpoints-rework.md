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

| Tag | Endpoint | Method |
| --- | -------- | ------ |
| artifact | /build/{buildid}/artifact | POST |
| artifact | /build/{buildid}/artifact/{artifactid} | GET |
| artifact | /build/{buildid}/artifacts | GET |
| artifact | /build/{buildid}/test-results | GET |
| branch | /branch | POST |
| branch | /branch/{branchid} | GET |
| branch | /branches | GET |
| branches | /branches | PUT |
| build | /build/search | POST |
| build | /build/{buildid} | GET |
| build | /build/{buildid} | PUT |
| build | /build/{buildid}/log | GET |
| build | /build/{buildid}/log | POST |
| build | /build/{buildid}/stream | GET |
| health | /health | GET |
| health | /ping | GET |
| meta | /version | GET |
| project | /project | POST |
| project | /project | PUT |
| project | /project/{projectid} | DELETE |
| project | /project/{projectid} | GET |
| project | /project/{projectid}/{stage}/run | POST |
| project | /projects | GET |
| project | /projects/search | POST |
| project | /projects/{projectid}/builds | GET |
| provider | /provider | POST |
| provider | /provider | PUT |
| provider | /provider/{providerid} | GET |
| provider | /providers | GET |
| provider | /providers/search | POST |
| token | /token | POST |
| token | /token | PUT |
| token | /token/{tokenid} | GET |
| token | /tokens | GET |
| token | /tokens/search | POST |

## New endpoints

### Overall changes

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

### Path changes

| Tag      | Old                                    | New                                    | Method | ID                      | Changes                                                                       |
|----------|----------------------------------------|----------------------------------------|--------|-------------------------|-------------------------------------------------------------------------------|
| artifact | /build/{buildid}/artifacts             | /build/{buildId}/artifact              | GET    | getBuildArtifactList    | camelCased {buildid}.                                                         |
| artifact | /build/{buildid}/artifact              | /build/{buildId}/artifact              | POST   | uploadBuildArtifact     | camelCased {buildid}.                                                         |
| artifact | /build/{buildid}/artifact/{artifactid} | /build/{buildId}/artifact/{artifactId} | GET    | getBuildArtifact        | camelCased {buildid} and {artifactid}.                                        |
| build    | /build/search                          | _unchanged_                            | POST   | searchBuild             |                                                                               |
| build    | /build/{buildid}                       | /build/{buildId}                       | GET    | getBuild                | camelCased {buildid}.                                                         |
| build    | /build/{buildid}                       | /build/{buildId}                       | PUT    | updateBuild             | camelCased {buildid}.                                                         |
| build    | /build/{buildid}/log                   | /build/{buildId}/log                   | GET    | getBuildLogs            | camelCased {buildid}.                                                         |
| build    | /build/{buildid}/log                   | /build/{buildId}/log                   | POST   | createBuildLog          | camelCased {buildid}.                                                         |
| build    | /build/{buildid}/stream                | /build/{buildId}/stream                | GET    | streamBuildLogs         | camelCased {buildid}.                                                         |
| build    | /build/{buildid}/test-results          | /build/{buildId}/test-result           | GET    | getBuildTestResults     | Moved from artifact tag. camelCased {buildid}.                                |
| health   | /health                                | _unchanged_                            | GET    | health                  |                                                                               |
| health   | /ping                                  | _unchanged_                            | GET    | ping                    |                                                                               |
| meta     | /version                               | _unchanged_                            | GET    | getVersion              |                                                                               |
| project  | /projects                              | /project                               | GET    | getProjectList          |                                                                               |
| project  | /project                               | _unchanged_                            | POST   | createProject           |                                                                               |
| project  | /projects/search                       | /project/search                        | POST   | searchProject           |                                                                               |
| project  | /project/{projectid}                   | /project/{projectId}                   | DELETE | deleteProject           | camelCased {projectid}.                                                       |
| project  | /project/{projectid}                   | /project/{projectId}                   | GET    | getProject              | camelCased {projectid}.                                                       |
| project  | /project                               | /project/{projectId}                   | PUT    | updateProject           | Added {projectId}.                                                            |
| project  | /branch                                | /project/{projectId}/branch            | GET    | getProjectBranchList    |                                                                               |
| project  | /branches                              | /project/{projectId}/branch            | PUT    | updateProjectBranchList |                                                                               |
| project  | /branch/{branchid}                     | /project/{projectId}/branch/{branchId} | GET    | getProjectBranch        | camelCased {branchid}.                                                        |
| project  | /project/{projectid}/builds            | /project/{projectId}/build             | GET    | getProjectBuildList     | camelCased {projectid}.                                                       |
| project  | /project/{projectid}/{stage}/run       | /project/{projectId}/build             | POST   | startProjectBuild       | camelCased {projectid}. Use stage=ALL as default via query parameter instead. |
| provider | /providers                             | /provider                              | GET    | getProviderList         |                                                                               |
| provider | /provider                              | _unchanged_                            | POST   | createProvider          |                                                                               |
| provider | /provider/{providerid}                 | /provider/{providerId}                 | GET    | getProvider             | camelCased {providerid}.                                                      |
| provider | /provider                              | /provider/{providerId}                 | PUT    | updateProvider          | Added {providerId}.                                                           |
| provider | /providers/search                      | /provider/search                       | POST   | serachProvider          |                                                                               |
| token    | /tokens                                | /token                                 | GET    | getTokenList            |                                                                               |
| token    | /token                                 | /token                                 | POST   | createToken             |                                                                               |
| token    | /tokens/search                         | /token/search                          | POST   | searchToken             |                                                                               |
| token    | /token/{tokenId}                       | /token/{tokenId}                       | GET    | getToken                | camelCased {tokenid}.                                                         |
| token    | /token                                 | /token/{tokenId}                       | PUT    | updateToken             | Added {tokenId}.                                                              |

### Body changes

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
