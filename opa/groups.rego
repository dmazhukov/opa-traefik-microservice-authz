package authz
import future.keywords.in
import future.keywords.if

default blocked = true
default invalid_token = false

blocked_groups_app1 = ["group2", "group3"]
blocked_groups_app2 = ["group1"]

missing_token {
	print("check if token exists")
    not token.payload
}

invalid_token {
	print("check if token valid")
    print("token payload=", token.payload)
    not token.payload.groups
    not token.payload.appid

}

blocked_by_group {
  print("Entering block by group for app1")
  print("input=", input)
  print("token payload=", token.payload)
  some group in token.payload.groups    	
  blocked_groups_app1[_] == group
}

blocked_by_appid {
  print("Entering block by appid")
  token.payload.appid != "app1"
}

blocked := false {
    not invalid_token
    not missing_token
    not blocked_by_group
    not blocked_by_appid
}


# Token verification is required
token = {"payload": payload} {
  [_, payload, _] := io.jwt.decode(input.token)
}
