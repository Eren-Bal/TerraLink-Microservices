provider "aws" {
  region = "us-east-1"
}

# 1. SSH ANAHTARI (AWS'ye Tanıtma)
resource "aws_key_pair" "sunucu_anahtari" {
  key_name   = "devops-project-key"
  public_key = file("C:/Users/LENOVO/Desktop/DERS VE EĞİTİM/DevOps/devops-project/terraform/devops-key.pub")
}

# 1. GÜVENLİK DUVARI (Frontend:3000, API:5000, SSH:22)
resource "aws_security_group" "app_sg" {
  name        = "url-shortener-sg"
  description = "Uygulama portlarina izin ver"

  # Frontend (React)
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Backend (API)
  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Dışarı çıkış serbest
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 2. SANAL SUNUCU (EC2)
resource "aws_instance" "app_server" {
  ami           = "ami-0c7217cdde317cfec" # Ubuntu 22.04
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  tags = {
    Name = "TerraLink-Microservices"
  }

  key_name = aws_key_pair.sunucu_anahtari.key_name

  # 3. BAŞLANGIÇ SCRİPTİ
  # Sunucu açılınca Docker kuracak ve bizim imajları indirip çalıştıracak.
  user_data = <<-EOF
              #!/bin/bash
              
              # 1. Docker Kurulumu için gereklidir
              sudo apt-get update -y
              sudo apt-get install -y docker.io docker-compose

              # Docker servisini başlatır
              sudo systemctl start docker
              sudo systemctl enable docker
              
              # Kullanıcıyı docker grubuna ekler
              sudo usermod -aG docker ubuntu

              # 2. docker-compose.yml Dosyasını Oluşturur.
              cat <<EOT >> /home/ubuntu/docker-compose.yml
              version: '3.8'
              services:
                api:
                  image: erenbal/url-shortener-api:v1
                  ports:
                    - "5000:5000"
                  environment:
                    - REDIS_HOST=redis_db
                  depends_on:
                    - redis_db
                
                ui:
                  image: erenbal/url-shortener-ui:v1
                  ports:
                    - "3000:3000"
                
                redis_db:
                  image: redis:alpine
                  ports:
                    - "6379:6379"
              EOT

              # 3. Sistemi Başlat
              cd /home/ubuntu
              sudo docker-compose up -d
              EOF
}

output "ui_linki" {
  value = "http://${aws_instance.app_server.public_ip}:3000"
}

output "api_linki" {
  value = "http://${aws_instance.app_server.public_ip}:5000"
}