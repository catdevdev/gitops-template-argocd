# Argo CD Single-Cluster GitOps Template

A small, public GitOps template for one Kubernetes cluster managed by Argo CD.

The repository uses the app-of-apps pattern:

- `bootstrap/` is applied once with `kubectl`.
- `cluster/` is the root desired state for the cluster.
- `cluster/projects/` contains Argo CD projects.
- `cluster/applicationsets/` generates Argo CD Applications from files in this repo.
- `platform-apps/` contains optional Helm and config application descriptors.
- `platform/` contains optional platform manifests.
- `apps/` contains workload applications.

## Quick Start

1. Create a new repository from this template.
2. Replace the template repo URL in all manifests:

   ```bash
   export OLD_URL="https://github.com/catdevdev/gitops-template-argocd.git"
   export NEW_URL="https://github.com/<owner>/<repo>.git"
   rg -l "$OLD_URL" | xargs perl -pi -e "s|$OLD_URL|$NEW_URL|g"
   ```

3. Commit and push your changes.
4. Install Argo CD in the cluster.
5. Bootstrap the root application:

   ```bash
   kubectl apply -f bootstrap/root-application.yaml
   ```

Argo CD will reconcile everything under `cluster/`. The default template deploys only a safe `sample-web` workload. Platform controllers and addons are provided as `.example` files and stay disabled until you rename and edit them.

## Enable Optional Platform Apps

Examples are disabled by file extension. To enable one, copy or rename it to `.yaml`, edit placeholders, commit, and let Argo CD sync.

Examples:

```bash
cp platform-apps/controllers/cert-manager.yaml.example platform-apps/controllers/cert-manager.yaml
cp platform-apps/controllers/external-secrets.yaml.example platform-apps/controllers/external-secrets.yaml
cp platform-apps/addons/external-dns.yaml.example platform-apps/addons/external-dns.yaml
cp platform-apps/configs/cert-manager-issuers.yaml.example platform-apps/configs/cert-manager-issuers.yaml
```

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
