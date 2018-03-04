app = "terraform-ecs"

aws_profile = ""

aws_region = "us-east-1"

aws_key_pair = "foo"

ssh_ips = ["174.125.104.63/32"]

app_repositories = ["nginx"]

app_ports = [80]

app_memory_repositories = [50]

instance_type = "t2.micro"

instance_number = 1

lb_healthy_threshold = "2"

lb_unhealthy_threshold = "2"

lb_health_check_path = "api"

lb_port = "80"

lb_protocol = "HTTP"

lb_timeout = "5"

lb_interval = "30"

availability_zones = ["us-east-1a"]
