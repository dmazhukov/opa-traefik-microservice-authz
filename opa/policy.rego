package authz
import future.keywords.in

default allow = false

allowed_users_app1 = ["user1@tkqlm.onmicrosoft.com"]
allowed_users_app2 = ["user2@tkqlm.onmicrosoft.com"]

allow {
# Allow access to groups and specific email for app1
# test token: eyJhbGciOiJub25lIn0.eyJhcHBpZCI6ImFwcDEiLCJncm91cHMiOlsiZjU1ZTc4MjYtODgzZS00OGQyLTg0MmUtNjVjN2QwMmU4YWQxIl0sImVtYWlsIjoidXNlcjFAdGtxbG0ub25taWNyb3NvZnQuY29tIn0.
  print("Entering allow1")
  print("input=", input)
  token.payload.appid == "app1"
  token.payload.groups[_] == "f55e7826-883e-48d2-842e-65c7d02e8ad1"
  token.payload.email in allowed_users_app1
}



allow  {
# Allow access to all members of dev group and specific email for app2
# test token: eyJhbGciOiJub25lIn0.eyJhcHBpZCI6ImFwcDIiLCJncm91cHMiOlsiNDBjNDcxN2ItNzZiNi00ZGZhLThhMDktYzRhYmI2Mjg4MzdiIl0sImVtYWlsIjoidXNlcjJAdGtxbG0ub25taWNyb3NvZnQuY29tIn0.
  print("Entering allow2")
  print("input", input)
  token.payload.appid == "app2"
  token.payload.groups[_] == "40c4717b-76b6-4dfa-8a09-c4abb628837b"
  token.payload.email in allowed_users_app2

}

# allow {
#     startswith(input.path, "/api-1")
#     token.payload.roles[_] == "api-1-users"
# }

# allow {
#     startswith(input.path, "/api-2")
#     token.payload.roles[_] == "api-2-users"
# }

# Token verification is required
token = {"payload": payload} {
  [header, payload, signature] := io.jwt.decode(input.token)
}
