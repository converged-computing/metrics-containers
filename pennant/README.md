# Pennant

The GPU and flux GPU variants here are not automated in the repository - they were built manually (locally)
and pushed to the same registry. We first built the gpu variant to try with the "add on the fly" flux view:

```bash
docker build -f Dockerfile.gpu -t ghcr.io/converged-computing/metric-pennant:gpu .
docker push ghcr.io/converged-computing/metric-pennant:gpu
```

We found that flux (hwloc) didn't detect the GPU, and we think it's because the view install with hwloc
is separate from the cuda install. So we decided to try a base image that also has flux:

```bash
docker build -f Dockerfile.flux-gpu -t ghcr.io/converged-computing/metric-pennant:gpu .
docker push ghcr.io/converged-computing/metric-pennant:gpu
```
