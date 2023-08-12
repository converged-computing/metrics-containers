# metrics-operator containers

![img/metrics-operator-banner.png](img/metrics-operator-banner.png)

These are metric containers to support the [metrics operator](https://github.com/converged-computing/metrics-operator). They are built separately to ensure modularity of
development.

 - View the ⭐️ [Metrics Operator Documentation](https://converged-computing.github.io/metrics-operator/) ⭐️

## Containers

Metrics for the Metrics Operator are backed by containers. For example, storage metrics need to deploy containers that create PV/PVCs for some backend of choice, and the containers need to have the software that monitors the storage. Application metrics are similar, but will have software to monitor process(es). We store (and provide automated builds) for those containers here. Since metrics software can span multiple spaces (e.g., perf vs. storage) we namespace
them by tool.

 - [sysstat](sysstat) provided via [github.com/sysstat/sysstat](https://github.com/sysstat/sysstat)
 - [fio](fio)
 - [lammps](lammps)
 - [hacc](hacc) (this does not work outside of PowerPC)
 - [nekbone](nekbone)
 - [osu-benchmark](osu-benchmark)

## License

HPCIC DevTools is distributed under the terms of the MIT license.
All new contributions must be made under this license.

See [LICENSE](https://github.com/converged-computing/cloud-select/blob/main/LICENSE),
[COPYRIGHT](https://github.com/converged-computing/cloud-select/blob/main/COPYRIGHT), and
[NOTICE](https://github.com/converged-computing/cloud-select/blob/main/NOTICE) for details.

SPDX-License-Identifier: (MIT)

LLNL-CODE- 842614
