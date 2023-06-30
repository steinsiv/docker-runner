# Configure a github self hosted runner, running in docker

Small setup to help myself with setting up a runner

### Runner
Register a self hosted runner on host `HOST` for the repository `REPO`. 

Environment variables:

- `ACCESS_TOKEN`: a token with `repo` access. Visit [tokens](https://github.com/settings/tokens) to get yours
- `REPO`: name of repo, e.g. `steinsiv/docker-runner`
- `HOST`: name of the runner. `$(hostname)` is a good choice

Stopping the container will unregister the runner from github

### Test

- `ENVIRONMENT`: value will be added as a label
- `HOST`: value will be used as the name of the runner
- `REPO`: whereto connect this runner
```
$ docker build -t steinsiv/docker-runner:latest .
$ docker run -d -e ENVIRONMENT=test -e ACCESS_TOKEN=ghp_cU... -e HOST=$(hostname) -e REPO=steinsiv/docker-runner -t steinsiv/docker-runner:latest
```