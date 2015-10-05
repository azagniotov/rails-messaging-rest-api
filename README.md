# Rails Messaging RESTful API

Was created with love using `Ruby v2.2.3` and `Rails v4.2.4`

The API allows to perform the following actions:

1. Create and list users
2. Create new conversations with users
3. List conversations that a certain user is part of
4. Send a message to a conversation
5. View all messages in a conversation
6. View all users in a conversation
7. View specific message

To run the app locally use `bundle install` and `rails server` commands


## Table of contents

* [Current Version](#current-version)
* [Schema](#schema)
* [Parameters](#parameters)
* [Root Endpoint](#root-endpoint)
* [Client Errors](#client-errors)
* [HTTP Verbs](#http-verbs)
* [Authentication](#authentication)
* [Resources](#resources)
* [Design Decisions & Assumptions](#design-decisions-assumptions)
* [Future Enhancements](#future-enhancements)


### Current Version

By default, all requests receive the `v1` version of the API.

### Schema

All API access is over `HTTP` and accessed from the `http://localhost:3000/api/v1/`. All data is sent and received as `JSON`.

### Parameters

All parameters taken by some API methods are all __required__ parameters, i.e.: there are not API methods that take optional parameters. For `POST` requests, parameters not included in the URL should be encoded as JSON with a `Content-Type` of `application/json`

### Root Endpoint

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
### Client Errors

There are three possible types of client errors on API calls that receive request bodies (please note that there is no validation in place for sending the wrong type of JSON values):

##### Sending invalid JSON will result in a `400 Bad Request` response
```
HTTP/1.1 400 Bad Request
Content-Type: application/json; charset=utf-8
Content-Length: 102

{"code":400,"message":"400 Bad Request","description":"The syntax of the request entity is incorrect"}
```

##### Sending invalid fields will result in a `422 Unprocessable Entity` response
```
HTTP/1.1 422 Unprocessable Entity
Content-Type: application/json; charset=utf-8
Content-Length: 140

{"code":422,"message":"422 Unprocessable Entity","description":"The server was unable to process the Request payload: 'message' is missing"}
```

##### Trying to re-create an existing entity will result in `400 Bad Request` response
```
HTTP/1.1 400 Bad Request
Content-Type: application/json; charset=utf-8
Content-Length: 108

{"code":400,"message":"400 Bad Request","description":"User with email '1@gmail.com' is already registered"}
```

### HTTP Verbs

Where possible, API v1 strives to use appropriate HTTP verbs for each action:

| Verb		| Description  						|
|---		|---								|
| HEAD 		| Currently unsupported  			|
| GET  		| Used for retrieving resources 	|
| POST 		| Used for creating resources  		|
| PATCH		| Currently unsupported  			|
| PUT 		| Currently unsupported  			|
| DELETE 	| Currently unsupported  			|

### Authentication

To authenticate through API `v1`, API authentication token must be provided. There are only two endpoints that do not require authentication:

1. Creating a new `User`
2. Retrieving the authentication token

Requests that require authentication will return `401 Unauthorized` in case of failed authentication. 

##### Basic Authentication

To retrieve API authentication token, client must authenticate itself using HTTP basic authentication by making `GET` request to `/api/v1/sessions` using existing credentials: 

```
curl -u 1@gmail.com:123456 http://localhost:3000/api/v1/sessions
```
If authentication was successful, the API will respond with:

```
{"email":"1@gmail.com","auth_token":"14e0659ce56f4048a0f0ae1f4dcbffd5"}
```

##### API Access

To access an endpoint requiring authentication, the `X-Api-Key` HTTP header must be set

```
curl -H "X-Api-Key: 14e0659ce56f4048a0f0ae1f4dcbffd5" -H "Content-Type: application/json" http://localhost:3000/api/v1/users/1
```

### Resources

Currently there are following API resources:

#### User

##### Create new user

```
POST /api/v1/users
```
Parameters

| Name			| Type 		| Description		|
|---			|---		|---				|
| name 			| string	| User name			|
| email 		| string	| User email		|
| password 		| string	| User password		|

Request

```
curl -X POST http://localhost:3000/api/v1/users \
-d '{"user": {"email": "1@gmail.com", "password": "123456", "name": "alex"}}' \
-H "Content-Type: application/json"
```

Response

```
{"data":{"id":"1","type":"users","attributes":{"name":"alex","email":"1@gmail.com","links":{"self":"/api/v1/users/3","all":"/api/v1/users"}}}}
```

##### List user by id

```
GET /api/v1/users/:user_id
```

Request

```
curl \
-H "X-Api-Key: 14e0659ce56f4048a0f0ae1f4dcbffd5" \
-H "Content-Type: application/json" http://localhost:3000/api/v1/users/1
```

Response

```
{"data":{"id":"1","type":"users","attributes":{"name":"alex","email":"1@gmail.com","links":{"self":"/api/v1/users/1","all":"/api/v1/users"}}}}
```

##### List all users

```
GET /api/v1/users
```

Request

```
curl \
-H "X-Api-Key: 14e0659ce56f4048a0f0ae1f4dcbffd5" \
-H "Content-Type: application/json" http://localhost:3000/api/v1/users
```

Response

```
{"data":[{"id":"1","type":"users","attributes":{"name":"alex","email":"1@gmail.com","links":{"self":"/api/v1/users/1","all":"/api/v1/users"}}}]}
```

##### List user conversations by user id

```
GET /api/v1/users/:user_id/conversations
```

Request

```
curl \
-H "X-Api-Key: 14e0659ce56f4048a0f0ae1f4dcbffd5" \
-H "Content-Type: application/json" \
http://localhost:3000/api/v1/users/1/conversations
```

Response

```
{"data":{"id":"1","type":"users","attributes":{"name":"alex","email":"1@gmail.com"},"relationships":{"conversations":{"data":[{"id":1,"started_by":1}]}}}}
```




#### Conversation


#### Message

##### List message by id

```
GET /api/v1/messages/:message_id
```

Request

```
curl \
-H "X-Api-Key: 14e0659ce56f4048a0f0ae1f4dcbffd5" \
-H "Content-Type: application/json" \
http://localhost:3000/api/v1/messages/1
```

Response

```
{"data":{"id":"1","type":"messages","attributes":{"sender_id":1,"text":"Hello, this is me!","created_at":"2015-10-05T01:16:43.191Z","links":{"self":"/api/v1/messages/1"}}}}
```


### Design Decisions & Assumptions

1. Client requests submitted to the API are valid, ie.: there is no email format or password complexity validation in place
2. After creation, `User` cannot be updated
3. When creating a new `User`, you must also `POST` the desired password. Not a good idea in real life, I am aware of that
4. On each API call requiring authentication, there is a DB lookup to validate API authentication token
5. Model validations only to check whether required fields are set
6. Email uniquely identifies `Users` in the system
7. There is no pagination nor request rate limiting

### Future Enhancements

1. Pagination for requests that return multiple items
2. Rate limiting for requests using authentication and unauthenticated requests
3. Ability to re-generate API authentication token
4. Ability to update an exsiting `User`
5. List messages in a conversation by sender or recipient
6. More thorough request fields validation
7. OAuth2

