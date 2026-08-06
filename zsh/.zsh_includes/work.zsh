# alias pfw="port-forward.sh stop && port-forward.sh start"

# alias awsdev='export AWS_PROFILE=dev && aws sso login --profile dev && aws sts get-caller-identity --profile dev | jq -r ".Arn" && aws eks update-kubeconfig --region eu-central-1 --name natix-dev-eks --profile dev && echo "Switched to dev "'
#
# alias awsprod='export AWS_PROFILE=prod && aws sso login --profile prod && aws sts get-caller-identity --profile prod | jq -r ".Arn" && aws eks update-kubeconfig --region eu-central-1 --name natix-prod-eks --profile prod && echo "Switched to prod"'
#
# alias pfw='telepresence connect --context arn:aws:eks:eu-central-1:739275469289:cluster/natix-dev-eks -n driveand'
#
# alias qr='qrencode -t UTF8'
#
# alias now='UT_PRECISION=millisecond ut generate'
#
# alias rabbit-mq-dev="kubectl port-forward svc/event-mq 15672:15672 -n driveand & sleep 3 && open http://localhost:15672"

export JAVA_HOME="/Users/mat/.sdkman/candidates/java/21.0.12-tem"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
