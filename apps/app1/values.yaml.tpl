apps:
  - name: app1
    replicas: 1
    image: gcr.io/$PROJECT_ID/app1
    port: 5000
    ingress:
      enabled: true
      name: app1-ingress
      className: nginx
      host: app1.$INGRESS_IP.nip.io
      serviceName: app1
      servicePort: 80
      annotations:
        nginx.ingress.kubernetes.io/rewrite-target: /

autoscaling:
  enabled: true
  minReplicas: 1
  maxReplicas: 5
  targetCPUUtilizationPercentage: 70
  targetMemoryUtilizationPercentage: 80
