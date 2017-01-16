#!/bin/sh


set -euxo pipefail

SERVICES="delete_mysql delete_rabbitmq delete_all_pvc"

delete_mysql() {
  kubectl delete statefulset mysql || true
  kubectl delete job mysql-bootstrap || true
  kubectl delete service mysql || true
  kubectl delete configmap mariadb-kolla-config || true
}

delete_rabbitmq() {
  kubectl delete statefulset rabbitmq || true
  kubectl delete service rabbitmq || true
  kubectl delete configmap rabbitmq-kolla-config || true
}

delete_all_pvc() {
  kubectl get pvc -o name | xargs -n1 kubectl delete || true
}

case "${1:-all}" in
  mysql)
    SERVICES="delete_mysql"
  ;;
  rabbitmq)
    SERVICES="delete_rabbitmq"
  ;;
  all_pvc)
    SERVICES="delete_all_pvc"
  ;;
  *)
  ;;
esac

echo "Deleting the following services: "
echo $SERVICES

for service in $SERVICES;
do
  $service
done
