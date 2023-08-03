package authz
import future.keywords.in

default blocked = false

blocked_groups_app1 = ["group2", "group3"]
blocked_groups_app2 = ["group1"]

blocked {
  print("Entering block by group for app1")
  print("input=", input)
	some group in token.payload.groups    	
  blocked_groups_app1[_] == group
}

blocked {
  print("Entering block by appid")
  token.payload.appid != "app1"
}

# Token verification is required
token = {"payload": payload} {
  [header, payload, signature] := io.jwt.decode(input.token)
}
