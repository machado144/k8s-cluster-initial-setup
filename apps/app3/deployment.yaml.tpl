apiVersion: apps/v1
kind: Deployment
metadata:
  name: app3
spec:
  replicas: 1
  selector:
    matchLabels:
      app: app3
  template:
    metadata:
      labels:
        app: app3
    spec:
      containers:
      - name: app3
        image: gcr.io/$PROJECT_ID/app3
        ports:
        - containerPort: 5000
---
apiVersion: v1
kind: Service
metadata:
  name: app3
spec:
  selector:
    app: app3
  ports:
    - protocol: TCP
      port: 80
      targetPort: 5000
