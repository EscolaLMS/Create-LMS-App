apiVersion: apps/v1
kind: Deployment
metadata:
  name: escolalms-reportbro
  namespace: escolalms
spec:
  selector:
    matchLabels:
      app: escolalms-reportbro
      component: reportbro
  template:
    metadata:
      labels:
        app: escolalms-reportbro
        component: reportbro
    spec:
      containers:
      - name: escolalms-reportbro
        image: escolalms/reportbro:latest
        imagePullPolicy: Always
        envFrom:
        - configMapRef:
            name: laravel-config
        ports:
          - name: http
            containerPort: 8000
            protocol: TCP
---
apiVersion: v1
kind: Service
metadata:
    name: escolalms-reportbro-service
    namespace: escolalms
spec:
    selector:
        app: escolalms-reportbro
    type: ClusterIP
    ports:
    - name: http
      port: 8000
      protocol: TCP
      targetPort: http
