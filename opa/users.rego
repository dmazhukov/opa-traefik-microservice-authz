package authz
import future.keywords.in

default allow = false

allowed_users_api1 = ["user1@tkqlm.onmicrosoft.com"]
allowed_users_api2 = ["user2@tkqlm.onmicrosoft.com"]

allow {
    print("Entering allow1")
    print("input", input)
    startswith(input.path, "/api-1")
    token.payload.email in allowed_users_api1
}

allow {
    print("Entering allow2")
    print("input", input)
    startswith(input.path, "/api-2")
    token.payload.email in allowed_users_api2
}

# Token verification is required
token = {"payload": payload} {
  [_, payload, _] := io.jwt.decode(input.token)
}
