apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: main-ingress
  namespace: escolalms
spec:
  rules:
  - host: backend.localhost
    http:
      paths:
        - path: /
          pathType: Prefix
          backend:
            service:
              name: escolalms-backend-service
              port:
                number: 80
  - host: demo.localhost
    http:
      paths:
        - path: /
          pathType: Prefix
          backend:
            service:
              name: escolalms-frontend-service
              port:
                number: 80
  - host: admin.localhost
    http:
      paths:
        - path: /
          pathType: Prefix
          backend:
            service:
              name: escolalms-admin-service
              port:
                number: 80
  - host: mailhog.localhost
    http:
      paths:
        - path: /
          pathType: Prefix
          backend:
            service:
              name: escolalms-mailhog-service
              port:
                number: 8025