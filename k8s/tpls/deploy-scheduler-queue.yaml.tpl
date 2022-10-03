apiVersion: apps/v1
kind: Deployment
metadata:
  name: escolalms-scheduler-queue
  namespace: escolalms
spec:
  selector:
    matchLabels:
      app: escolalms-scheduler-queue
      component: backend
  template:
    metadata:
      labels:
        app: escolalms-scheduler-queue
        component: backend
    spec:

      containers:
      - name: escolalms-scheduler-queue
        image: escolalms/api:latest
        command: ["/bin/sh"]
        args: ["-c", "/docker-entrypoint.sh && chown -R devilbox:devilbox /var/www/html  &&  /usr/bin/supervisord -c /etc/supervisor/supervisord.conf"]
        imagePullPolicy: Always
        env:
        - name: DISBALE_PHP_FPM
          value: "true"
        - name: DISBALE_NGINX
          value: "true"
        envFrom:
        - configMapRef:
            name: laravel-config
        volumeMounts:
            -   name: escolalms-backend-persistent-storage
                mountPath: /var/www/html/storage
      volumes:
          -   name: escolalms-backend-persistent-storage
              persistentVolumeClaim:
                  claimName:  escolalms-backend-pv-claim
---
apiVersion: v1
kind: Service
metadata:
    name: escolalms-scheduler-queue-service
    namespace: escolalms
spec:
    selector:
        app: escolalms-scheduler-queue
    type: ClusterIP
    ports:
        -   port: 80
            targetPort: 80