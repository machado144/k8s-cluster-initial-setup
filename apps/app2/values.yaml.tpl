apps:
  - name: app2
    replicas: 1
    image: gcr.io/$PROJECT_ID/app2
    port: 5000
    ingress:
      enabled: false

autoscaling:
  enabled: true
  minReplicas: 1
  maxReplicas: 3
  targetCPUUtilizationPercentage: 60
  targetMemoryUtilizationPercentage: 75
