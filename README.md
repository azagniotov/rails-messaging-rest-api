## Rails Messaging RESTful API

#### Minimal Prerequisites

1. Ruby v2.2.3
2. Rails v4.2.4


#### Design Decisions

1. User input submitted via API is valid, ie.: no email format or password complexity validation
2. rake db:reseed
3. After creation users cannot be updated
4. API JSON responses are generated as per `http://jsonapi.org/format/`
5. when creating new user, you must also POST the desired password. Not a good idea in real life, I am aware of that
6. To access the API, user must provide HTTP header `X-Api-Key` with API authorization token to access all APIs except 
creating new users (POST to `/api/v1/users/`). In case of creating a new user, the API token will be return as part of JSON response.
7. To get the API authorization token, existing user heeds to authenticate himself using his credentials and basic 
access authentication by submitting GET request to: `/api/v1/sessions`.
8. On each API call I do a DB lookup to validate API auth token
9. Model validations are only to check whether required fields are set
10. API docs: rails g apipie:install