apiVersion: apps/v1
kind: Deployment
metadata:
  name: escolalms-frontend
  namespace: escolalms
spec:
  selector:
    matchLabels:
      app: escolalms-frontend
      component: frontend
  template:
    metadata:
      labels:
        app: escolalms-frontend
        component: frontend
    spec:
      containers:
      - name: escolalms-frontend
        image: escolalms/demo:latest
        imagePullPolicy: Always
        envFrom:
        - configMapRef:
            name: laravel-config
        ports:
          - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
    name: escolalms-frontend-service
    namespace: escolalms
spec:
    selector:
        app: escolalms-frontend
    type: ClusterIP
    ports:
        -   port: 80
            targetPort: 80