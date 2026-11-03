```
helm package helm/service
```

```
helm install smokeping smokeping-<version>.tgz --create-namespace --namespace smokeping
```
