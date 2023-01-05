# Simple Chat API

## Requirements
1. Ruby 3.1.3
2. Mariadb 10.3.10

## Installation
1. install dependencies by command **bundle install**
2. If there is an error about mysql2 installation, please refer to this comment [Solve error while installing mysql2](https://github.com/brianmario/mysql2/issues/1210#issuecomment-1249494167)
3. Modify db configuration in **config/database.yml** and sync the username, password (change the database name is preferred)
>```
> default: &default
>   adapter: mysql2
>   encoding: utf8mb4
>   pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
>   username: root
>   password: root
>   host: localhost
>
> development:
>   <<: *default
>   database: simple_chat_api_development
>
> test:
>   <<: *default
>   database: simple_chat_api_test
>```
4. create an empty database by command **rake db:create**
5. migrate tables by command **rake db:migrate**
6. run server by command **rails s**
7. the API should works fine



#### ~~I apologize for any mistake related to Ruby dan Ruby on Rails. it's my 3th day using Ruby as programming language. You can check my resume :D. Please consider me for the position~~ 

## API Documentation

### End-point: auth/register
User must register before using this API
#### Method: POST
>```
>{{base_url}}/auth/register
>```
#### Body formdata

|Param|value|Type|
|---|---|---|
|name|Test Account 1|text|
|email|testaccount1@gmail.com|text|
|phone_number|+628123456789|text|
|password|asd|text|
|image|/D:/Downloads/head-659652_1280.png|file|


#### Response: 200 

```json
{
    "success": true,
    "message": "Account successfully created",
    "data": {
        "id_user": 2,
        "name": "Test Account 1",
        "email": "testaccount1@gmail.com",
        "phone_number": "+628123456789",
        "image": "public/upload/01cdb7d9b7a5bc0408555bcf4e659aa9.png"
    }
}
```


⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃

### End-point: auth/login
Get access token by login and use the token to access any endpoint below. this API is using Bearer

#### Method: POST
>```
>{{base_url}}/auth/login
>```
#### Body formdata

|Param|value|Type|
|---|---|---|
|email|cybercature@gmail.com|text|
|password|asd|text|


#### Response: 200
```json
{
    "success": true,
    "messages": "Login success",
    "data": {
        "user": {
            "id_user": 1,
            "name": "Ilham Rahmadhani",
            "email": "cybercature@gmail.com",
            "phone_number": "+6281298795858",
            "image": "public/upload/c37a3ad4bb2a13ca036f78633c52686e.gif"
        },
        "access_token": "eyJhbGciOiJIUzI1NiJ9.eyJpZF91c2VyIjoxLCJleHAiOjE2NzM0MTI4NDl9.WQ7yAw1Y3HsDfY_6tBpY6pF3tyl69SG4KP3hqL9lkYA"
    }
}
```


⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃
### Set header 'Authorization' value to 'Bearer (access token)' before access below endpoints

⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃


### End-point: users
#### Method: GET
>```
>{{base_url}}/users
>```
#### Body formdata

|Param|value|Type|
|---|---|---|


#### Query Params

|Param|value|
|---|---|
|page|1|
|items|5|
|search|account|


#### Response: 200
```json
[
    {
        "success": true,
        "message": "Users retrieved",
        "data": {
            "page": 1,
            "next_page": null,
            "total_data": 1,
            "per_page": 10,
            "users": [
                {
                    "id_user": 2,
                    "name": "Test Account 1",
                    "email": "testaccount1@gmail.com",
                    "phone_number": "+628123456789",
                    "image": "public/upload/01cdb7d9b7a5bc0408555bcf4e659aa9.png",
                    "friendship_status": null,
                    "requested": null
                }
            ]
        }
    }
]
```


⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃


### End-point: friendships
Show all friends of authenticated user
#### Method: GET
>```
>{{base_url}}/friendships
>```
#### Body formdata

|Param|value|Type|
|---|---|---|


#### Query Params

|Param|value|
|---|---|
|page|1|
|items|10|
|search|tes|


#### Response: 200
```json
[
    {
        "success": true,
        "message": "Friends retrieved",
        "data": {
            "page": 1,
            "next_page": null,
            "total_data": 1,
            "per_page": 10,
            "friends": [
                {
                    "id_user": 1,
                    "name": "Ilham Rahmadhani",
                    "email": "cybercature@gmail.com",
                    "phone_number": "+6281298795858",
                    "image": "public/upload/c37a3ad4bb2a13ca036f78633c52686e.gif"
                }
            ]
        }
    }
]
```


⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃

### End-point: friendships/:id_user
Show profile of authenticated user's friend
#### Method: GET
>```
>{{base_url}}/friendships/1
>```
#### Response: 200
```json
[
    {
        "success": true,
        "message": "Friend retrieved",
        "data": [
            {
                "id_user": 1,
                "name": "Ilham Rahmadhani",
                "email": "cybercature@gmail.com",
                "phone_number": "+6281298795858",
                "image": "public/upload/c37a3ad4bb2a13ca036f78633c52686e.gif"
            }
        ]
    }
]
```


⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃

### End-point: friendships/pending
Show all pending friend requests
#### Method: GET
>```
>{{base_url}}/friendships/pending
>```
#### Body formdata

|Param|value|Type|
|---|---|---|


#### Query Params

|Param|value|
|---|---|
|page|1|
|items|10|
|search|tes|


#### Response: 200
```json
[
    {
        "success": true,
        "message": "Pending Friends retrieved",
        "data": {
            "page": 1,
            "next_page": null,
            "total_data": 1,
            "per_page": 10,
            "pfriends": [
                {
                    "id_user_1": 1,
                    "id_user_2": 2,
                    "id_user": 2,
                    "name": "Test Account 1",
                    "email": "testaccount1@gmail.com",
                    "phone_number": "+628123456789",
                    "image": "public/upload/01cdb7d9b7a5bc0408555bcf4e659aa9.png"
                }
            ]
        }
    }
]
```


⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃

### End-point: friendships
Make a friend request
#### Method: POST
>```
>{{base_url}}/friendships
>```
#### Body formdata

|Param|value|Type|
|---|---|---|
|id_user|4|text|


#### Response: 200
```json
[
    {
        "success": true,
        "message": "Request sent",
        "data": [
            {
                "id_user": 2,
                "email": "testaccount1@gmail.com",
                "name": "Test Account 1",
                "image": "public/upload/01cdb7d9b7a5bc0408555bcf4e659aa9.png"
            }
        ]
    }
]
```


⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃

### End-point: friendships/:id_user
Accept a friend request
#### Method: PATCH
>```
>{{base_url}}/friendships/1
>```
#### Body formdata

|Param|value|Type|
|---|---|---|


#### Response: 200
```json
[
    {
        "success": true,
        "message": "Friend request accepted",
        "data": {}
    }
]
```


⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃

### End-point: friendships/:id_user/reject
Reject a friend request
#### Method: DELETE
>```
>{{base_url}}/friendships/1/reject
>```

⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃

### End-point: friendships/:id_user/remove
Delete a friend
#### Method: DELETE
>```
>{{base_url}}/friendships/1/remove
>```

⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃


### End-point: messages/:id_user
Show messages of spesific friend
#### Method: GET
>```
>{{base_url}}/messages/1
>```
#### Body formdata

|Param|value|Type|
|---|---|---|


#### Response: 200
```json
[
    {
        "success": true,
        "message": "messages retrieved",
        "data": {
            "page": 1,
            "next_page": null,
            "total_data": 1,
            "per_page": 10,
            "messages": [
                {
                    "id_message": 40,
                    "id_sender": 2,
                    "id_recipient": 1,
                    "message": "lorem ipsum",
                    "type": "text",
                    "is_read": 0,
                    "created_at": "2023-01-05T03:34:38.136Z"
                }
            ]
        }
    }
]
```


⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃

### End-point: messages/list-conversations
Show list of conversations between authenticated user and his friends
#### Method: GET
>```
>{{base_url}}/messages/list-conversations
>```
#### Body formdata

|Param|value|Type|
|---|---|---|


#### Query Params

|Param|value|
|---|---|
|page|1|
|items|10|


#### Response: 200
```json
[
    {
        "success": true,
        "message": "list conversations retrieved",
        "data": {
            "page": 1,
            "next_page": null,
            "total_data": 1,
            "per_page": 10,
            "list": [
                {
                    "id_user": 1,
                    "name": "Ilham Rahmadhani",
                    "message": "lorem ipsum",
                    "type": "text",
                    "image": "public/upload/c37a3ad4bb2a13ca036f78633c52686e.gif",
                    "created_at": "2023-01-05T03:34:38.136Z",
                    "count_unread": 1
                }
            ]
        }
    }
]
```


⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃

### End-point: messages
Send a new message. it can be a text or an image
#### Method: POST
>```
>{{base_url}}/messages/
>```
#### Body formdata

|Param|value|Type|
|---|---|---|
|id_recipient|1|text|
|message|/D:/Downloads/dummy-user.png|file|


#### Response: 200 (the message is image)
```json
[
    {
        "success": true,
        "message": "Message sent",
        "data": {
            "id_message": 41,
            "id_sender": 2,
            "id_recipient": 1,
            "message": "public/upload/a2bf35f35c8737dcc4fbe4801ab524fd.png",
            "type": "image"
        }
    }
]
```
#### Response: 200 (the message is text)
```json
[
    {
        "success": true,
        "message": "Message sent",
        "data": {
            "id_message": 40,
            "id_sender": 2,
            "id_recipient": 1,
            "message": "lorem ipsum",
            "type": "text"
        }
    }
]
```



⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃

### End-point: messages/:id_message/mark
Mark a message as read
#### Method: PATCH
>```
>{{base_url}}/messages/40/mark
>```
#### Body formdata

|Param|value|Type|
|---|---|---|


#### Response: 200
```json
[
    {
        "success": true,
        "message": "Success mark message as read",
        "data": {
            "id_message": 40,
            "id_recipient": 1,
            "is_read": 1,
            "read_at": "2023-01-05T03:43:34.903Z",
            "created_at": "2023-01-05T03:34:38.150Z",
            "updated_at": "2023-01-05T03:43:34.903Z"
        }
    }
]
```


⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃ ⁃
_________________________________________________
API Dcumentation Powered By: [postman-to-markdown](https://github.com/bautistaj/postman-to-markdown/)
