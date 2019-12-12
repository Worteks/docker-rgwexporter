# Sweet RadosGWExporter

Forked from https://github.com/blemmenes/radosgw_usage_exporter

[Prometheus](https://prometheus.io/) exporter that scrapes
[Ceph](http://ceph.com/) RADOSGW usage information (operations and buckets).
This information is gathered from a RADOSGW using the
[Admin Operations API](http://docs.ceph.com/docs/master/radosgw/adminops/).

Build with:
```
$ make build
```

Test with:
```
$ make run
```

Build in OpenShift:

```
$ make ocbuild
```

Cleanup OpenShift assets:

```
$ make ocpurge
```

Environment variables and volumes
----------------------------------

The image recognizes the following environment variables that you can set during
initialization by passing `-e VAR=VALUE` to the Docker `run` command.

|    Variable name           |    Description            | Default       |
| :------------------------- | ------------------------- | ------------- |
|  `EXPORTER_PORT`           | RadosGW Exporter Port     | `9113`        |
|  `RADOSGW_HOST`            | RadosGW Endpoint Host     | `127.0.0.1`   |
|  `RADOSGW_PORT`            | RadosGW Endpoint Port     | `8080`        |
|  `RADOSGW_PROTO`           | RadosGW Endpoint Proto    | `http`        |
