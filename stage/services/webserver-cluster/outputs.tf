output "alb_dns_name" {
  value = module.webserver_cluster.alb_dns_name
  description = "The domain namoe of the load balancer"
}
