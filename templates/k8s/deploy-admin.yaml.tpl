apiVersion: apps/v1
kind: Deployment
metadata:
  name: escolalms-admin
  namespace: escolalms
spec:
  selector:
    matchLabels:
      app: escolalms-admin
      component: admin
  template:
    metadata:
      labels:
        app: escolalms-admin
        component: admin
    spec:
      containers:
      - name: escolalms-admin
        image: escolalms/admin:latest
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
    name: escolalms-admin-service
    namespace: escolalms
spec:
    selector:
        app: escolalms-admin
    type: ClusterIP
    ports:
        -   port: 80
            targetPort: 80


