---
apiVersion: v1
kind: PersistentVolume
metadata:
    name: escolalms-backend-pv-volume
    namespace: escolalms
    labels:
        type: local
spec:
    storageClassName: ""
    capacity:
        storage: 5Gi
    accessModes:
        - ReadWriteOnce
    hostPath:
        path: /var/www/html/storage
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
    name: escolalms-backend-pv-claim
    namespace: escolalms
spec:
    storageClassName: ""
    accessModes:
        - ReadWriteOnce
    resources:
        requests:
            storage: 5Gi
