Set-Variable -Name "ARGOCD_VERSION" -Value "7.4.5"
k3d cluster create bob --api-port localhost:6550 -p "8080:80@loadbalancer" --agents 2
kubectl create namespace argocd
kubectl config set-context --current --namespace=argocd
helm install argo-cd argo-cd --repo https://argoproj.github.io/argo-helm --version $ARGOCD_VERSION --set configs.params."server\.insecure"=true --set configs.params."server\.rootpath"=/argocd --wait
kubectl create ingress argocd --class=traefik --rule=/argocd*=argo-cd-argocd-server:80 --annotation ingress.kubernetes.io/ssl-redirect=false
write-host "url http://localhost:8080/argocd username admin `n password:"
kubectl get secret argocd-initial-admin-secret -o go-template="{{(.data.password|base64decode)}}"