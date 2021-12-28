#!/bin/bash
# Snippets for interacting & performing updates on matrix-synapse server & database.

## Manually update password for a user in synapse postgresql database
# 1: Generate a hash by running:
/opt/venvs/matrix-synapse/bin/hash_password
# Run the following query on your synapse psql databse:
UPDATE users SET password_hash='<the hash here>' WHERE name='@<username>:<homeserver domain>';

## CURL request to get an access token for a particular user:
curl -XPOST -d '{"type":"m.login.password", "user":"<username>", "password":"<plain_text_password>"}' "https://<homeserver_domain>/_matrix/client/r0/login"

## Send message as a user (must get access token as shown above; room_id looks like: !FUsJEhjhKcFSBczDVt:subtlefu.ge, get it from room settings -> advanced):
curl -XPOST -d '{"msgtype":"m.text", "body":"Hello from '"$USER"'"}' "https://<homeserver_domain>/_matrix/client/r0/rooms/\<room_id>/send/m.room.message?access_token=<access_token>"

# send formatted text:
curl -XPOST -d '{"msgtype":"m.text", "body":"**Hello**","format":"org.matrix.custom.html","formatted_body":"<strong>hello</strong>"}'  "https://<homeserver_domain>/_matrix/client/r0/rooms/\<room_id>/send/m.room.message?access_token=<access_token>"

# register new user:
curl -XPOST -d '{"username":"example", "password":"wordpass", "auth": {"type":"m.login.dummy"}}' "https://localhost:8448/_matrix/client/r0/register"

{
    "access_token": "QGV4YW1wbGU6bG9jYWxob3N0.AqdSzFmFYrLrTmteXc",
    "home_server": "localhost",
    "user_id": "@example:localhost"
}

#Join room via alias:
curl -XPOST -d '{}' "https://localhost:8448/_matrix/client/r0/join/%21asfLdzLnOdGRkdPZWu:localhost?access_token=YOUR_ACCESS_TOKEN"

