## Rails Messaging RESTful API

### Table of contents

* [API Resources](#api-resources)
* [Current Version](#current-version)
* [Schema](#schema)
* [Parameters](#parameters)
* [Root Endpoint](#root-endpoint)
* [Client Errors](#client-errors)
* [HTTP Verbs](#http-verbs)

#### API Resources

Currently there are following API resources:

1. User
2. Conversation
3. Message


#### Current Version

By default, all requests receive the `v1` version of the API.

#### Schema

All API access is over `HTTP` and accessed from the `http://localhost:3000/api/v1/`. All data is sent and received as `JSON`.

#### Parameters

All parameters taken by some API methods are required parameters, i.e.: there are not API methods that take optional parameters. For `POST` requests, parameters not included in the URL should be encoded as JSON with a `Content-Type` of `application/json`

#### Root Endpoint

You can issue a `GET` request to the root endpoint `http://localhost:3000` to get all the endpoint categories that the API supports. The endpoints are grouped by resource names, for example:

```
{
  "sessions": [
    {
      "version": "1",
      "name": "get_authorization_token_using_basic_auth",
      "method": "GET",
      "path": "/api/v1/sessions"
    }
  ],
  "users": [
    {
      "version": "1",
      "name": "get_all_users",
      "method": "GET",
      "path": "/api/v1/users"
    },
    {
      "version": "1",
      "name": "create_new_user",
      "method": "POST",
      "path": "/api/v1/users"
    }
  ...
  ...
}
```
#### Client Errors

There are three possible types of client errors on API calls that receive request bodies (please note that there is no validation in place for sending the wrong type of JSON values):

###### Sending invalid JSON will result in a `400 Bad Request` response
```
HTTP/1.1 400 Bad Request
Content-Type: application/json; charset=utf-8
Content-Length: 102

{"code":400,"message":"400 Bad Request","description":"The syntax of the request entity is incorrect"}
```

###### Sending invalid fields will result in a `422 Unprocessable Entity` response
```
HTTP/1.1 422 Unprocessable Entity
Content-Type: application/json; charset=utf-8
Content-Length: 140

{"code":422,"message":"422 Unprocessable Entity","description":"The server was unable to process the Request payload: 'message' is missing"}
```

###### Trying to re-create an existing entity will result in `400 Bad Request` response
```
HTTP/1.1 400 Bad Request
Content-Type: application/json; charset=utf-8
Content-Length: 108

{"code":400,"message":"400 Bad Request","description":"User with email '1@gmail.com' is already registered"}
```

#### HTTP Verbs

Where possible, API v1 strives to use appropriate HTTP verbs for each action:

| Verb		| Description  						|
|---		|---								|
| HEAD 		| Currently unsupported  			|
| GET  		| Used for retrieving resources 	|
| POST 		| Used for creating resources  		|
| PATCH		| Currently unsupported  			|
| PUT 		| Currently unsupported  			|
| DELETE 	| Currently unsupported  			|







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
11. When listing all the users, conversation or messages there is no paging in place. What ever is in DB will be listed
12. Users are unique.y identified by email in the system