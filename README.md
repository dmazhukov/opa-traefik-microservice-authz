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
curl http://localhost:88/api-1/
```

Generate a JWT for AuthZ for user1

```bash
export TOKEN1=`ruby -rjwt -e 'print JWT.encode({"email":"user1@tkqlm.onmicrosoft.com"}, nil, "none")'`
```
Test token: eyJhbGciOiJub25lIn0.eyJlbWFpbCI6InVzZXIxQHRrcWxtLm9ubWljcm9zb2Z0LmNvbSJ9.

Generate a JWT for AuthZ for user2

```bash
export TOKEN2=`ruby -rjwt -e 'print JWT.encode({"email":"user2@tkqlm.onmicrosoft.com"}, nil, "none")'`
```
Test token: eyJhbGciOiJub25lIn0.eyJlbWFpbCI6InVzZXIyQHRrcWxtLm9ubWljcm9zb2Z0LmNvbSJ9.

Request `api-1` with the `user1` token

```bash
curl -H "OPA-Authorization: $TOKEN1" http://localhost:88/api-1/
```

Try requesting `api-1` with the `user2` token

```bash
curl -H "OPA-Authorization: $TOKEN2" http://localhost:88/api-1/
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
