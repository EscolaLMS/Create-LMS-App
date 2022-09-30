apiVersion: apps/v1
kind: Deployment
metadata:
  name: escolalms-postgres
  namespace: escolalms
  labels:
    app: escolalms-postgres
spec:
  replicas: 1
  selector:
    matchLabels:
      app: escolalms-postgres
  template:
    metadata:
      labels:
        app: escolalms-postgres
    spec:
      containers:
        - name: postgres
          image: postgres:latest
          imagePullPolicy: "IfNotPresent"
          ports:
            - containerPort: 5432
          envFrom:
            - configMapRef:
                name: laravel-config
#          volumeMounts:
#            - mountPath: /var/lib/postgresql/data
#              name: postgredb
#      volumes:
#        - name: postgredb
#          hostPath:
#            path: "/mnt/escolalms/psql"
---
apiVersion: v1
kind: Service
metadata:
  name: escolalms-postgres
  namespace: escolalms
  labels:
    app: escolalms-postgres
spec:
  type: ClusterIP
  ports:
   - port: 5432
     protocol: TCP
     targetPort: 5432
  selector:
   app: escolalms-postgres




