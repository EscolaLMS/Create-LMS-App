apiVersion: apps/v1
kind: Deployment
metadata:
  name: escolalms-mailhog
  namespace: escolalms
spec:
  selector:
    matchLabels:
      app: escolalms-mailhog
      component: mailhog
  template:
    metadata:
      labels:
        app: escolalms-mailhog
        component: mailhog
    spec:
      containers:
      - name: escolalms-mailhog
        image: mailhog/mailhog:latest
        imagePullPolicy: Always
        envFrom:
        - configMapRef:
            name: laravel-config
        ports:
          - name: http
            containerPort: 8025
            protocol: TCP
          - name: smtp
            containerPort: 1025
            protocol: TCP
---
apiVersion: v1
kind: Service
metadata:
    name: escolalms-mailhog-service
    namespace: escolalms
spec:
    selector:
        app: escolalms-mailhog
    type: ClusterIP
    ports:
    - name: http
      port: 8025
      protocol: TCP
      targetPort: http
     
    - name: smtp
      port: 1025
      protocol: TCP
      targetPort: smtp
     