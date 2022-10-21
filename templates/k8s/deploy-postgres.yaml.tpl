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
          volumeMounts:
            - mountPath: /var/lib/postgresql/data
              name: escolalms-postgres-persistent-storage
      volumes:
        - name: escolalms-postgres-persistent-storage
          persistentVolumeClaim:
            claimName: escolalms-postgres-pv-claim

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

---
apiVersion: v1
kind: PersistentVolume
metadata:
    name: escolalms-postgres-pv-volume
    namespace: escolalms
    labels:
        type: local
spec:
    storageClassName: "standard-rwo"
    capacity:
        storage: 5Gi
    accessModes:
        - ReadWriteOnce
    hostPath:
        path: /var/lib/postgresql/data
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
    name: escolalms-postgres-pv-claim
    namespace: escolalms
spec:
    storageClassName: "standard-rwo"
    accessModes:
        - ReadWriteOnce
    resources:
        requests:
            storage: 5Gi
