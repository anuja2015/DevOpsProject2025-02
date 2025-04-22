### Create namespace webapps

     kubectl create ns webapps
     
### Create a service account

        apiVersion: v1
        kind: ServiceAccount
        metadata:
          name: jenkins
          namespace: webapps
        automountServiceAccountToken: false

    kubectl apply -f 

### Create a role and rolebinding for sa

    apiVersion: rbac.authorization.k8s.io/v1
    kind: Role
    metadata:
      name: app-role
      namespace: webapps
    rules:
      - apiGroups:
            - ""
            - apps
            - autoscaling
            - batch
            - extensions
            - policy
            - rbac.authorization.k8s.io
        resources:
          - pods
          - secrets
          - componentstatuses
          - configmaps
          - daemonsets
          - deployments
          - events
          - endpoints
          - horizontalpodautoscalers
          - ingress
          - jobs
          - limitranges
          - namespaces
          - nodes
          - pods
          - persistentvolumes
          - persistentvolumeclaims
          - resourcequotas
          - replicasets
          - replicationcontrollers
          - serviceaccounts
          - services
        verbs: ["get", "list", "watch", "create", "update", "patch", "delete"]

### Create rolebinding for jenkins service account and app-role

    apiVersion: rbac.authorization.k8s.io/v1
    kind: RoleBinding
    metadata:
      name: app-rolebinding
      namespace: webapps
    roleRef:
      apiGroup: rbac.authorization.k8s.io
      kind: Role
      name: app-role
    subjects:
    - namespace: webapps
      kind: ServiceAccount
      name: jenkins


### Create service account token (non-expiring)

    apiVersion: v1
    kind: Secret
    type: kubernetes.io/service-account-token
    metadata:
      name: jenkins-secret
      annotations:
        kubernetes.io/service-account.name: jenkins




### Deploy an ingress controller

    kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.12.1/deploy/static/provider/baremetal/deploy.yaml
