apiVersion: apps/v1
kind: Deployment
metadata:
  name: escolalms-redis
  namespace: escolalms
  labels:
    app: escolalms-redis
spec:
  replicas: 1
  selector:
    matchLabels:
      app: escolalms-redis
  template:
    metadata:
      labels:
        app: escolalms-redis
    spec:
      containers:
      -   name: redis
          image: redis:latest
          envFrom:
            - configMapRef:
                name: laravel-config
          ports:
          - containerPort: 6379
          command:
          - redis-server
          args:
          - --requirepass
          - $(LARAVEL_REDIS_PASSWORD)
---
apiVersion: v1
kind: Service
metadata:
  name: escolalms-redis
  namespace: escolalms
  labels:
    app: escolalms-redis
spec:
  type: ClusterIP
  ports:
   - port: 6379
     protocol: TCP
     targetPort: 6379
  selector:
   app: escolalms-redis




