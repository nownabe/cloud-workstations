# cloud-workstations

## Usage

Clone this repository.

```bash
git clone https://github.com/nownabe/cloud-workstations
```

Build a Docker image and create a workstation.

```bash
region=asia-east1
gcloud config set project YOUR-PROJECT
gcloud artifacts repositories create \
  workstations \
  --location "$region" \
  --repository-format docker
gcloud builds submit \
  --substitutions _LOCATION="$region" \
gcloud beta workstations clusters create \
  default-cluster \
  --region "$region"
gcloud beta workstations configs create \
  "$USER-config" \
  --cluster default-cluster \
  --region "$region" \
  --container-custom-image "$region-docker.pkg.dev/$(gcloud config get project)/workstations/code-oss:latest" \
  --container-env "RUNUSER=$USER,DOTFILES=https://github.com/nownabe/dotfiles"
gcloud beta workstations create \
  "$USER-workstation" \
  --cluster default-cluster \
  --config "$USER-config" \
  --region "$region"
```
