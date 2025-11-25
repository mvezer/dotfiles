# alias pfw="port-forward.sh stop && port-forward.sh start"

alias awsdev='export AWS_PROFILE=dev && aws sso login --profile dev && aws sts get-caller-identity --profile dev | jq -r ".Arn" && aws eks update-kubeconfig --region eu-central-1 --name natix-dev-eks --profile dev && echo "Switched to dev "'

alias pfw='telepresence connect --context arn:aws:eks:eu-central-1:739275469289:cluster/natix-dev-eks -n driveand'

alias qr='qrencode -t UTF8'
