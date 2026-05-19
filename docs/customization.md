# Customization Checklist

Use this checklist after creating a repository from the template.

1. Replace all occurrences of `https://github.com/catdevdev/gitops-template-argocd.git`.
2. Rename the root application if you manage more than one Argo CD root app.
3. Tighten the `single-cluster` AppProject for your allowed repositories and namespaces.
4. Delete `apps/sample-web` after adding a real workload, or keep it as a smoke test.
5. Enable only the platform examples you actually need.
6. Replace `example.com`, `admin@example.com`, `192.0.2.10`, and `vault.example.com` before enabling optional examples.
