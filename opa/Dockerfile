FROM openpolicyagent/opa:0.38.0

COPY policy.rego /root/policy.rego

EXPOSE 8181

CMD ["run", "--log-level=debug", "--server", "/root/policy.rego"]