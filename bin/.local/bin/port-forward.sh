#!/bin/bash

# Check if KUBECONFIG is set, if not, set it to our standard dev k8s config file path
if [ -z "$1" ] || [ "$1" == "start" ]; then
  if [ -z "$KUBECONFIG" ]; then
    if [[ "$2" == "stage" ]]; then
      env="driveand-staging-config"
    elif [[ "$2" == "prod" ]]; then
      env="driveand-prod-config"
    else
      env="dev-driveand-config"
    fi
    # read -e -i "y" -p "KUBECONFIG variable is not set. Do you want to set it automatically to $HOME/.kube/$env? (y/n) " answer
    # if [ "$answer" == "y" ]; then
      export KUBECONFIG=$HOME/.kube/$env
      echo "KUBECONFIG set to $KUBECONFIG"
    # else
    #   echo "Please set KUBECONFIG variable to the path of your Kubernetes configuration file manually."
    #   exit 1
    # fi
  fi  
fi

if [ -z "$1" ] || [ "$1" == "start" ]; then
  # Forward port for each Kubernetes service
  kubectl --kubeconfig ~/.kube/config port-forward service/app-device 3002:3000 -n driveand &
  kubectl --kubeconfig ~/.kube/config port-forward service/app-event 3003:3000 -n driveand &
  kubectl --kubeconfig ~/.kube/config port-forward service/app-user 3004:3000 -n driveand &
  kubectl --kubeconfig ~/.kube/config port-forward service/config-manager 3017:3000 -n driveand &
  kubectl --kubeconfig ~/.kube/config port-forward service/gw 8080:8080 -n driveand &
  kubectl --kubeconfig ~/.kube/config port-forward service/inbox 3013:3000 -n driveand &
  kubectl --kubeconfig ~/.kube/config port-forward service/keycloak 8090:8080 -n driveand &
  kubectl --kubeconfig ~/.kube/config port-forward service/location 3005:3000 -n driveand &
  kubectl --kubeconfig ~/.kube/config port-forward service/mailerlite 3019:3019 -n driveand &
  kubectl --kubeconfig ~/.kube/config port-forward service/notification 3001:3000 -n driveand &
  kubectl --kubeconfig ~/.kube/config port-forward service/point-system 3006:3000 -n driveand &
  kubectl --kubeconfig ~/.kube/config port-forward service/prelaunch 3014:3014 -n driveand &
  kubectl --kubeconfig ~/.kube/config port-forward service/product 3007:3007 -n driveand &
  kubectl --kubeconfig ~/.kube/config port-forward service/redeem 3011:3000 -n driveand &
  kubectl --kubeconfig ~/.kube/config port-forward service/referral 3012:3000 -n driveand &
  kubectl --kubeconfig ~/.kube/config port-forward service/saleor-api 8000:8000 -n driveand &
  kubectl --kubeconfig ~/.kube/config port-forward service/saleor-dashboard 9000:9000 -n driveand &
  kubectl --kubeconfig ~/.kube/config port-forward service/stormfly-srvc 3015:3015 -n driveand &
  kubectl --kubeconfig ~/.kube/config port-forward service/stormfly-ui 3016:3016 -n driveand &
  kubectl --kubeconfig ~/.kube/config port-forward service/strapi 1337:1337 -n driveand &
  kubectl --kubeconfig ~/.kube/config port-forward service/transaction 3008:3000 -n driveand &
  kubectl --kubeconfig ~/.kube/config port-forward service/user-action 3009:3000 -n driveand &
  kubectl --kubeconfig ~/.kube/config port-forward service/voting 3010:3010 -n driveand &
  kubectl --kubeconfig ~/.kube/config port-forward service/gamification 3020:3000 -n driveand &
  # kubectl --kubeconfig ~/.kube/config port-forward service/reward 3022:3000 -n driveand &
  kubectl --kubeconfig ~/.kube/config port-forward service/event-mq 5672:5672 -n driveand &
  kubectl --kubeconfig ~/.kube/config port-forward service/mlm 3024:3000 -n driveand &
  kubectl --kubeconfig ~/.kube/config port-forward service/vgamification 3021:3000 -n driveand &  
  kubectl --kubeconfig ~/.kube/config port-forward service/wallet 3018:3000 -n driveand &
  kubectl --kubeconfig ~/.kube/config port-forward service/map-coverage 3026:3000 -n driveand &
  kubectl --kubeconfig ~/.kube/config port-forward service/stormfly-users 3115:3015 -n driveand &
  kubectl --kubeconfig ~/.kube/config port-forward service/stormfly-gamification 3121:3021 -n driveand &
  kubectl --kubeconfig ~/.kube/config port-forward service/tap-report 3027:3000 -n driveand &
  kubectl --kubeconfig ~/.kube/config port-forward service/tesla 3028:3000 -n driveand &
  kubectl --kubeconfig ~/.kube/config port-forward service/vx360-point-system 3029:3000 -n driveand &
  kubectl --kubeconfig ~/.kube/config port-forward service/vx360 3030:3000 -n driveand &
  kubectl --kubeconfig ~/.kube/config port-forward service/sli 3023:3000 -n driveand &
  kubectl --kubeconfig ~/.kube/config port-forward service/vx360-upload-pipeline 3025:3000 -n driveand &
# echo "Port forwarding started."
  
elif [ "$1" == "stop" ]; then
  # Kill the background jobs that are forwarding the ports
  kill_processes() {
    local port=$1
    lsof -i :"$port" | awk '{print $2}' | grep -v PID | xargs kill -9 2>/dev/null
  }

  ports=(1337 3001 3002 3003 3004 3005 3006 3007 3008 3009 3010 3011 3012 3013 3014 3015 3016 3017 3018 3019 3020 3021 3022 3023 3024 3025 3026 3027 3028 3029 3030 3115 3121 5672 8000 8080 8090 9000)

  for port in "${ports[@]}"; do
    kill_processes "$port"
  done

  pkill -f "~/.kube/config port-forward"
  sudo pkill -f "~/.kube/config port-forward"

  echo "Port forwarding stopped."
  
else
  echo "Usage: $0 [start|stop]"
fi
