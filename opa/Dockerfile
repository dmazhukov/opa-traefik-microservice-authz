FROM openpolicyagent/opa:0.55.0

COPY --chown=1000:1000 policy.rego /policy.rego

EXPOSE 8181

CMD ["run", "--log-level=debug", "--server", "/policy.rego"]