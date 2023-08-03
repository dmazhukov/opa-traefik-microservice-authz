package authz
import future.keywords.in
import future.keywords.if

default blocked = false

blocked_groups_app1 = ["group2", "group3"]
blocked_groups_app2 = ["group1"]

# check if token empty or invalid
blocked {
	not token.payload
}

blocked {
  print("Entering block by group for app1")
  print("input=", input)
  print("token payload=", token.payload)
  some group in token.payload.groups    	
  blocked_groups_app1[_] == group
}

blocked {
  print("Entering block by appid")
  token.payload.appid != "app1"
}

# Token verification is required
token = {"payload": payload} {
  [_, payload, _] := io.jwt.decode(input.token)
}
