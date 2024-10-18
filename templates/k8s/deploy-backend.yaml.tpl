apiVersion: apps/v1
kind: Deployment
metadata:
  name: escolalms-backend
  namespace: escolalms
spec:
  selector:
    matchLabels:
      app: escolalms-backend
      component: backend
  template:
    metadata:
      labels:
        app: escolalms-backend
        component: backend
    spec:
      containers:
      - name: escolalms-backend
        image: escolalms/api:latest
        command: ["/bin/sh"]
        args: ["-c", "/docker-entrypoint.sh && /var/www/html/init.sh && php artisan db:seed --force --no-interaction && chown -R devilbox:devilbox /var/www/html && /usr/bin/supervisord -c /etc/supervisor/supervisord.conf"]
        imagePullPolicy: Always
        env:
        - name: DISABLE_HORIZON
          value: "true"
        - name: DISABLE_SCHEDULER
          value: "true"
        envFrom:
        - configMapRef:
            name: laravel-config
        ports:
          - containerPort: 80
        volumeMounts:
            -   name: escolalms-backend-persistent-storage
                mountPath: /var/www/html/storage
      volumes:        
          - name: storage
            hostPath:
              path: "/mnt/escolalms/storage"
          - name: escolalms-backend-persistent-storage
            persistentVolumeClaim:
              claimName:  escolalms-backend-pv-claim
                             
---
apiVersion: v1
kind: Service
metadata:
    name: escolalms-backend-service
    namespace: escolalms
spec:
    selector:
        app: escolalms-backend
    type: ClusterIP
    ports:
        -   port: 80
            targetPort: 80