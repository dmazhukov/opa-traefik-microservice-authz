# Microservices Authorization using Open Policy Agent and API Gateway
This is a proof of concept implementation of using Open Policy Agent for microservices authorization in API Gateway (Traefik).

<a href="https://blog.appsecco.com/microservices-authorization-using-open-policy-agent-and-traefik-api-gateway-ae30f3bf2846" target="_blank">
    <img src="docs/banner.png"></img>
</a>

> Detailed description of our use-case and implementation is available in our blog - 
> [https://blog.appsecco.com/microservices-authorization-using-open-policy-agent-and-traefik-api-gateway-ae30f3bf2846](https://blog.appsecco.com/microservices-authorization-using-open-policy-agent-and-traefik-api-gateway-ae30f3bf2846)

## Why

Authentication and authorization in a microservices environment is non-trivial. This becomes especially true when identity and authorization controls are distributed across different applications.

In this proof of concept scenario, we want to demonstrate using the *API Gateway* pattern for centralised enforcement of authorisation rules.

To do this, we use following components

1. Traefik (API Gateway)
2. Open Policy Agent (AuthZ policy management and evaluation)
3. Middleware (custom) for connecting Traefik with Open Policy Agent

## Architecture

![](docs/mermaid-diagram-20200403151111.png)

## Setup

```bash
docker-compose up
```

## Test

Request `api-1` without authorization

```bash
curl http://localhost:9000/api-1/
```

Generate a JWT for AuthZ for app1

```bash
export TOKEN1=`ruby -rjwt -e 'print JWT.encode({"appid":"app1","groups":["f55e7826-883e-48d2-842e-65c7d02e8ad1"],"email":"user1@tkqlm.onmicrosoft.com"}, nil, "none")'`
```
Test token: eyJhbGciOiJub25lIn0.eyJhcHBpZCI6ImFwcDEiLCJncm91cHMiOlsiZjU1ZTc4MjYtODgzZS00OGQyLTg0MmUtNjVjN2QwMmU4YWQxIl0sImVtYWlsIjoidXNlcjFAdGtxbG0ub25taWNyb3NvZnQuY29tIn0.

Generate a JWT for AuthZ for app2

```bash
export TOKEN2=`ruby -rjwt -e 'print JWT.encode({"appid":"app2","groups":["40c4717b-76b6-4dfa-8a09-c4abb628837b"],"email":"user2@tkqlm.onmicrosoft.com"}, nil, "none")'`
```
Test token: eyJhbGciOiJub25lIn0.eyJhcHBpZCI6ImFwcDIiLCJncm91cHMiOlsiNDBjNDcxN2ItNzZiNi00ZGZhLThhMDktYzRhYmI2Mjg4MzdiIl0sImVtYWlsIjoidXNlcjJAdGtxbG0ub25taWNyb3NvZnQuY29tIn0.


Request `api-1` with the token

```bash
curl -H "OPA-Authorization: $TOKEN1" http://localhost:9000/api-1/
```

Try requesting `api-2` with the same token

```
curl -H "OPA-Authorization: $TOKEN1" http://localhost:9000/api-2/
```

## Whats inside?

* [Traefik](https://containo.us/traefik/) is used as the API Gateway
  * Check configuration in `traefik/traefik.yml` and `traefik/dynamic.yml`
* [Open Policy Agent](https://www.openpolicyagent.org/) is used for centralized authorization policy evaluation
  * Check `opa/policy.rego`
* 3 backend service is implemented
  * `/` is public
  * `/api-1` is available to any user with `role=api-1-users`
  * `/api-2` is available to any user with `role=api-2-users`

## Reference

* https://www.openpolicyagent.org/docs/latest/http-api-authorization/
* https://docs.traefik.io/
* https://engineering.etermax.com/api-authorization-with-kubernetes-traefik-and-open-policy-agent-23647fc384a1
