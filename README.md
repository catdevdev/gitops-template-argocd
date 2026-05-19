# Argo CD Single-Cluster GitOps Template

A minimal public GitOps template for one Kubernetes cluster managed by Argo CD.

The repository uses the app-of-apps pattern:

- `bootstrap/` is applied once with `kubectl`.
- `cluster/` is the root desired state for the cluster.
- `cluster/projects/` contains Argo CD projects.
- `cluster/applicationsets/` contains empty ApplicationSet generators for future apps.
- `platform-apps/` is an empty place for future platform ApplicationSet descriptors.
- `platform/` is an empty place for future platform manifests.
- `apps/` is an empty place for future workload manifests.

## Quick Start

1. Create a new repository from this template.
2. Replace the template repo URL in all manifests:

   ```bash
   export OLD_URL="https://github.com/catdevdev/gitops-template-argocd.git"
   export NEW_URL="https://github.com/<owner>/<repo>.git"
   rg -l "$OLD_URL" | xargs perl -pi -e "s|$OLD_URL|$NEW_URL|g"
   ```

3. Commit and push your changes:

   ```bash
   git add .
   git commit -m "Configure repository URL"
   git push
   ```

4. Install Argo CD in the cluster.
5. Bootstrap the root application:

   ```bash
   kubectl apply -f bootstrap/root-application.yaml
   ```

Argo CD will reconcile everything under `cluster/`. By default this template deploys no workloads and no platform addons.

## Add a Workload

Create a new directory under `apps/<app-name>/`, add Kubernetes manifests, and add an app descriptor:

```yaml
name: my-app
namespace: my-app
sourcePath: apps/my-app/manifests
```

The `cluster/applicationsets/workload-apps.yaml` ApplicationSet will generate the Argo CD `Application`.

## Notes

- The AppProject is intentionally broad for template usability. Tighten `sourceRepos`, `destinations`, and resource whitelists for production.
- Keep secrets out of Git. Use External Secrets, Sealed Secrets, SOPS, or your platform's secret manager.
- This template assumes one in-cluster Kubernetes target: `https://kubernetes.default.svc`.
